
# Powered Up Hub

Powered Up is slightly different from Boost. Most of the WeDo and Boost devices are supported with the Powered Up Hub, with one exception - with the Boost Interactive Motor, it is not (currently) possible to either rotate it by angle, or get rotation notifications from it.


# Ports

The ports on the Powered Up Hub are labbeled 0x00 and 0x01 respectively.


# Motor

This command activates any type of motor:

`[0x0a, 0x00, 0x81, port, 0x11, 0x60, 0x00, speed, 0x00, 0x00]`

This command activates a motor for a certain amount of time. The time period is unknown, maybe CPU ticks?

`[0x0a, 0x00, 0x81, port, 0x11, 0x60, 0x00, speed, time, 0x00]`

Making the last byte 0x01 (or anything other than 0x01) activates "swing mode" - the motor activates for a certain amount of time, reverses for the same amount of time, then loops indefinitely.

`[0x0a, 0x00, 0x81, port, 0x11, 0x60, 0x00, speed, time, 0x01]`

Another command was found for activating Boost motors only:

`[0x08, 0x00, 0x81, 0x01, 0x11, 0x02, speed1, speed2]`

Where speed1 is for the Boost motor on port A, and speed2 is for the Boost motor on port B. However with both motors plugged in it seems to crash the Hub. Perhaps the implementation of this was never finished. :)


# Powered Up Remote

The Powered Up Remote actually behaves mostly like any other Boost/LPF2 hub!


# LED

The LED light on the top functions the same, except it is attached to virtual port 0x34 instead of 0x32.


# Buttons

The green button in the middle can be read like the green button on any other LPF2 hub with no changes. The left and right sets of buttons are slightly different.

The buttons are clustered into two seperate groups - up, down, and stop. The cluster of buttons advertises itself as sensor type 0x37. The left set of buttons are attached to virtual port 0x00, and the right set to virtual port 0x01. Both clusters can be activated by sending a sensor activation command with mode 0x00.

After activation, you'll start to receive five byte sensor notifications. The fourth byte is the port (0x00 for left cluster, 0x01 for right cluster), the fifth byte is the type of action:

* Up - `0x01`
* Down - `0xff`
* Stop - `0x7f`
* Released - `0x00` (This is send regardless of which button was released, I assume this means that each cluster can only recognise one button press at a time)