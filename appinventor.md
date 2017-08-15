# How to use MIT App Inventor 2 on Android

Since July 2017 there is a new [Bluetooth BLE extension](http://iot.appinventor.mit.edu/assets/resources/edu.mit.appinventor.ble.aix) that makes everything much easier.

We can use the block "WriteBytesWithResponse" to send a list of bytes to BOOT.

We need to pass 4 arguments:

- **serviceserviceUuid** is the uuid of LEGO BOOST Hub primary service that we use: "00001623-1212-efde-1623-785feabcd123"

- **characteristicUuid** is the uuid of the only characteristic available (associated to handle "0x0e"): "00001624-1212-efde-1623-785feabcd123"

- **signed** needs to be "false" in ordered to use 0..255 values

- **values** is a list containing our command, we can use a "make a list" block

[[https://github.com/JorgePe/BOOSTreveng/blob/master/RGB_White.png]]

In the photo, we send command "set RGB LED color to White", the hexadecimal format of the command is "080081321151000A" but in decimal it is "8 0 129 50 17 81 00 10" so we use a "make a list" with 8 items. 
