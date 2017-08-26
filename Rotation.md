# Rotation sensor

Interactive Motor on port D (color sensor on port C)

![Interactive Motor Rotation](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/ExtMotorRotation.png)

17th orange block
(this is so stupid.. why the blocks don't have names? what are they supposed to really do?)

sniffing session got this commands:

0a:00:41:01:08:01:00:00:00:01 = distance sensor, don't know why it shows here because there was no block
0a:00:41:02:01:01:00:00:00:01 -> delta? speed?
0a:00:41:02:02:01:00:00:00:01 -> angle
08:00:42:02:01:00:20:10 -> unknown

repeating the method for color sensor and distance sensor (subscribe notifications and set mode):

0a004102020100000001
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004102020100000001 --listen

Notification handle = 0x000e value: 0a 00 47 02 02 01 00 00 00 01 
Notification handle = 0x000e value: 08 00 45 02 ff ff ff ff 
clockwise
Notification handle = 0x000e value: 08 00 45 02 00 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 01 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 02 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 03 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 04 00 00 00
anticlockwise
Notification handle = 0x000e value: 08 00 45 02 03 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 02 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 01 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 00 00 00 00 
Notification handle = 0x000e value: 08 00 45 02 fe ff ff ff 
Notification handle = 0x000e value: 08 00 45 02 fd ff ff ff 
Notification handle = 0x000e value: 08 00 45 02 fc ff ff ff 
Notification handle = 0x000e value: 08 00 45 02 fb ff ff ff


half rotation = b4 00 00 00 = 180
about one rotation = 60 01 00 00 = 352
360d = 168h = 68 01 00 00 

So 5th, 6th, 7th and 8th bytes are rotation in degrees, reverted (LSB first, MSB last)

That was more easy than what I expected!

Now the other mode...
It gives shorter messages and it seems to return instant speed or just deltas:

gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004102010100000001 --listen
Notification handle = 0x000e value: 0a 00 47 02 01 01 00 00 00 01
clockwise
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 02 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 03 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 02 
Notification handle = 0x000e value: 05 00 45 02 03 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 03 
Notification handle = 0x000e value: 05 00 45 02 02 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 04 
Notification handle = 0x000e value: 05 00 45 02 03 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 02 
Notification handle = 0x000e value: 05 00 45 02 03 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 04 
Notification handle = 0x000e value: 05 00 45 02 06 
Notification handle = 0x000e value: 05 00 45 02 16 
Notification handle = 0x000e value: 05 00 45 02 32 
Notification handle = 0x000e value: 05 00 45 02 2a 
Notification handle = 0x000e value: 05 00 45 02 22 
Notification handle = 0x000e value: 05 00 45 02 1b 
Notification handle = 0x000e value: 05 00 45 02 15 
Notification handle = 0x000e value: 05 00 45 02 0f 
Notification handle = 0x000e value: 05 00 45 02 0a 
Notification handle = 0x000e value: 05 00 45 02 07 
Notification handle = 0x000e value: 05 00 45 02 04 
Notification handle = 0x000e value: 05 00 45 02 00
anticlockwise
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 fa 
Notification handle = 0x000e value: 05 00 45 02 f9 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 fe 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 fe 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 ff 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 f7 
Notification handle = 0x000e value: 05 00 45 02 f0 
Notification handle = 0x000e value: 05 00 45 02 ea 
Notification handle = 0x000e value: 05 00 45 02 ec 
Notification handle = 0x000e value: 05 00 45 02 f1 
Notification handle = 0x000e value: 05 00 45 02 f6 
Notification handle = 0x000e value: 05 00 45 02 f9 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 ff 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 ff 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 fe 
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 fa 
Notification handle = 0x000e value: 05 00 45 02 fb 
Notification handle = 0x000e value: 05 00 45 02 00 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 fc 
Notification handle = 0x000e value: 05 00 45 02 fd 
Notification handle = 0x000e value: 05 00 45 02 00 


