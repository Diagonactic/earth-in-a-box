FROM ubuntu

ARG USERNAME='your-username'
ARG USERID=1000
ARG GROUPID=100
ARG GROUPNAME='users'
RUN apt-get update
RUN apt-get install -y apt-utils && \
    apt-get install -y dpkg && \
    apt-get install -y ubuntu-restricted-addons && \
    apt-get install -y gdebi wget && \
    apt-get install -y lsb-core lsb-security lsb-invalid-mta && \
    rm -rf /var/cache/aet/ && \
    apt-get install -y sudo

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/earth/deb/ stable main" >> /etc/apt/sources.list.d/google-earth.list' && \
    apt-get update

RUN apt-get install -y xdg-utils google-earth* && \
    rm -rf /var/cache/aet/

ENV DISPLAY=':1'
ENV XAUTHORITY='/home/${USER}'

COPY container/usr/bin/earth-in-a-box.sh /usr/bin/earth-in-a-box.sh

RUN chmod 755 /usr/bin/earth-in-a-box.sh

COPY container/usr/bin/setup.sh /usr/bin/setup.sh
RUN cd /usr/bin && chmod 755 setup.sh && ./setup.sh ${USERID} ${GROUPID} ${USERNAME}

USER ${USERNAME}
WORKDIR "/home/${USER}"
VOLUME /home/${USER}/.googleearth

CMD /usr/bin/earth-in-a-box.sh
