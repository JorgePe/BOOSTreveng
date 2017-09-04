# LEGO BOOST Hardware

The BOOST plug is a "Power Functions 2" plug like those introduced with the WeDo 2.0:

![Power Functions 2 plug](https://flic.kr/p/K5jb75)

The plug has 6 pins.
I consider pin 1 the left pin on that image (just to be sure, if we see the plug from front,
it looks like an inverted "U")

## The Interactive Motor pinout:
   1 - motor power  
   2 - motor power  
   3 - ?  
   4 - ?  
   5 - ?  
   6 - ?  
   
   Between pins 3 and 4 my multimeter measures 2.2 KOhm, it seems the AutoID.
   For reference, we can trick the WeDo 2.0 SmartHub to use a common motor by connecting a 2k2
   resistor between pins 3 and 5 and also connecting pin 3 to pin 6 (pin 3 might be GND and pin
   6 an Analog Input)
