#!/usr/bin/env bash
#
# This script read the last color index value received from BOOST
# stored in a file by other script (color-listener.sh) and speaks
# loud its color meaning 
# Demo video: https://youtu.be/j6QjDPRiW7E
#
while true; do
  sleep 1
  color=`cat BOOSTcolor.txt`
  case $color in
      00)
        espeak -a 200 -s 120 "BLACK" --stdout | aplay --quiet
        ;;
      03)
        espeak -a 200 -s 120 "BLUE" --stdout | aplay --quiet
        ;;
      05)
        espeak -a 200 -s 120 "GREEN" --stdout | aplay --quiet
        ;;
      07)
        espeak -a 200 -s 120 "YELLOW" --stdout | aplay --quiet
        ;;
      09)
        espeak -a 200 -s 120 "RED" --stdout | aplay --quiet
        ;;
      0a)
        espeak -a 200 -s 120 "WHITE" --stdout | aplay --quiet
        ;;
      ff)
        # echo "TOO FAR"
        ;;
      *)
        # echo "???"
        ;;
  esac
done
