#!/usr/bin/env bash
#
# This script conencts to BOOST Move Hub and configures it
# to continuous color reading mode.
# Last color index value is stored in file 'BOOSTcolor.txt' so
# other script (color-echo.sh) can use it
# Demo video: https://youtu.be/j6QjDPRiW7E
#
# activate notifications
gatttool -i hci0 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
#
# activate continuous color reading and store the 5th byte
gatttool -i hci0 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen | 
  while IFS= read -r line
  do 
    output=${line##*:}
    output2=($output)
    echo ${output2[4]} > BOOSTcolor.txt
  done
