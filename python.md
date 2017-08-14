Using python with BT BLE

Note: this guidelines are only for linux

I use [Oscar Acena gattlib (pygattlib)](https://bitbucket.org/OscarAcena/pygattlib)
This library is also included in [Piotr Karulis pybluez](https://github.com/karulis/pybluez).
Both libraries are included in ev3dev so we can use a LEGO MINDSTORMS EV3 to communicate with BT BLE devices.
Of course, a BT BLE compatible device is needed, there are several USB dongles available.

For the record, there is at least another library available, [Ian Harvey bluepy](https://github.com/IanHarvey/bluepy).

If you have a BT BLE compatible device it should appear in linux as an HCI device, version 4.0 or above:

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

Please note that not all BT 4.0 devices are BLE - recently LEGO changed the internal Bluetooth chipset of
the MINDSTORMS EV3 for a BT 4.0 version **whithout** BLE. You can check that with:

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

'00:16:53:A4:CD:7E' is the BT address, 'LEGO Move Hub' is the friendly name (with current firmware, it's the same
friendly name for all devices so if you have more than one you should turn just one on, take note of it's BT
address, then turn it off and repeat the process...)


For a basic example, this is how we read the friendly name with python:

```
#!/usr/bin/env python3

from gattlib import GATTRequester

req = GATTRequester("00:16:53:A4:CD:7E",True,"hci0")
devicename=req.read_by_handle(0x07)
print(devicename[0])
```

I assume we just installed gattlib, so imported 'GATTRequester' directly from 'gattlib'. If we installed 'pybluez'
with ble support instead, we should import it from 'bluetooth.ble':

```
from bluetooth.ble import GATTRequester
```

Please also note that handle '0x07' is the BLE handle associated to the ["Device Name" characteristic](https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.gap.device_name.xml)
for the current version of the LEGO BOOT firmware. Handles are not a property of the device, they are in fact the result
of a discovery process of the characteristiscs of the device.
So we really should have used 'read_by_uuid' instead of 'read_by_handle':

```
devicename=req.read_by_uuid("00002a00-0000-1000-8000-00805f9b34fb")
```

But as it is much more easy to remember a 2-char handle than a 32-char uuid I prefer to use the handle.

Some uuid's are already defined in a standard, so '2a00' is world wide used as the Device Name uuid. But other uuid's
are used by some vendors for custom purposes that are not yet (and might never be) part of the BLE standard so these uuid's
can change - LEGO developers may decide, in a future version of the firmware, that instead of using just one characteristic
for all motors/sensors/RGB LED functions it's better to split it in several characteristics.

So don't take anything for granted. Specially if written by me :)

