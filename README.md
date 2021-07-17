# Google Earth in a Docker Container on Tumbleweed

It isn't perfect, but it works!



## How?

Basically, Clone, Docker Build, Docker Run With a few parameters, Run

This is adapted from [bcdbrule/google-earth on Docker Hub](https://hub.docker.com/r/bvdbrule/google-earth), which wasn't clear enough for me to accomplish without a little additional research, so that's here.

```sh
git clone ...
docker build -t earth .
# ... Builds the 'earth' image; get some coffee ...
docker run \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY="$XAUTHORITY" \
    -h "${HOSTNAME}" \
    -v /dev/dri/card0:/dev/dri/card0 \
    -v "${XAUTHORITY}:${XAUTHORITY}" \
    -v "${HOME}/.Xauthority:/home/${USER}/.Xauthority" earth
# Note - /dev/dri/card0 needs to be pointed to the right place on your system; can also be left out, entirely, but it's much slower
```

## Why?

I'm an OpenSUSE Tumbleweed Linux user.  On two different occasions, a year apart, encountering three different problems, I've tried to get Earth working from the `.rpm` package they offer for download.  I was able to work around the `mesa-libGLU` issue, but several months ago cURL hit 7.75 on Tumbleweed.  Unfortunately, Earth segfaults on any version after 7.73.  Further, no warning was offered of the pending crater that was about to be Google Earth on my machine.  It would not have mattered, though, since several core libraries would have refused to install had I left things at prior versions.

## Where's The Container in Docker Hub?

This non-lawyer seems to be under the impression that distributing the not-at-all-open-source version of Google Earth Pro would probably cause this non-lawyer to need a laywer.  This dockerfile will update/download the latest version available via Google's servers.  

Of course, that means that this solution will work until Google decides to stop distributing Google Earth (or changes its URL if I fail to update this!)

services:

google-earth: 
  build: 
  context: . 
  dockerfile: ./dockerfile-google-earth 
  image: bvdbrule/google-earth:1.0 
  container_name: docker-google-earth 
  hostname: google-earth-host 
  environment:
    DISPLAY 
  volumes:
    /tmp/.X11-unix:/tmp/.X11-unix
    $PWD/googleearth:/root:rw

## Known Issues

### My Testing is Limited - These Might Just Happen To Me

Both of my primary computers run OpenSUSE Tumbleweed and I use Google Earth mostly on laptops which have `nvidia` proprietary drivers running.  Some of the things that work, here, might work because of my odd setup -- the only place I've tested it.

#### Some Menus are Black-on-Black

A bit worse than blue-on-black,... Yeah... Crazy, huh?  If you have any hints/things you can point me at, please let me know in the Issues or however you want to reach out to me.  I poke at it from time to time.



This may only be happening on my workstation, which runs OpenSUSE Tumbleweed, the `nvidia` proprietary driver and Xorg