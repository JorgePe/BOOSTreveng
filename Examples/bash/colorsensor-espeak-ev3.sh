#!/usr/bin/env bash

# activate notifications
gatttool -i hci0 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
# activate continuous color reading
gatttool -i hci0 -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen | 
  while IFS= read -r line
  do 
    output=${line##*:}
    output2=($output)

    case ${output2[4]} in
      00)
        espeak -a 200 -s 130 "BLACK" --stdout | aplay --quiet
        ;;
      03)
        espeak -a 200 -s 130 "BLUE" --stdout | aplay --quiet
        ;;
      05)
        espeak -a 200 -s 130 "GREEN" --stdout | aplay --quiet
        ;;
      07)
        espeak -a 200 -s 130 "YELLOW" --stdout | aplay --quiet
        ;;
      09)
        espeak -a 200 -s 130 "RED" --stdout | aplay --quiet
        ;;
      0a)
        espeak -a 200 -s 130 "WHITE" --stdout | aplay --quiet
        ;;
      ff)
        # echo "TOO FAR"
        ;;
      *)
        # echo "???"
        ;;
    esac
  done
