General GATT findings:

Firmware as of 11 August 2017
App version 1.0.11 / Firmware: 1.0.00.0140

gatttool -I -b 00:16:53:A4:CD:7E

primary
attr handle: 0x0001, end grp handle: 0x0004 uuid: 00001801-0000-1000-8000-00805f9b34fb
attr handle: 0x0005, end grp handle: 0x000b uuid: 00001800-0000-1000-8000-00805f9b34fb
attr handle: 0x000c, end grp handle: 0x000f uuid: 00001623-1212-efde-1623-785feabcd123

characteristics
handle: 0x0002, char properties: 0x20, char value handle: 0x0003, uuid: 00002a05-0000-1000-8000-00805f9b34fb
handle: 0x0006, char properties: 0x4e, char value handle: 0x0007, uuid: 00002a00-0000-1000-8000-00805f9b34fb
handle: 0x0008, char properties: 0x4e, char value handle: 0x0009, uuid: 00002a01-0000-1000-8000-00805f9b34fb
handle: 0x000a, char properties: 0x02, char value handle: 0x000b, uuid: 00002a04-0000-1000-8000-00805f9b34fb
handle: 0x000d, char properties: 0x1e, char value handle: 0x000e, uuid: 00001624-1212-efde-1623-785feabcd123

char-desc
handle: 0x0001, uuid: 00002800-0000-1000-8000-00805f9b34fb
handle: 0x0002, uuid: 00002803-0000-1000-8000-00805f9b34fb
handle: 0x0003, uuid: 00002a05-0000-1000-8000-00805f9b34fb
handle: 0x0004, uuid: 00002902-0000-1000-8000-00805f9b34fb
handle: 0x0005, uuid: 00002800-0000-1000-8000-00805f9b34fb
handle: 0x0006, uuid: 00002803-0000-1000-8000-00805f9b34fb
handle: 0x0007, uuid: 00002a00-0000-1000-8000-00805f9b34fb
handle: 0x0008, uuid: 00002803-0000-1000-8000-00805f9b34fb
handle: 0x0009, uuid: 00002a01-0000-1000-8000-00805f9b34fb
handle: 0x000a, uuid: 00002803-0000-1000-8000-00805f9b34fb
handle: 0x000b, uuid: 00002a04-0000-1000-8000-00805f9b34fb
handle: 0x000c, uuid: 00002800-0000-1000-8000-00805f9b34fb
handle: 0x000d, uuid: 00002803-0000-1000-8000-00805f9b34fb
handle: 0x000e, uuid: 00001624-1212-efde-1623-785feabcd123
handle: 0x000f, uuid: 00002902-0000-1000-8000-00805f9b34fb

handle 0x0007 = 2A00 = Device Name

char-read-hnd 0x07
Characteristic value/descriptor: 4c 45 47 4f 20 4d 6f 76 65 20 48 75 62
"LEGO Move Hub"

We can change "Device Name" but after power cycle the firmware resets it to "LEGO Move Hub" again.

All functionality seems to be on handle 0x0e (uuid: 00001624-1212-efde-1623-785feabcd123)

As noticed by @rblaakmeer on [isse #5](0800813211510009) all messages sent to / recevived from the BOOST Move Hub start with a number
stating the length of the message, like the command to change RGB LED color to Red:

0800813211510009

