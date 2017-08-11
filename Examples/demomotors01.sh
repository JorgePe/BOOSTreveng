#!/usr/bin/env bash

# this script should run on MINDSTORMS EV3 ev3dev, Raspberry Pi Raspbian (with bluez 5) and Ubuntu 17.04
# we assume your BT4 BLE dongle is "hci1", check with "hcitool -a"
# video with expected result: https://youtu.be/o8MbdcJqrmM 

gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0c018139110a00069B9B647f03
sleep 1.5
gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0c018139110a80099B64647f03
sleep 2.4
gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0c018139110a00069B9B647f03
sleep 1.5
gatttool -i hci1 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0c018139110a80099B64B47f03
