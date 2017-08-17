# Example: MIT APP Inventor 2 for Android

A simple example on how to use new version (July 2017) of BluetoothLE extension to create a simple Android App that controls
a LEGO BOOST car.

You need to import extension with URL "http://iot.appinventor.mit.edu/assets/resources/edu.mit.appinventor.ble.aix"

3 blocks are used from this extension:

- **StartScanning** turns BLE discovery ON when the App starts

- **ConnectWithAddress** connects to our BOOST

- **WriteBytesWithResponse** sends a command

4 commands are used in this example, each associated with a button:
- FRONT
- LEFT
- RIGHT
- BACK

The fith button is used to Connect or Disconnect to/from the BOOST Move Hub.

They are all same, sending a list of 13 bytes, given in hexadecimal format:
FRONT: 0c018139110a00069B9B647f03
LEFT: 0c018139110a00069B64647f03
RIGHT: 0c018139110a0006649B647f03
BACK: 0c018139110a00066464647f03

Each commnad turns motor A and B ON for 1.5 seconds (00 06 = 1536 ms) at full speed in each direction (64 = 100%, 9B = -100%)

![Designer View](https://github.com/JorgePe/BOOSTreveng/blob/master/Examples/AppInventor/BOOST_RC_01.png)
![Blocks View](https://github.com/JorgePe/BOOSTreveng/blob/master/Examples/AppInventor/BOOST_RC_02.png)

A video with a short tutorial showing how to use the **WriteBytesWithResponse** block available:
![App Inventor and BOOST](https://youtu.be/As90gAQfyFM)
