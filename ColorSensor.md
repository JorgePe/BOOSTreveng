# Color Sensor

The third orange block looks like continuous color reading:

![ColorSensor](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/ColorSensor_continuous.png)

I've been sniffing it with the color sensor at port C.


We need to activate notifications by writing "0100" to handle 0x0f = UUID 2902

UUID 2902 is defined as the [Client Characteristic Configuration](https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml) in the
Bluetooth specs. By activating notifications on one characteristic we "subscribe" to further messages comming
from it.

Then we activate "?continuous color reading?" mode by writing `0a004101080100000001` to handle 0x0e and keep reading.

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen
Notification handle = 0x000e value: 08 00 45 01 03 03 ff 03 
Notification handle = 0x000e value: 08 00 45 01 09 07 ff 01 
Notification handle = 0x000e value: 08 00 45 01 00 07 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 09 ff 01 
Notification handle = 0x000e value: 08 00 45 01 ff 0a ff 01 
....
```

If I touch a white surface with the sensor it reads something like null.
Dark color surfaces read black

With the sensor about 5 mm over a colored surface (at night, light from ceilling lamp):

   WHITE              08 00 45 01 0a 01 ff 0a  
   BLUE               08 00 45 01 03 02 ff 02  
   BLACK              08 00 45 01 00 0a ff 01  
   RED                08 00 45 01 07 01 ff 08  
   ORANGE (says red)  08 00 45 01 09 01 ff 09  
   YELLOW             08 00 45 01 0a 00 ff 06  


   The sensor (or the App) has some difficulties with greens (got BLUE) and oranges (got RED).  
   Seems a limitation from the App - with the first and second orange blocks we need to choose a color and we only have 7 options:
   - null
   - black
   - blue
   - green
   - yellow
   - red
   - white

First byte = 08 is the number of bytes in the message (thanks @rblaakmeer)

2nd, 3rd and 4th bytes = 00 45 01 are still unknown

5th, 6th and 8th bytes change with the color (and/or intensity ?)

7th byte = FF is still unknown


Need more time and more color samples
