# RGB LED Command

In LEGO BOOST App, the fisrt purple block chnages the RGB LED color


Command is `080081321151000n`

The first byte is the length of the command (i.e. 8 bytes), the meaning of the next 6 bytes is still unknown.
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
