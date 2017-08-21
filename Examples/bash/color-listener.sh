#!/usr/bin/env bash
#
# This script conencts to BOOST Move Hub and 
# configure it to continuous color reading mode
# Color values are stored in file 'BOOSTcolor.txt'
# for other script (i.e. color-echo.sh) to use
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
