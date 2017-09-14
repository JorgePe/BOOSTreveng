# 6-axis tilt

The BOOST Move Hub has an internal 6-axis tilt sensor.

I used the 13th orange block to capture BLE communications, found 4 commands:

```
0a:00:41:3a:00:01:00:00:00:01
0a:00:41:3a:02:01:00:00:00:01
0a:00:41:3a:03:01:00:00:00:01
0a:00:42:3a:01:00:30:00:20:01
```

Last one does nothing and the 3rd one activates something but got nothing.

## Command Structure

As usual, first byte is length and second byte is something like packet version, third is message type (0x41 is subscribe to sensor). Byte 4 is port - 0x3a is Tilt sensor port. 

Byte 5 is tilt sensor mode:
- 0x00 - 2 axis precise  
- 0x01 - 2 axis simple (90º step)
- 0x02 - 3 axis simple
- 0x03 - bump detect mode - counts hard bumps
- 0x04 - 3 axis precise
- 0x05 - ?? accepted but does nothing?
- 0x06 - ?? accepted but does nothing?
- 0x07 - ?? accepted but does nothing?

Byte 6 is notification granularuty. The value seems to be degrees. Probably makes sense only for mode 0x00 and 0x04. Might have other meaning for other modes. 

Byte 7 can be higher byte of granularity. 

Byte 8 - ??
Byte 9 - changing it had no effect
Byte 10 - ?? changing it to any value except 0 caused further attempts to read from sensor to give no result

Byte 10 (last byte) toggles subscription, 0x01 enables it, 0x00 disables it.

## Notifications
2nd one activates a mode like the WeDo 1/2 tilt sensors, only for two axis:

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100; gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a00413a020100000001 --listen
Characteristic value was written successfully
Characteristic value was written successfully
Notification handle = 0x000e value: 0a 00 47 3a 02 01 00 00 00 01 
Notification handle = 0x000e value: 05 00 45 3a 00 

roll left
Notification handle = 0x000e value: 05 00 45 3a 03 
Notification handle = 0x000e value: 05 00 45 3a 05 
Notification handle = 0x000e value: 05 00 45 3a 00 
Notification handle = 0x000e value: 05 00 45 3a 04 
Notification handle = 0x000e value: 05 00 45 3a 00 
Notification handle = 0x000e value: 05 00 45 3a 04 
Notification handle = 0x000e value: 05 00 45 3a 00

roll right
Notification handle = 0x000e value: 05 00 45 3a 04 
Notification handle = 0x000e value: 05 00 45 3a 00 
Notification handle = 0x000e value: 05 00 45 3a 05 
Notification handle = 0x000e value: 05 00 45 3a 00 
Notification handle = 0x000e value: 05 00 45 3a 05 
Notification handle = 0x000e value: 05 00 45 3a 03 
Notification handle = 0x000e value: 05 00 45 3a 00

pitch down
Notification handle = 0x000e value: 05 00 45 3a 01 
Notification handle = 0x000e value: 05 00 45 3a 05 
Notification handle = 0x000e value: 05 00 45 3a 02 
Notification handle = 0x000e value: 05 00 45 3a 05 
Notification handle = 0x000e value: 05 00 45 3a 02 
Notification handle = 0x000e value: 05 00 45 3a 00
```



So only the last byte matters and just a few positions are detected:
```
00 = horizontal
01 = ? pitch down 90º ?
02 = ? pitch up 90º ?
03 = ? roll left 90º ?
04 = ? roll right 90º ?
05 = ? upside down ?
```

~~Finally the first command set full 6-axis sensor:~~
Sorry, didn't pay attention. It's like previous mode but returns all angles instead of just a few positions.

So pitch and roll but not yaw. There must be other command.

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100; gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a00413a000100000001 --listen

Notification handle = 0x000e value: 0a 00 47 3a 00 01 00 00 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 01

horiz, start:
 06 00 45 3a 00 00
(if not quite horizontal may read 00 fe or 00 fd)
(ports A and B and button are at "back")

yaw
===
90 (left)
06 00 45 3a 00 00
180
06 00 45 3a 00 00
270
06 00 45 3a 00 00

no reads for yaw?

pitch
=====
90 (front down) 
06 00 45 3a 00 5a
180 (upside down)
06 00 45 3a 00 5a
270 (front up)
06 00 45 3a 00 a6

last byte measures pitch
5A = 90º
A6 = - 90º

roll
====
90 (left, port A up))
06 00 45 3a 5a 00 
180 (upside down)
06 00 45 3a 5a 00
270 (port B up)
 06 00 45 3a a6 00

5th byte measures roll
5A = 90º
A6 = -90º
