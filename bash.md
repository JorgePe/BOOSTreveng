# Using linux with BLE

Modern linux distributions use [BlueZ](http://www.bluez.org/) for its bluetooth stack.

Bluez 5 include support for BLE devices and we can use just some simple command line commands to access our BOOST Move Hub.


These guidelines should work on a common linux computer (I use an Ubuntu laptop) but also on a Raspberry Pi running Raspbian (as long as it includes BlueZ 5) and LEGO MINDSTORMS EV3 running ev3dev.


Of course, we neeed our computer/Raspberry Pi/ EV3 to be BT BLE compatible. Many modern computers already have some kind of BT 4.0 internal device. The Raspberry Pi 3 and Pi Zero W also include BT 4.0 BLE but older versions and also the EV3 don't so we need to use an USB adapter.


If we do have a BT BLE compatible device it should appear in linux as an HCI device, version 4.0 or above:
```
hciconfig -a
hci0:	Type: Primary  Bus: USB
	BD Address: 34:F3:9A:88:60:7A  ACL MTU: 1021:4  SCO MTU: 96:6
	UP RUNNING PSCAN ISCAN 
	RX bytes:21777 acl:75 sco:0 events:2890 errors:0
	TX bytes:603368 acl:76 sco:0 commands:2656 errors:0
	Features: 0xbf 0xfe 0x0f 0xfe 0xdb 0xff 0x7b 0x87
	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
	Link policy: RSWITCH SNIFF 
	Link mode: SLAVE ACCEPT 
	Name: 'wksbae0743'
	Class: 0x0c010c
	Service Classes: Rendering, Capturing
	Device Class: Computer, Laptop
	HCI Version: 4.2 (0x8)  Revision: 0x100
	LMP Version: 4.2 (0x8)  Subversion: 0x100
	Manufacturer: Intel Corp. (2)
```

Please note that not all BT 4.0 devices are BLE - recently LEGO changed the internal Bluetooth chipset of the MINDSTORMS EV3 for a BT 4.0 version whithout BLE. You can check that with:

```
sudo hciconfig -a hci0 lestates
Supported link layer states:
	YES Non-connectable Advertising State
	YES Scannable Advertising State
	YES Connectable Advertising State
	YES Directed Advertising State
	YES Passive Scanning State
	YES Active Scanning State
	YES Initiating State/Connection State in Master Role
	YES Connection State in the Slave Role
	YES Non-connectable Advertising State and Passive Scanning State combination
	YES Scannable Advertising State and Passive Scanning State combination
	YES Connectable Advertising State and Passive Scanning State combination
	YES Directed Advertising State and Passive Scanning State combination
	YES Non-connectable Advertising State and Active Scanning State combination
	YES Scannable Advertising State and Active Scanning State combination
	YES Connectable Advertising State and Active Scanning State combination
	YES Directed Advertising State and Active Scanning State combination
	YES Non-connectable Advertising State and Initiating State combination
	YES Scannable Advertising State and Initiating State combination
	YES Non-connectable Advertising State and Master Role combination
	YES Scannable Advertising State and Master Role combination
	YES Non-connectable Advertising State and Slave Role combination
	YES Scannable Advertising State and Slave Role combination
	YES Passive Scanning State and Initiating State combination
	YES Active Scanning State and Initiating State combination
	YES Passive Scanning State and Master Role combination
	YES Active Scanning State and Master Role combination
	YES Passive Scanning State and Slave Role combination
	YES Active Scanning State and Slave Role combination
	YES Initiating State and Master Role combination/Master Role and Master Role combination
```

To use our LEGO BOOST Move Hub we need to know its BT address. We just turn it on and scan for BLE devices near us:

```
sudo hcitool -i hci0 lescan
LE Scan ...
00:1E:C0:3F:D9:DC (unknown)
00:16:53:A4:CD:7E (unknown)
00:16:53:A4:CD:7E LEGO Move Hub
```

'00:16:53:A4:CD:7E' is the BT address, 'LEGO Move Hub' is the friendly name (with current firmware, it's the same friendly name for all devices so if you have more than one you should turn just one on, take note of it's BT address, then turn it off and repeat the process...)

We can read this frindly name directly from the device with

```
gatttool -i hci0 -b 00:16:53:A4:CD:7E  --char-read --handle=0x07
Characteristic value/descriptor: 4c 45 47 4f 20 4d 6f 76 65 20 48 75 62
```

The result is a string of hexadecimal chars, you can convert it to ASCII from command line with
```
echo 4c 45 47 4f 20 4d 6f 76 65 20 48 75 62 | perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie'
```
or use an [online tool](http://www.rapidtables.com/convert/number/hex-to-ascii.htm) instead.
