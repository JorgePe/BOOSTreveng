# Notifications from characteristic 00001624-1212-efde-1623-785feabcd123

* `12 00 01 01 06 4c 45 47 4f 20 4d 6f 76 65 20 48 75 62` - Name of the Hub. String `LEGO Move Hub` starts at offset 5
* `06 00 01 02 06 00` - ?
* `09 00 01 03 06 40 01 00 10` - Move Hub Firmware Version? App shows `1.0.00.0140`. 
* `09 00 01 04 06 00 00 00 04` - ?
* `06 00 01 05 06 d3` - ?
* `06 00 01 06 06 xx` - ? - come very often with decrementing last byte. kind of a ping?
* `06 00 01 07 06 00` - ?
* `14 00 01 08 06 4c 45 47 4f 20 53 79 73 74 65 6d 20 41 2f 53` - Manufacturer. String `LEGO Systems A/S` starts at offset 5
* `09 00 01 09 06 37 2e 32 63` - ?
* `07 00 01 0a 06 00 03` - ?
* `06 00 01 0b 06 40` - ?
* `06 00 01 0c 06 00` - ?
* `0b 00 01 0d 06 00 16 53 a5 16 e2` - ?
* `0b 00 01 0e 06 00 16 53 a5 16 e3` - ?


* `06 00 03 01 04 00`
* `06 00 03 02 04 00`
* `06 00 03 03 04 00`
* `06 00 03 04 04 00`

* `0f 00 04 01 01 25 00 00 00 00 10 00 00 00 10` - Port Info
* `0f 00 04 02 01 26 00 00 00 00 10 00 00 00 10` - Port Info
* `0f 00 04 37 01 27 00 00 00 00 10 00 00 00 10` - Port Info
* `0f 00 04 38 01 27 00 00 00 00 10 00 00 00 10` - Port Info
* `09 00 04 39 02 27 00 37 38` - Port Info - Group: 0x39 consists of 0x37 and 0x38
* `0f 00 04 32 01 17 00 00 00 00 10 00 00 00 10` - Port Info
* `0f 00 04 3a 01 28 00 00 00 00 10 00 00 00 02` - Port Info
* `0f 00 04 3b 01 15 00 02 00 00 00 02 00 00 00` - Port Info
* `0f 00 04 3c 01 14 00 02 00 00 00 02 00 00 00` - Port Info

* `0a 00 47 01 08 01 00 00 00 01` - ?

* `05 00 82 37 01` - Motor A (0x37) starts movement
* `05 00 82 37 0a` - Motor A (0x37) stops movement
* `05 00 82 37 05` - Motor A (0x37) Is reported when a command is received while the motor is still in movement
* `05 00 82 32 0a` - Reports a change of the LED state

* Byte 0 as always: **message length**

* Byte 1? Protocol version? HiByte of message length? 

* Byte 2 is the **message type**: 
  * `0x01` device information
  * `0x03` ?
  * `0x04` port information
  * `0x45` sensor reading
  * `0x47` ?
  * `0x82` port changed
  
* On message type 0x04 and 0x82 Byte 3 is the **port number**:
  * `0x01` C
  * `0x02` D
  * `0x32` LED
  * `0x37` A
  * `0x38` B
  * `0x39` A and B
  * `0x3a` TILT SENSOR


### Message type 0x04 port information

* Byte 5 is the device type:
  * `0x25` DISTANCE/COLOR SENSOR
  * `0x26` IMOTOR
  * `0x27` MOTOR
  * `0x28` TILT SENSOR
  
### Message type 0x45 sensor reading  



### Message type 0x82 port changed 


* Byte 4:
  * `0x01` action started
  * `0x05` conflict. New action received while other action is still running
  * `0x0a` action finished
  
 
