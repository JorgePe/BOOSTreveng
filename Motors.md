
# Motors

motor A 50% 0.1s:

    0c:00:81:37:11:09:64:00:32:64:7f:03

    gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e \
             --value=0c0081371109640032647f03

motor A 100% 0.1s

    1  2  3  4  5  6  7  8  9  10 11 12
    0c:00:81:37:11:09:64:00:64:64:7f:03

motor B 50% 0.1s

    1  2  3  4  5  6  7  8  9  10 11 12
    0c:00:81:38:11:09:64:00:32:64:7f:03

motor B 50% 0.2s

    1  2  3  4  5  6  7  8  9  10 11 12
    0c:00:81:38:11:09:c8:00:32:64:7f:03

## Test Script

```
                 /- Port (AB=0x39 - motor group)
                 |
        /- len!  |     /- Value Type
        |        |     |
        0. 1. 2. 3. 4. 5. 6. 7. 8. 9. 10 11 12
  data: 0d 01 81 39 11 0a 00 06 9B 9B 64 7f 03
  data: 0d 01 81 39 11 0a 80 09 9B 64 64 7f 03
  data: 0d 01 81 39 11 0a 00 06 9B 9B 64 7f 03
  data: 0d 01 81 39 11 0a 80 09 9B 64 B4 7f 03
              |
              \- packet-type - 0x81 is 'set port value'
```

	  gatttool -i hci1 \
      -b 00:16:53:A4:CD:7E \
      --char-write-req \
      --handle=0x0e \
      --value=0c018139110a00069B9B647f03
	  gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e \
             --value=0c018139110a80099B64647f03
	  sleep 2.4
	  gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e \
            --value=0c018139110a00069B9B647f03
	  sleep 1.5
	  gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e \
             --value=0c018139110a80099B64B47f03

## So...

### General Packet Header:

1. packet length (`0xC`=12 for Time Value, `0xE` for Angle Value)
2. ??? (maybe packet format version, usually 0x0, but seen samples w/ 0x1)
3. packet type - `0x81` = `Set Port Value`
4. port - motors are: A=`0x37`, B=`0x38`, A+B=`0x39`, D=`0x02`

Port `0x39` is special in that it addresses both, motor A and motor B.
The group (and its child ports) is reported in the port registration 
packet (0x4).

### Set Motor Port Value

5. `0x11` - unknown
6. Value Type:
  - 0x09 - Time Value
  - 0x0A - Time Multi Motor Value - Test Script
  - 0x0B - Angle Value

#### Time Value: Byte 6 Type 0x09

Run motor for a specific time.

- 7+8 - motor run time in milliseconds in little endian (UInt16)
  - 0.1s = 64 00
  - 0.2s = c8 00
- 9 - duty cycle 0..127, including turn direction (+/-)

Trailer (same for Angle):

- 10 - ?? value 0x64
- 11 - ?? value 0x7F
- 12 - ?? value 0x03

Notes on time:

    7h and 8th byte is timing (LSB + MSB)
    0.1s = 64 00
    0.2s = c8 00
    64h = 100d
    c8h = 200d
    So time is in mil 647f03liseconds
    00 0A = 2560 = 2.56 seconds
    00 0F = 3.84 seconds
    
#### Angle Value: Byte 6 Type 0x0B

Run motor to a specific angle.

- 7...10 - angle (UInt32 Little Endian)
- 11 - dutycycle 0..127, including turn direction (+/-)

Trailer (same for Time Value):

- 12 - ?? value 0x64
- 13 - ?? value 0x7F
- 14 - ?? value 0x03 (same for Time Value)

#### Time Multi Motor Value: Byte 6 Type 0xA (Test Script)

This only seems to work for motor groups (i.e. port 0x39).

This value is used in the motor test script.
E.g. it seems to allow the group motors to run in different directions
(e.g. to turn Vernie).
The trailer has one byte different from the other value types

Motor Packet header: 0c 01 81 39 11 0a

Payload
```
              | trailer, same like other packets (0x7F, 0x03)
 7  8  9 10 11 12 13              
00 06 9B 9B 64 7f 03
80 09 9B 64 64 7f 03
00 06 9B 9B 64 7f 03
80 09 9B 64 B4 7f 03  // Note: trailer 11 is different here, 0xB4
         \- duty cycle w/ direction? 0x64=100% 0x9B=100% reverse
```

- Byte 7/8 - at least 8 is a timing
- Byte 9   - duty cycle motor A (including direction)
- Byte 10  - duty cycle motor B (including direction)
- Byte 11  - also looks like a duty cycle, but for what? Thoug 0xB4
             looks like 180 degrees?

The ones starting with '80' seem to turn Vernie a lot. The other two make it
go backwards.

Byte 11: 0xB4 = decimal 180. Maybe degrees? some angle?

#### Duty Cycle

     50% = 0x32 (50  decimal)
    100% = 0x64 (100 decimal)

Duty Cycle also controls the direction:

    50% Clockwise = 50d = 32h
    100% Clockwise = 100d = 64h
    50% Counterclockwise = 255d-50d = 205d = CDh
    100% Counterclockwise = 255d-100d = 155d = 9Bh

#### notes

```
motor A+B 50% 0.1s (not sure, screen too small)
0d:01:81:39:11:0a:64:00:32:32:64:7f:03




68:01 = 360º (LSB + MSB)

0c0081 M 11 09 T DT 647f03 = Turn motor M with duty cycle DT for T milliseconds 
0c0081 M 11 0b DEG 0000 DT 647f03 = Rotate motor M DEG degrees with duty cycle DT

5A 00 = 90º
B4 00 = 180º
0E 01 = 270º
68 01 = 360º
```

