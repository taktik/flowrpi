# flowrpi

An OpenEmbedded distribution for RaspberryPi optimised for visual communication/digital signage. The image includes WPEWebkit and an OMX based driver for gstreamer.

Setting up workspace

you need to have repo installed and use it as:

```shell
mkdir ~/bin
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
```

Download source:

```shell
PATH=${PATH}:~/bin
mkdir flowrpi
cd flowrpi
repo init -u https://github.com/kraj/flowrpi
repo sync
repo start work --all
```

At the end of the commands you have every metadata you need to start work with.

To start a simple image build:
```shell
source ./setup.sh
bitbake wpe-eglfs-image
```
The source code is checked out at ```<TOPDIR>/sources``` folder

Create Bootable SD-Card
 
 ```shell
sudo dd if=tmp/deploy/images/raspberrypi3/wpe-eglfs-image-raspberrypi3.rpi-sdimg of=/dev/sdX
 ```
 
where X is the letter a,b,c which your box would have mounted the uSD card on you can check that with dmesg | tail -10
when you insert the card into your computer.
 
Once booted login as ‘root’ with no password
 
Run
```shell
wpe https://youtube.com/tv
 ```
This should result in WPE launched on screen and you can try to play a video manually
 
Or you can launch a video like
 ```shell
wpe https://www.youtube.com/tv#/watch/video/control?v=-YGDyPAwQz0&resume
 ```
which will play one video automatically
 
Second test is to run big bunny video launch it like
 ```shell
gst-launch-1.0 souphttpsrc location="http://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_720p_h264.mov" ! typefind ! qtdemux name=demux demux. ! queue ! h264parse ! omxh264dec ! glimagesink demux. ! queue ! faad ! autoaudiosink
```
With systemd if dhcp does not work then you have to set /etc/resolv.conf symlink correctly.

```shell
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```
