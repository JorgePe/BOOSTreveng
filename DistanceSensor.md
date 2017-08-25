#Distance Sensor

The sixth orange block looks like continuous distance reading:

![Continuous Distance Reading](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/DistanceSensor_continuous.png)

gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen

Yes?!

mao a aproximar

Notification handle = 0x000e value: 08 00 45 01 ff 0a ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 09 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 08 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 07 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 06 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 05 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 04 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 03 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 04 ff 00 
Notification handle = 0x000e value: 08 00 45 01 ff 03 ff 00 
Notification handle = 0x000e value: 08 00 45 01 00 03 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 03 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 03 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 03 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 02 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 02 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 02 ff 02 
Notification handle = 0x000e value: 08 00 45 01 00 00 ff 02 
Notification handle = 0x000e value: 08 00 45 01 00 01 ff 02 
Notification handle = 0x000e value: 08 00 45 01 00 01 ff 03 
Notification handle = 0x000e value: 08 00 45 01 00 01 ff 02 

nitidamente 6th byte = distance 0a..01
há qq coisa no 5th byte ff/00 e bi 8th byte 
