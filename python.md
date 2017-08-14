# Using python with BT BLE

Note 1: this guidelines are only for linux.

Note 2: we need a BLE compatible system. Please read [bash.md](https://github.com/JorgePe/BOOSTreveng/blob/master/bash.md)


I use [Oscar Acena gattlib (pygattlib)](https://bitbucket.org/OscarAcena/pygattlib)
This library is also included in [Piotr Karulis pybluez](https://github.com/karulis/pybluez).
Both libraries are included in ev3dev so we can use a LEGO MINDSTORMS EV3 to communicate with BT BLE devices.
Of course, a BT BLE compatible device is needed, there are several USB dongles available.

For the record, there is at least another library available, [Ian Harvey bluepy](https://github.com/IanHarvey/bluepy).

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

