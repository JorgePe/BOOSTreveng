# BOOSTreveng

Documenting my findings on reverse engineering the LEGO BOOST Hub.
My main interest is using Linux (MINDSTORMS EV3 with ev3dev) but this information might be usefull to everybody.

DISCLAIMER:
LEGO and BOOST are Trademarks from The LEGO Company, which doesn not support (probably even know about) this project.
And of course I'm not responsible for any damage on your LEGO BOOST Hub.

Method:
I'm using an ubertooth BLE sniffer, on my Ubuntu laptop. Installed LEGO BOOST Hub on my Android phone (Huawey P8, not supported but it works, just need to get the full APK+OBB).

It's not easy to get consistent results. I'm using Wireshark and a filter for ATT protocol ("btl2cap.cid==0x004"). Have to try several times until I capture something - it seems that restarting Bluetooth on Android and restarting App helps. Also disabling my laptop internal BT and not running heavy programs seems to help.
