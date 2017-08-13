# BOOSTreveng

Documenting my findings on reverse engineering the LEGO BOOST Move Hub.

My main interest is using Linux (MINDSTORMS EV3 with ev3dev) but this information might be usefull to everybody.

In Linux (Ubuntu) I usually use the gatttool command (from bluez 5) for simple bash scripts and pybluez (or just gattlib, https://bitbucket.org/OscarAcena/pygattlib) for python scripts. Usually same scripts run fine on ev3dev but since bluez, pybluez
and the linux kernel are a bit bewind Ubuntu sometimes I need to call gatttool from python.

You should also see this project that implements a swift App for iOS:
https://github.com/bricklife/BoostRemote

**DISCLAIMER:**

LEGO and BOOST are Trademarks from The LEGO Company, which doesn not support (most probably don't even know about) this project.
And of course I'm not responsible for any damage on your LEGO BOOST Hub.

Method:
I'm using an ubertooth BLE sniffer, on my Ubuntu laptop. Installed LEGO BOOST Hub on my Android phone (Huawey P8, not supported but it works, just need to get the full APK+OBB).

It's not easy to get consistent results. I'm using Wireshark and a filter for ATT protocol ("btl2cap.cid==0x004"). Have to try several times until I capture something - it seems that restarting Bluetooth on Android and restarting App helps. Also disabling my laptop internal BT and not running heavy programs seems to help.

Progress so far:
- RGB LED color control
- Motors (A, B, A+B, C, D) speed/timed control (also angle control but not complete yet)
- A bash script with a short example on how to control motors (soon also in python)

Issues:
- although gatttool works fine, I'm having problems with gattlib
