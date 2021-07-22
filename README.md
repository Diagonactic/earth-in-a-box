# Google Earth in a Docker Container

I run OpenSUSE Tumbleweed, which often keeps shared libraries at versions that binary-only applications have difficulties supporting.  I own a OneWheel and Google Earth Pro is a nice source for inspecting areas for useful paths/trails, finding interesting things, but it breaks -- often -- in Tumbleweed, even though the `.rpm` installs fine<sup>0</sup>

<sup>0</sup> This varies; sometimes `zypper` will report that a dependency cannot be met, other times it will hum along just fine, accepting the version that's there, but `segfault` when starting because even though the package can't see the conflict, the *app* doesn't work with the version installed.

## How?

I've wrapped it all up into a docker container and script which will build it, attempt to expose the necessary components and starts it.  It ... works ... with some limitations that I haven't worked out.

After cloning and navigating to the directory, type
 - `./earth-in-a-box`

Every time it is run that way it checks that the image and container exists, creates them if they do not, and starts Earth.  It executes *without disabling* `shm` *via the QT environment variable*; overall, performance appears on-par with how it *used* to work when I could simply run it locally.

## Limitations

 - You need to have $XAUTHORITY, $DISPLAY, $USER and $HOME variables correctly assigned.  
 - Your user account needs to be in the docker group to run the script.
 - It works for me, on **OpenSUSE Tumbleweed**, with a lot of customizations; it may not work for you but I hope it does.
 - The script to run everything requires `zsh`
 - I can't distribute the actual Google Earth Pro binary, that's Google's and it's forbidden. So it's done via the package repository when building the docker file.  If they change the URL or decide to stop offering it for free, this will stop working.

**BOTTOM LINE:** I wrote this for myself.  It works on in one or two places that I use Google Earth and it was a little bit of a pain to figure out.  It might not work for you.  If it doesn't, kick an issue out there, but I probably won't look into it if it involves installing a different version of Linux; it's just not that important to me.  I'm generally glad to help out, though, if time allows and you give me enough information to be useful.

## Change Highlights

21-Jul-2021 - Fixed black on black / corrupted menus.  The issue was resolved with the addition of `--ipc host`, though other changes made may have been required

## About

The idea sprung from [bcdbrule/google-earth on Docker Hub](https://hub.docker.com/r/bvdbrule/google-earth).  Unfortunately, the formatting screwed up the document and after sorting that out, it performed very poorly on my hardware and had a bug where menus/dialogs would occasionally be black/corrupted.

Ideally, one would just be able to visit Docker Hub, pull an image and follow the instructions to start it (or, perhaps, Earth would be available as a snap/AppImage/etc), but Google forbids distribution of Google Earth Pro; it's commercial.  I'm also not interested in violating Google's licenses, so there's no Google Earth Pro *anything* in this repository.  This script simply *creates* a new container and downloads Google Earth Pro from Google, for you.  If the link to the software disappears, this script will be useless.

You can't simply distribute Google Earth Pro; it's commercial.  Running `earth-in-a-box` downloads Google Earth directly from Google and builds a container for you, locally.

## Plans

 - Since I'm on `nvidia` hardware, figure out if `nvidia-docker` and make that an option. 
 - Build in something to check for updates and re-build the container when that happens.

## Minor To Dos
 - Investigate exactly what resolved the broken menus among `--ipc host` `--device ...`, `--shm-size 0` and removal of `/dev/shm` volume.
 - Determine exactly what `--device` does, if `-v <card>:<card>` is needed with it
 - Determine the right value for `--shm-size` make sure `-v /dev/shm:/dev/shm/` doesn't slow things down.

## Known Issues

### My Testing is Limited - These Might Just Happen To Me

Both of my primary computers run OpenSUSE Tumbleweed and I use Google Earth mostly on laptops which have `nvidia` proprietary drivers running.  Some of the things that work, here, might work because of my odd setup -- the only place I've tested it.

You may need to worry about `cgroups` and `apparmor` profiles, but I didn't.  If you send me a PR, I'm happy to review/apply if it doesn't break anything.  Good luck to ya' though, this is very much an "on-the-side" project; and it's written in `zsh`/`bash` and `Dockerfile`!

Current Research:

 - https://stackoverflow.com/questions/24095968/docker-for-gui-based-environments/55989420#55989420
 - https://stackoverflow.com/questions/35040020/gui-qt-application-in-a-docker-container/35040140#35040140
 - https://stackoverflow.com/questions/52501594/qt-app-ui-elements-randomly-rendered-as-blank-black-in-docker (unhelpful)


This may only be happening on my workstation, which runs OpenSUSE Tumbleweed, the `nvidia` proprietary driver and Xorg