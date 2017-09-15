# Color and Distance Sensor

This sensor serves both distance and color values at the same time. However, in LEGO Boost App it is presented with 2 separate blocks.

The third orange block looks like continuous color reading:

![ColorSensor](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/ColorSensor_continuous.png)

The sixth orange block looks like continuous distance reading:

![Continuous Distance Reading](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/DistanceSensor_continuous.png)


I've been sniffing it with the sensor at port C.


We need to activate notifications by writing "0100" to handle 0x0f = UUID 2902

UUID 2902 is defined as the [Client Characteristic Configuration](https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml) in the
Bluetooth specs. By activating notifications on one characteristic we "subscribe" to further messages comming
from it.

Then we activate "?continuous reading?" mode by writing `0a004101080100000001` to handle 0x0e and keep reading.

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

## Activation command structure (`0a00 4101 08 01000000 01`):

- 0x0a - message len
- 0x00 - most likely packet format version
- 0x41 - message type "subscribe to port"
- 0x01 - port value C (port D is 0x02)
- 0x08 - sensor mode
- 0x01 - for mode 0x08 this is notification granularity (reports each n-th value)
- 0x00 - higher byte of granularity
- 0x00 - ?? 
- 0x00 - ??
- 0x01 - enable/disable subscription flag

Sensor mode:
- 0x00 - color only
- 0x01 - integer inches distance only
- 0x02 - absolute count of crossing distance of ~2 inches
- 0x03 - "how close" distance measurement (single byte of result is larger value with closer distance)
- 0x04 - closer distance single byte measurement, larger value when closer distance under 1 inch
- 0x05 - seems to just turn sensor off
- 0x06 - constantly streams some 3 values, each is 2-byte, seem to measure the distance, but not clear why 3 of them?
- 0x07 - seems to turn sensor off
- 0x08 - color and distance mode - the easiest one
- 0x09 - lumonosity measurement mode (gives 1024 values from 0 to 1023)
- 0x0a - gives single notification with some 20 bytes of data


## Data notification structure (`08 00 45 01 ff 0a ff 01`)

Data notification that arrives holds both color and distance values. Here's structure for 0x08 sensor mode, other modes have different formats:

- 08 - msg len
- 00 - format version
- 45 - message type "sensor data from port"
- 01 - port ID (C=0x01 and D=0x02)
- 0a - color value (see explanation below)
- 00 - distance in integer inches
- ff - ??
- 0a - partial inch distance - 1/x inch, works for last inch of distance

Color values are:

- BLACK  0x00
- BLUE   0x03
- GREEN  0x05 (Cyan or Turquoise in RGB LED)
- YELLOW 0x07
- RED    0x09
- WHITE  0x0A

So float value distance formula is something like: `inches + 1/partial`, mind division by zero

## Notes

   The BOOST Move Hub only send a notification when there is a change.  

   The color sensor understands few colors, apparently the same 7 available as options in the  
   first and second orange blocks where we need to choose the color to be detected:
   - ? null ?
   - black
   - blue
   - green
   - yellow
   - red
   - white
   
   If I touch a white surface with the sensor it reads null.  
   Dark color surfaces read black  
   
   Some rough measurings:
   
   WHITE              08 00 45 01 0a 00 ff 0a  
   BLUE               08 00 45 01 03 00 ff 01  
   BLACK              08 00 45 01 00 0a ff 01  
   RED                08 00 45 01 09 00 ff 03  
   GREEN              08 00 45 01 05 00 ff 02  
   YELLOW             08 00 45 01 07 00 ff 05  


First byte = 08 is the number of bytes in the message (thanks @rblaakmeer)

2nd, 3rd and 4th bytes = 00 45 01 are still unknown


   When the sensor is a few centimeters far, instead of returning a color index it returns  
   FF.  
   The 6th byte is distance measured.
   The 8th byte also changes. It's strange to be be separated from 5th and 6th bytes by a  
   fixed 7th byte, always FF.
   
Based on this, this shell script works fine in Ubuntu:

```
#!/usr/bin/env bash

# activate notifications
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
# activate continuous color reading
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen | 
  while IFS= read -r line
  do 
    output=${line##*:}
    output2=($output)

    case ${output2[4]} in
      00)
        echo "BLACK"
        ;;
      03)
        echo "BLUE"
        ;;
      05)
        echo "GREEN"
        ;;
      07)
        echo "YELLOW"
        ;;
      09)
        echo "RED"
        ;;
      0a)
        echo "WHITE"
        ;;
      ff)
        echo "TOO FAR"
        ;;
      *)
        echo "???"
        ;;
    esac
  done
```
