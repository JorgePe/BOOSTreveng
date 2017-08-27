# Move Hub Button

After BLE connection with the Move Hub, the BOOST App sends this 3 commands where the 4th byte is "02":

```
05:00:03:02:03
05:00:01:02:02
05:00:03:02:01
```

The second command activates the button:

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100; \
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0500010202 --listen

Characteristic value was written successfully
Characteristic value was written successfully
Notification handle = 0x000e value: 06 00 01 02 06 00 
Notification handle = 0x000e value: 06 00 01 02 06 01 
Notification handle = 0x000e value: 06 00 01 02 06 00 
Notification handle = 0x000e value: 06 00 01 02 06 01 
Notification handle = 0x000e value: 06 00 01 02 06 00 
Notification handle = 0x000e value: 06 00 01 02 06 01 
Notification handle = 0x000e value: 06 00 01 02 06 00 
Notification handle = 0x000e value: 06 00 01 02 06 01 
Notification handle = 0x000e value: 06 00 01 02 06 00 

Last byte is the last state of the button:
00 - released
01 - pressed
```

Don't know what the other 2 commands do. Clear the button state? Choose an operation mode?
