FROM ubuntu

ARG USERNAME='your-username'
ARG USERID=1000
ARG GROUPID=100
ARG GROUPNAME='users'
RUN apt-get update
RUN apt-get install -y apt-utils 
RUN apt-get install -y dpkg 
RUN apt-get install -y ubuntu-restricted-addons
RUN apt-get install -y gdebi wget 
RUN apt-get install -y lsb-core lsb-security lsb-invalid-mta && \
    rm -rf /var/cache/aet/
RUN apt-get install -y sudo

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

RUN sh -c 'echo "deb http://dl.google.com/linux/earth/deb/ stable main" >> /etc/apt/sources.list.d/google-earth.list'

RUN apt-get update && \
    apt-get install -y xdg-utils google-earth* && \
    rm -rf /var/cache/aet/

ENV DISPLAY=':1'
ENV XAUTHORITY='/home/${USER}'

COPY container/usr/bin/earth-in-a-box.sh /usr/bin/earth-in-a-box.sh
COPY container/usr/bin/setup.sh /usr/bin/setup.sh
RUN chmod 755 /usr/bin/earth-in-a-box.sh /usr/bin/setup.sh
RUN setup.sh ${USERID} ${GROUPID} ${USERNAME}

# RUN groupadd -g "${GROUPID}" "${GROUPNAME}"
# RUN useradd -d "/home/${USERNAME}" -g "${GROUPID}"
# RUN groupadd -g 1000 ${USER}
# RUN useradd -d /home/${USER} -s /bin/bash -m ${USER} -u 1000 -g 1000

USER ${USERNAME}
VOLUME /home/${USER}/.googleearth

CMD /usr/bin/earth-in-a-box.sh
