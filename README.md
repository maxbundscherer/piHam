# piHam

## Screen

- Set resolution to `1280x720` (Menu > Preferences > Screen Configuration) (Default is `1024x600`)
- Set display mode to `medium` (Desktop > Desktop Configuration)

## Raspberry Pi 5 VNC Fix

Bookworm VNC Config

- Open `raspi-config` and set `x11` as default (`Advanced Options > Wayland`)
- Open `raspi-config` and enable VNC

## GPS

- Attach usb gps
- Test if device (`ttyACM0`) is in `ls /dev/tty*`
- Test if device has output with `sudo cat /dev/ttyACM0`
- Install gpsd with `sudo apt-get install gpsd gpsd-clients -y`
- Autoboot gpsd: Edit file `/etc/default/gpsd` like

```
# Devices gpsd should collect to at boot time.
# They need to be read/writeable, either by user gpsd or the group dialout.
DEVICES="/dev/ttyACM0"

# Other options you want to pass to gpsd
GPSD_OPTIONS="-n"

GPSD_SOCKET="/var/run/gpsd.sock"
#START_DAEMON="true"

# Automatically hot add/remove USB GPS devices via gpsdctl
USBAUTO="false"
```

- Reboot with `sudo reboot`

### Set time manually

- `sudo timedatectl set-ntp false`
- `sudo date --set "25 Sep 2013 15:00:00"`
- (`sudo timedatectl set-ntp true`)

### Set time based on gps

Raspberry uses timedatectl to set time not ntp. So we need to use chrony to set time based on gps. You can check status with `timedatectl status`.

- `sudo apt-get install chrony -y`
- Check service status of gpsd with `sudo systemctl status gpsd`
- Check service status of chrony with `sudo systemctl status chrony`
- Edit file `sudo vim /etc/chrony/chrony.conf` and add `refclock SHM 0 offset 0.5 delay 0.2 refid NMEA` and comment all stuff like `pool 2.debian.pool.ntp.org iburst` like

```
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usable directives.

# Include configuration files found in /etc/chrony/conf.d.
confdir /etc/chrony/conf.d

# Use Debian vendor zone.
#pool 2.debian.pool.ntp.org iburst

# Use time sources from DHCP.
#sourcedir /run/chrony-dhcp

# Use NTP sources found in /etc/chrony/sources.d.
#sourcedir /etc/chrony/sources.d

# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony/chrony.keys

# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/chrony.drift

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Uncomment the following line to turn logging on.
#log tracking measurements statistics

# Log files location.
logdir /var/log/chrony

# Stop bad estimates upsetting machine clock.
maxupdateskew 100.0

# This directive enables kernel synchronisation (every 11 minutes) of the
# real-time clock. Note that it can't be used along with the 'rtcfile' directive.
rtcsync

# Step the system clock instead of slewing it if the adjustment is larger than
# one second, but only in the first three clock updates.
makestep 1 3

# Get TAI-UTC offset and leap seconds from the system tz database.
# This directive must be commented out when using time sources serving
# leap-smeared time.
leapsectz right/UTC

refclock SHM 0 offset 0.5 delay 0.2 refid NMEA
```

- Reboot with `sudo reboot`

### Debug

- Test gps with `cgps -s`
- Check source with `chronyc sources` (should have `NMEA` as source)
- Check status with `chronyc tracking` (should have `NMEA` as source)
- Manually set time with `sudo chronyc makestep`
- Stop chrony with `sudo systemctl stop chrony`
- Stop gpsd with `sudo systemctl stop gpsd`
- Check which progress uses device with `sudo lsof /dev/ttyACM0` or `sudo lsof /dev/ttyUSB0`
- After desycn
    - Get device with `ls /dev/tty*`
    - Edit file `/etc/default/gpsd` (change device to `/dev/ttyACM1`)

## WSJTX

- Install with `sudo apt-get install wsjtx -y`
- Set audio input in WSJTX to `alsa_input.usb-Burr-Brown_from_TLUSB_Audio_CODEC-00.analog-stereo`
- Set audio output in WSJTX to `alsa_output.usb-Burr-Brown_from_TLUSB_Audio_CODEC-00.analog-stereo`

## FLDIGI

- Install with `sudo apt-get install fldigi -y`

## WFVIEW

- Install with `sudo apt-get install wfview -y`
