# BOOSTreveng

Documenting my findings on reverse engineering the LEGO BOOST Move Hub.

My main interest is using Linux (MINDSTORMS EV3 with ev3dev) but this information might be usefull to everybody.

In Linux (Ubuntu) I usually use the gatttool command (from BlueZ 5) for simple bash scripts and pybluez (or just gattlib, https://bitbucket.org/OscarAcena/pygattlib) for python scripts. Usually same scripts run fine on ev3dev but since bluez, pybluez
and the linux kernel are a bit behind Ubuntu sometimes I need to call gatttool from python as a workaround.

You should also see these other projects:
- [BoostRemote](https://github.com/bricklife/BoostRemote) - a swift App for iOS
- [movehub](https://github.com/hobbyquaker/node-movehub) - a Node.js interface

**DISCLAIMER:**

LEGO and BOOST are Trademarks from The LEGO Company, which does not support (most probably doesn't even know about) this project.
And of course I'm not responsible for any damage on your LEGO BOOST devices.

Method:
I'm using an ubertooth BLE sniffer with my Ubuntu laptop. Installed LEGO BOOST App on my Android phone (Huawey P8, not supported but it works, just need to get the full APK+OBB, there are a few sources like APKPure).

It's not easy to get consistent results. I'm using Wireshark and a filter for ATT protocol ("btl2cap.cid==0x004"). Have to try several times until I capture something useful - it seems that restarting Bluetooth on Android and restarting App helps. Also disabling my laptop internal BT and not running heavy programs seems to help.

Progress so far:
- RGB LED color control
- Motors (A, B, A+B, C, D) speed/timed control (also angle/rotation control but not complete yet)
- Color Sensor- can identify colors
- Distance Sensor - can measure distances
- Motor rotation readings (A, B, A+B, C, D)
- Button state reading
- MIT App Inventor 2 released last month a new version of the [BLE extension](http://iot.appinventor.mit.edu/assets/resources/edu.mit.appinventor.ble.aix) with lots of new features... and it works!

Content:
- unorganized details of what I've found
- a few bash scripts for Linux, even fewer python scripts also for Linux and one or two Android MIT AppInventor examples
- some text files trying to explain how to use bash or python

Things will look somewhat chaotic for a while. Please accept that I lack a programming background and also that I'm not writing a book.

Roadmap:
- Move Hub 6-axis tilt sensor readings [on progress]
- Color sensor colored-light mode
- Color sensor ? light intensity ?

Totally blind yet:
- battery level - why didn't LEGO used the standard characteristic?!?
- scan hardware configuration, detect changes

Issues:
- ~~although gatttool works fine, I'm having [problems with gattlib](https://github.com/JorgePe/BOOSTreveng/issues/4)~~
- ~~MIT AppInventor 2  is a pain, I believe I'm having a similar problem with encoding~~

I really don't understand why LEGO developers opted to put everything in just one handle. It forces us to send a long string even for simple commands, which increases latency. Using MIT App Inventor 2 (and probably other blockly languages like Scratch) with long commands gets difficult and clumsy.

. 
