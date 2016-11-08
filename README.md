# physical-memories
An experimental piece involving a custom spatialized audio system, Music Information Retrieval, inner-ear distortion products, and mechatronic sound objects.

* [Introduction](#introduction)
* [Mechatronic Sound Objects](#mechatronic-sound-objects)
 * [Meepo](#meepo)
* [Music Information Retrieval](#music-information-retrieval)
 * [ChucK MIR Library](#chuck-mir-library)
* [Auditory Distortion Projects](#auditory-distortion-products)
 * [Cubic Distortion Tones](#cubic-distortion-tones)
* [Raspberry-Pi System](#raspberry-pi-system)
 * [Raspberry-Pi Setup (Ethel & Agnes)](#raspberry-pi-setup)
  * [Initial WIFI Setup](#initial-wifi-setup)
  * [ChucK/Chugins Installation](#chuck-chugins-installation)
  * [HiFiBerry Amp+ Setup](#hifiberry-amp+-setup)
  * [Putting Your Pi On a Private Network](#putting-your-pi-on-a-private-network)
  * [rc.local](#rc-local)

<a name="introduction"/>
## Introduction
This is the repository and overview of an ongoing project that utilizes various technologies in an experimental music performance, the intent of which is to fuse together the unamplified sound of machine noise with synthesized sine tones.

The primary compositional focus is in creating a performance that alternates the physical and harsh noise of mechatronics with the physical sensation of auditory distortion products. The idea is to drive a solenoid at a specific speed and velocity which results in the solenoid creating a tone; that tone will be analyzed by and then recreated as a auditory distortion product, which is an otoacoustic emission that is created by stimulating the basilar membrane of the inner ear. The alternation of these two sensations and the processes in which they are created will become the compositional process that guides the performance.

The distortion tones are also created using a wireless Raspberry Pi system. The real-time music programming language, [ChucK](http://chuck.cs.princeton.edu/release/), is installed on each of the Pis, and Open Sound Control messages are sent over a private network which controls the synthesized output of the Pis. This allows for an extremely portable and inexpensive system which does not require an audio interface. This sytem also allows for an extreme degree of control over the individual speaker placement, as the each Pi only requires power.

There are three main technologies that are being utilized in this project, those being Music Information Retrieval, mechatronics, and Auditory Distortion Products. A short introduction to these technologies along with their implementation will be described.

<a name="mechatronic-sound-objects"/>
## Mechatronic Sound Objects
This project uses mechatronic objects as a primary source of its auditory material. Much like the work of [Mo H. Zareei](http://m-h-z.net/), this project uses "a mechatronic instrument in which the buzzing of DC motors and actuation noises of solenoids are not to be perceived as some form of unwanted aural by-product, but as the instrument’s main sonic output."[[1]](#1)

The solenoids will be driven in a matter which ultimately results in a tones being created due to their velocity and frequency of actuation. The solenoids will also be striking on variety of different materials, which makes the production of audible tones a large area of experimentation.

<a name="1"/>
> [1] http://m-h-z.net/wp-content/uploads/2014/09/mutor_drone-chorus-of-metrically-muted-motors_camera-ready.pdf "Mutor: Drone Chorus of Metrically Muted Motors"

<a name="meepo"/>
### Meepo
A custom actuator shield will be used to control the solenoids, which allows serial communication to the solenoids using ChucK: https://github.com/ericheep/meepo

![Meepo shield](http://ericheep.com/images/meepo-2.jpg)

Here's a quick [Vimeo](https://vimeo.com/151490307) of the board in action.

<a name="music-information-retrieval"/>
## Music Information Retrieval
Music Information Retrieval is a growing field of research that extracts information from music. Generally, MIR consists of deciphering the result of a Fourier Transform and transforming that data in high-level information. In the scope of this project, the general frequencies that are created by the mechatronic instruments can be deciphered, which would then be recreated through otoacoustic emissions.

<a name="chuck-mir-library"/>
### ChucK MIR Library
I developed a small library of commonly used MIR functions that extend the extraction functionality of ChucK, which is located here: https://github.com/ericheep/mir-chuck/

![ChucK MIR Library Extracting MFCCs in Real Time](https://github.com/ericheep/mir-chuck/blob/master/images/mfccs.png?raw=true)

This library uses the Fast-Fourier Transformation process found in ChucK to extract features, such as the spectral centroid, the spectral spread, the spectral crest, and other low-level descriptors. The above image is a screenshot of Mel Frequency Cepstrum Coefficients being extracted in real time.

This library can also transform the FFT bins into a Mel Bands, Constant Q bins, or a Chromagram. The implementation of this library will allow for the mechatronic tones to be analyzed in real-time, and that information can then be considered in the creation of the Auditory Distortion Products.

<a name="auditory-distortion-products"/>
## Auditory Distortion Products
A combination tone is the result of two tones tuned at different frequencies and played simultaneously, creating a third tone which is heard independently of the original two tones. If the original two tones are tuned to specific frequencies, and played at an appropriate volume, the combination tone that results can stimulate the inner ear, creating a tone that is the result of the physical distortion of the cochlear. It is more accurately described as "the direct stimulation of the basilar membrane that gives rise to a perception of sound", as opposed to an "acoustic emission in the ear canal [[2]](#2)

Composers have been exploring this terrain for quite some time and it has become an emerging topic in music research. Maryanne Armacher expressed delight at the phenomena; 'that my "ears were emitting sounds" as well as recieving them, that is hearing other acoustically produced tones at the same time, was incredible to me!'[[3]](#3). Alex Chichile recently released *The Ear Tone Toolbox*, which is a "collection of open source unit generators for the production of auditory distortion product synthesis."[[4]](#4) Phil Niblock would usually work outside-in when utilizing distortion products, as he "applies microtonoal pitch shifts and spectral alterations in order to enhance the audibility and predominance of the naturally occurring combination tones, as well as to introduce new ones."[[2]](#2)

What results from all this is a *physical* music. It is music which manipulates the ear into experiencing "subjective sounds that are evoked by physical acoustic signals and generated by the active components of the cochlear." [[2]](#2)

The two most common types of distortion tones are the Quadratic Distortion Tone and the Cubic Distortion Tone, and are described by the following.

Quadratic Distortion Tone:

    QDT = f2 - f1,  f2 > f1

Cubic Distortion Tone:

    CDT = 2f1 - f2, f2 > f1

<a name="2"/>
> [2] http://www.mitpressjournals.org/doi/pdf/10.1162/COMJ_a_00265 "Sound Synthesis with Auditory Distortion Products"

<a name="3"/>
> [3] http://www.sonami.net/Articles/Amacher-OAE.pdf "Psychoacoustic Phenomena in Musical Composition: Some Features of a "Perceptual Geography"

<a name="4"/>
> [4] https://ccrma.stanford.edu/~chechile/eartonetoolbox/Chechile_ICMC16.pdf "The Ear Tone Toolbox for Auditory Distortion Product Synthesis"

<a name="cubic-distortion-tones"/>
### Cubic Distortion Tones

This project at this stage is primarily focusing on Cubic Distortion Tones as opposed to Quadratic Distortion Tones. QDTs often have to be "presented at a level that is uncomfortable for most listeners,"[[2]](#2) whereas CDTs are less dependent on sound pressure level and more dependent on the frequency range and frequency separation of the original two tones.

This makes the creation of CDTs less predictable, but it is ideal for my aesthetic. The experimental nature of this music does not guarantee that distortion products are always present during performance, but rather drift in and out of perception based on the ratio between the original two tones. Additionally, it is possible to modify the ratio of the CDT instead of the frequency of the CDT itself, allowing a static fundamental in the presence of shifting tones. This ensures that the tone originally derived from the mechatronic actuation remains static among shifting tones.

This is done by using the CDT in combination with ratio to derive the other two tones.

    f1 = CDT/(2 - ratio),   1.0 < ratio < 2.0
    f2 = 2f1 - CDT,         f2 < f1

This table specifies some of the natural harmonic chords that can be created using certain harmonic ratios. [[2]](#2)

    f2/f1 | f1:f2 | Interval | 2f1 - f2:f1:f2 | Resulting Chord
    ------|-------|----------|----------------|----------------
    1.25 | 4:5 | Major Third | 3:4:5 | Major Triad
    1.2 | 5:6 | Minor Third | 4:5:6 | Major Triad
    1.166| 6:7 | ~Minor Third | 5:6:7 | ~Diminished Chord
    1.1428 | 7:8 | ~Major Second | 6:7:8 | Non-tertian Triad
    1.125 | 8:9 | Major Second | 7:8:9 | ~Whole-tone Triad
    1.111 | 9:10 | Major Second | 8:9:10 | Whole-tone Cluster

By utilizing Music Information Retrieval on the tones created by the mechatronic sound sculptures, a triadic chord can be created whose fundamental is reinforced by the auditory distortion product. While distortion products are generally masked by sound in the same range, it can still be used after the sound of the mechatronics has receded. This allows for a physical sensation to replace the the physical sound of the mechatronics. The expected CDT can be tuned to the fundamental of the mechatronics, fusing the physical characteristics of the two compositional materials.

Much like the research done by Alex Chichile[[5]](#5), the interactions of these processes allows for spatial depth to develop that is not present in typical music. Furthermore, the Raspberry Pi speaker system allows for the CDTs to be produced in independent speakers and increases the amount of primary tones that can be experienced.

<a name="5"/>
> [5] http://alexchechile.com/documents/Chechile_Spatial_Depth_Using_DPOAE_in_Music_ICAD2015.pdf "Creating Spatial Depth Using Distortion Product Otoacoustic Emissions In Music Composition"

<a name="raspberry-pi-system"/>
## Raspberry-Pi System
The synthesized audio in this project is made using a custom Raspberry Pi network, which is currently using two Raspberry Pi 3s, two HiFiBerry Amp+ shields, and four speakers. This allows for the auditory distortion products to be created from a variety of sources and also allows for a very portable setup, ensuring that this performance is not dependent on pre-installed multi-channel system.

<a name="raspberry-pi-setup"/>
### Rapsbery-Pi Setup(`ethel` & `agnes`)
Install a fresh [Raspian](https://www.raspberrypi.org/downloads/noobs/), and then
do some basic configuration. I named my Pis `ethel` and `agnes`, and set my keyboard type to US.

<a name="initial-wifi-setup"/>
#### Initial WIFI Setup

Next, we'll need to enable the WIFI; I'm using Raspberry Pi 3s, so I'll be using
the onboard WIFI for now. To add an existing network, edit your `wpa-supplicant.conf`
file using the `nano` file editor.

    sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

And then add this block of text to the bottom of the `.conf` file.

    network={
        ssid="your_network"
        psk="your_passkey"
    }

You can test that this is working by either rebooting `sudo reboot` or by disabling and
enabling your WIFI.

    sudo ifdown wlan0
    sudo ifup wlan0

Then you can using `ifconfig` to see if your Pi has an IP and a network it is connected to.

Next, and this is only pertinent to the Raspberry Pi3, we have the option to disable
the WIFI power saving feature. This will ensure that our Pis do not disconnect from the
internet during a period of inactivity, to do this we'll modify the `interfaces` file.

    sudo nano /etc/network/interfaces

And then underneath the `iface wlan0 inet manual` line add the following.

    post-up iw dev $IFACE set power_save off

Altogether, the interfaces file should look like this.

    allow-hotplug wlan0
    iface wlan0 inet manual
        post-up iw dev $IFACE set power_save off
        wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

At this point I recommend installing `ChucK` and it's dependencies and cloning this
repository onto your Pi. Which is shown in the next section.

<a name="chuck-chugins-installation"/>
#### ChucK/Chugins Installation

To install ChucK, we'll first need a few dependencies, this section requires that
your Pi is connected to the internet, which is outlined in the above section.

You can use `apt-get` to install these dependencies.

    sudo apt-get install bison flex
    sudo apt-get install alsa-base libasound2-dev libasndfile1-dev

Use `git` (which comes installed by default on Raspbian) to clone ChucK. Choose a
directory to install into, I usually create a `git` folder in the home directory, and then clone ChucK into there.

    mkdir ~/git
    cd ~/git
    git clone https://github.com/ccrma/chuck

Then we'll have to navigate into the `chuck/src` and `make` the ChucK build.

    cd chuck/src
    make linux-alsa

And install using the following `make` command while in the same directory.

    sudo make install

This project is using a custom Chugin (think ChucK plugin) which did not install
with your ChucK build, so you'll have to clone that repo to. Change back to your
specified `git` directory, (again, I used `~/git`) and clone the Chugins repo.

    git clone https://github.com/ccrma/chugins

Then navigate into the `chugins/winfuncenv/` directory and build the Chugin.

    cd ~/git/chugins/winfuncenv
    make linux-alsa

And if all's well, install it.

    sudo make install

ChucK should be ready to go! At this point, you should go ahead and clone this
repo as well.

    cd ~/git
    git clone https://github.com/ericheep/physical-memories

<a name="hifiberry-amp+-setup"/>
#### HiFiBerry Amp+ Setup

This project is using the amp shields from [HiFiBerry](https://www.hifiberry.com/),
so we'll need to disable the default soundcard and instead use the DAC on the amp.

We'll need to edit our `/boot/config.txt` on our Pi. So `nano` into it.

    sudo nano /boot/config.txt

And remove or comment out the default soundcard.

    dtparam=audio=on

Then replace it with this HiFiBerry

    dtoverlay=hifiberry-amp

And that's it! ChucK will automatically use the amp now.

<a name="putting-your-pi-on-a-private-network"/>
#### Putting Your Pi On a Private Network

This project uses a dedicated router for its communication, this ensures that
and network traffic doesn't have to compete with competing signals, and also enables
each Pi to have a static IP address.

Like before, I'll have to edit my `wpa-supplicant.conf` file and change to the proper
network.

To set a static IP, we'll have to edit the `/etc/dhcpcd.conf` file, but first we'll
need to know the router's IP address. To find it, type in `netstat -nr`, the router's
IP will be listed under `Gateway`, it should look something like the following.

    Destination     Gateway         Genmask         Flag    MSS Window  irtt Iface
    0.0.0.0         192.168.X.X     0.0.0.0         UG      0 0         0 wlan0
    192.168.1.0     0.0.0.0         255.255.255.0   U       0 0         0 wlan0

Then type on `sudo nano /etc/dhcpcd.conf` to edit the `dhcpcd.conf` file, at the bottom, add the following.

    interface wlan0

    static ip_address=192.168.1.10/24       #put your desired IP address here, with the /24 after it
    static routers=192.168.X.X              #put your router's IP address here, in place of the 192.168.X.X
    static domain_name_servers=192.168.X.X  #same IP address as the above line

Reboot to make sure that your IP is to what you set it, and you're still on the network, then you should be good to go.

This project is using two Pis, `agnes` & `ethel`.

`agnes` will be set to `192.168.1.10`, and `ethel` will be set to `192.168.1.20`.

<a name="rc-local"/>
#### rc.local

The last step, is to tell your Pi to boot the ChucK script on boot, and this can
but done by editing your `etc/rc.local` file.

This is the scariest part, because if you forget to tell your program to run in the
background, then your Pi will be locked out. Generally on a command line, you tell
a program to run in the background by placing an `&` after the command. We'll add the
following line to our `rc.local`.

    chuck /pi/home/git/physical-memories/pi/run-pi.ck &

Now the Pis should start the script on boot.
