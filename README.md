# Google Earth in a Docker Container

I run OpenSUSE Tumbleweed, which often keeps shared libraries at versions that binary-only applications have difficulties supporting.  I own a OneWheel and Google Earth Pro is a nice source for inspecting areas for useful paths/trails, finding interesting things, but it breaks -- often -- in Tumbleweed, even though the `.rpm` installs fine<sup>0</sup>

<sup>0</sup> This varies; sometimes `zypper` will report that a dependency cannot be met, other times it will hum along just fine, accepting the version that's there, but `segfault` when starting because even though the package can't see the conflict, the *app* doesn't work with the version installed.

## How?

I've wrapped it all up into a docker container and script which will build it, attempt to expose the necessary components and starts it.  It ... works ... with some limitations that I haven't worked out.

After cloning and navigating to the directory, type
 - `./earth-in-a-box`

Every time it is run that way it checks that the image and container exists, creates them if they do not, and starts Earth.

## Limitations

 - You need to have $XAUTHORITY, $DISPLAY, $USER and $HOME variables correctly assigned.  
 - Your user account needs to be in the docker group to run the script.
 - It works for me, on **OpenSUSE Tumbleweed**, with a lot of customizations
 - It requires `zsh` (only the `earth-in-a-box` script, this can be done via docker commands which should be pretty obvious)
 - I can't distribute the actual Google Earth Pro binary, that's Google's and it's forbidden. So a script downloads it for you.  If they change the URL or decide to stop offering it for free, this will stop working.

**BOTTOM LINE:** I wrote this for myself.  It works on in one or two places that I use Google Earth and it was a little bit of a pain to figure out.  It might not work for you.  If it doesn't, kick an issue out there, but I probably won't look into it if it involves installing a different version of Linux; it's just not that important to me.  I'm generally glad to help out, though, if time allows and you give me enough information to be useful.

## History

The idea sprung from [bcdbrule/google-earth on Docker Hub](https://hub.docker.com/r/bvdbrule/google-earth).  Unfortunately, the formatting screwed up the document and after sorting that out, it didn't work as well as I'd wanted so I tweaked it, popped it in a repo and Bob's your Uncle!

Ideally, one would just be able to visit Docker Hub, pull an image and follow the instructions to start it (or, perhaps, Earth would be available as a snap/AppImage/etc), but Google forbids distribution of Google Earth Pro; it's commercial.  I'm also not interested in violating Google's licenses, so there's no Google Earth Pro *anything* in this repository.  This script simply *creates* a new container and downloads Google Earth Pro from Google, for you.  If the link to the software disappears, this script will be useless.

You can't simply distribute Google Earth Pro; it's commercial.  Running `earth-in-a-box` downloads Google Earth directly from Google and builds a container for you, locally

## Plans

 - Figure out random black menus/dialogs
 - Since I'm on `nvidia` hardware, figure out if `nvidia-docker` and make that an option.  I can't, presently, because the version of the driver and the version of libraries necessary for that are temporary not possible to install on the same machine in the current repo state a few days ago.
 - Add some capabilities to the script to make it more convenient to rebuild/test/get debug info/etc once I determine if that's worth doing
 - Build in something to check for updates and re-build the container when that happens
 - Map the Google Earth settings volume to the user's home drive (HIGH PRIORITY)

## Known Issues

### My Testing is Limited - These Might Just Happen To Me

Both of my primary computers run OpenSUSE Tumbleweed and I use Google Earth mostly on laptops which have `nvidia` proprietary drivers running.  Some of the things that work, here, might work because of my odd setup -- the only place I've tested it.

#### Some Menus are Black-on-Black

A bit worse than blue-on-black,... Yeah... Crazy, huh?  If you have any hints/things you can point me at, please let me know in the Issues or however you want to reach out to me.  I poke at it from time to time.



This may only be happening on my workstation, which runs OpenSUSE Tumbleweed, the `nvidia` proprietary driver and Xorg