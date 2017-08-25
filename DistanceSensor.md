#Distance Sensor

The sixth orange block looks like continuous distance reading:

![Continuous Distance Reading](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/DistanceSensor_continuous.png)

The LEGO BOOST App detects values between 1 and 10, proportional to the distance. Seems like units are centimeters.

Using this mode is similar to Continuous Color Reading: we subscrbe for notifications and activate the mode:

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen
```

My hand moving from far to near:

```
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
```

So clearly 6th byte = distance 0x0A to 01 (10 to 01)
There's also something on 5th and 7th byte.  For now, will assume that when
5th byte = FF we have a good distance reading on 6th byte.

Practical example will soon follow.
