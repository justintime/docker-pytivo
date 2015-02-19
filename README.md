# Summary
This is a Dockerfile for the lucansnz version of pyTivo

# Installation
There isn't really any installation, but you need to have Docker installed.  Consult [the official Docker documentation ](https://docs.docker.com/installation/) for full details, but see below for Ubuntu 14.04.

## Install docker on Ubuntu 14.04
To install Docker on a fresh install of Ubuntu 14.04 Server:
```bash
sudo su -
[ -e /usr/lib/apt/methods/https ] || {   apt-get update;  \
  apt-get install apt-transport-https; }
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get upgrade
apt-get install lxc-docker
```
# Running the pytivo container
The first run will pull the container image down to your local machine.

If you have a copy of `pyTivo.conf` you'd like to use, place it in the directory at `/path/to/config` as below before starting.  If you don't have one, no worries!  A default one will be created for you. 

For maximum flexibility on file transfers, run the containter in host mode:
```bash
docker run -d --net="host" --name="pytivo" -v /path/to/media/:/media \
  -v /path/to/config:/config -v /etc/localtime:/etc/localtime:ro justintime/pytivo
```

If you don't need to push files (see below), you can use bridge mode:
```bash
docker run -p 9032:9032 -p 2190:2190/udp -d -h pytivo --name="pytivo" -v /path/to/media/:/media \
  -v /path/to/config:/config -v /etc/localtime:/etc/localtime:ro justintime/pytivo
```
# Configuration
If you already had a `pyTivo.conf` file, you're done!  If not, follow these steps:

* http://server-running-docker:9032/ and click "settings"
* Select "Global Server Settings"
* No need to set paths for ffmpeg, tivodecode and tdcat, they will be found automatically
* Optionally, set the beacon to the IP address of your Tivo, followed by " listen".  i.e.: "192.168.1.5 listen"
* Set your tivo_username and tivo_password if you want to push files to your TiVo
* Set your tivo_mak if you want tivodecode to automatically decrypt the .tivo file to .mpg
* Set the togo_path to /media or whatever is appropriate for your system
* Click "Save Changes"
* Select "MyMovies"
* Set the path to /media or whatever is appropriate for your system
* Click "Save Changes"
* Click "Restart pyTivo"
* After about 10 seconds, return to the pyTivo home page and you should see your Tivo in the list.

For additional help on the settings, see: http://pytivo.sourceforge.net/wiki/index.php/Configure_pyTivo

Not sure how to find your Tivo Mak? See http://lmgtfy.com/?q=what+is+my+tivo+mak

You have three options for transferring files:
* Using the pyTivo web interface, you can pull files from the Tivo.  
  The transfer will start immediately and there is an option to automatically decrypt the file.
  Note: If you have the option to "transfer as mpeg-ts" and it fails, try disabling it.
* Using the Tivo "Now Playing" interface, you can pull files from pyTivo.  
  The transfer will start immediately and they will automatically converted to a format the Tivo can handle.
* Using the pyTivo web interface you can push files to the Tivo.  
  This request goes through the Tivo.com servers so there is a random delay before the transfer starts.
  Once it starts, pyTivo will automatically convert the file to a format the Tivo can handle.

There are other pros and cons of each, for more info see http://lmgtfy.com/?q=pytivo+push+vs+pull

