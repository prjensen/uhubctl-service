This was created to power cycle a specific usb hub port on a Raspberry Pi 3B+.
The device attached, while it was found during boot, was not fully initialized
until after pulling it and then plugging it in after boot.  This is a workaround
to needing to physically pull the usb connector out and re-plugging.  Why this
happens is still not identified, and *this is a workaround* - not ideal but
allows the RPi to reboot properly and subsequently start monitoring the device
attached to the usb port again.


# How to use this:

## Dependencies - uhubctl installed.  
Check your distribution package manager.  Raspbian bullseye installation was
accomplished with:

`sudo apt install uhubctl`

## Install/configure: 
1. Copy the sample-uhubctl.ini file to /etc/uhubctl.ini.
Edit the file to specify the usb hub and specific port that you want to cycle
(CMDVAR).  In the sample file, it power cycles port 5 on hub 1-1.  Read the
uhubctl man page for any other options you want to set or alter the file to
pass.  You can also set the location of the binary executable (BIN) to invoke
as well as a delay (DELAY) in seconds after the executable.

Find your device hub and port by looking at dmesg after plugging it in, or
lsusb, or other tooling...

2. Copy the uhubctl.sh to /usr/local/bin/uhubctl.sh.  Make sure that it is mode
'0744'.

3. Copy the uhubctl.service file to /etc/systemd/system/uhubctl.service and then
run: `sudo systemctl daemon-reload`

This new 'service' depends on udev and networking to be up before it will execute:
`After=systemd-udev-settle.service network.target`

Update the 'After' section for your use case

4. Enable the unit file:
`sudo systemctl enable uhubctl.service`

5. Optional - but highly recommended 
Edit your other service to depend on 'uhubctl.service' by adding:
`After=uhubctl.service` in the [Unit] section of your dependent service.  Note:
if you already have an 'After' defined, this is a space separated list, so just
add a space and append the 'uhubctl.service'.  You may need to "reset" your
'After' like so:
```
After=
After=1.service uhubctl.service
```
See the `man systemd` and `man systemd.unit` pages for more info.  This isn't a
systemd tutorial ;) 
**Don't forget to re-run** `sudo systemctl daemon-reload` **after you make changes**
**to any systemd unit files**
