# RGB LED Command

In LEGO BOOST App, the first purple block changes the RGB LED color

![RGB LED block](https://github.com/JorgePe/BOOSTreveng/blob/master/LEGO_BOOST_App_blocks/RGB_LED_color.png)

BLE Command is a write request of `080081321151000n`

Structure:
1. length of the command (i.e. 8 bytes),
2. 0x00 - ?? maybe packet version
3. 0x81 - set port value
4. 0x32 - LED port
5. 0x11 ?? feels like bitmask field, with first bit enabling notifications of LED color changed, other bits unused
6. 0x51 ?? changing it to any other value reports error
7. 0x00 ?? changing it to any other value causes color to not change, might be higher byte of color
8. 0x00 - color value, see below 

The last byte is an index of the color, in the same order as used by the LEGO BOOST App:


   n in [0..A]

   0 = none (off)  
   1 = pink  
   2 = purple  
   3 = blue  
   4 = light blue  
   5 = cyan?  
   6 = green  
   7 = yellow  
   8 = orange  
   9 = red  
   A = white  
   

```
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510007

```


```
#!/usr/bin/env bash
for (( ; ; ))
do
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510001
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510002
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510003
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510004
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510005
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510006
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510007
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510008
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510009
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=080081321151000A
  sleep 1
  gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0800813211510000
  sleep 1
done
```

[Video of previous script](https://youtu.be/lx0ZibpgLAM)
