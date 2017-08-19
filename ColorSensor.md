Using Color Sensor in Port C with 3rd block from the left in the App
(looks like continuous color reading)

We need to activate notifications by writing "0100" to handle 0x0f = UUID 2902

[Client Characteristic Configuration](https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml)

Then we activate mode by writing "0a004101080100000001" to handle 0x06

gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen
Notification handle = 0x000e value: 08 00 45 01 03 03 ff 03 
Notification handle = 0x000e value: 08 00 45 01 09 07 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 07 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 09 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 0a ff 01 
....

If I touch a white surface with the sensor it reads something like null. Dark color surfaces read black
About 5 mm over
WHITE              08 00 45 01 0a 01 ff 0a
BLUE               08 00 45 01 03 02 ff 02
BLACK              08 00 45 01 00 0a ff 01
RED                08 00 45 01 07 01 ff 08
ORANGE (says red)  08 00 45 01 09 01 ff 09
YELLOW             08 00 45 01 0a 00 ff 06

Some difficulties with GREEN and ORANGE

First byte = 08 is the number of bytes in the message (thanks @rblaakmeer)
2nd, 3rd and 4th bytes = 00 45 01 are still unknown
5th, 6th and 8th bytes change with the color (and/or intensity ?)
7th byte = FF is still unknown

Need more time and more color samples
