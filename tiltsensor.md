# 6-axis tilt

The BOOST Move Hub has an internal 6-axis tilt sensor.

I used the 13th orange block to capture BLE communications, found 4 commands:

```
0a:00:41:3a:00:01:00:00:00:01 -- yes!
0a:00:41:3a:02:01:00:00:00:01 -- ahah mas só 2 eixos
0a:00:41:3a:03:01:00:00:00:01 -- é qq coisa mas nada
0a:00:42:3a:01:00:30:00:20:01 -- nada
```

Last one does nothing and the 3rd one activates something but got nothing.

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

So just the last byte matters and just a few positions are detected:
```
00 = horizontal
01 = ? pitch down 90º ?
02 = ? pitch up 90º ?
03 = ? roll left 90º ?
04 = ? roll right 90º ?
05 = ? upside down ?
```

By the way, 4th byte here (3A) is not quite the port but the device.
So sometimes the 4th byte targets a port and others a device.

Finally the first command set full 6-axis sensor:

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100; gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a00413a000100000001 --listen

Notification handle = 0x000e value: 0a 00 47 3a 00 01 00 00 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 01

90 clockwise horizontal
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 02 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a 00 02 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 00 01 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a ff 01 
Notification handle = 0x000e value: 06 00 45 3a ff 01 
Notification handle = 0x000e value: 06 00 45 3a ff 01 
Notification handle = 0x000e value: 06 00 45 3a fe 01 
Notification handle = 0x000e value: 06 00 45 3a fd 01 
Notification handle = 0x000e value: 06 00 45 3a fe 01 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fc 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fd 00 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a fe ff 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a ff ff 
Notification handle = 0x000e value: 06 00 45 3a fe ff 
Notification handle = 0x000e value: 06 00 45 3a ff ff 
Notification handle = 0x000e value: 06 00 45 3a fe ff 
Notification handle = 0x000e value: 06 00 45 3a ff fe 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a fe ff 
Notification handle = 0x000e value: 06 00 45 3a fe ff 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a ff 02 
Notification handle = 0x000e value: 06 00 45 3a ff 01 
Notification handle = 0x000e value: 06 00 45 3a fe 00 
Notification handle = 0x000e value: 06 00 45 3a ff 00 
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 00 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 01 fe 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 02 ff 
Notification handle = 0x000e value: 06 00 45 3a 00 fe 
Notification handle = 0x000e value: 06 00 45 3a 01 ff 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 02 ff 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 02 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00 
Notification handle = 0x000e value: 06 00 45 3a 01 00
```

Need time for more tests.
