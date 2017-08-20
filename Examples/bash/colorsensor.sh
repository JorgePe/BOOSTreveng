#!/usr/bin/env bash

# coloredEcho function
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

function coloredEcho(){
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

# activate notifications
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0f --value=0100
# activate continuous color reading
gatttool -b 00:16:53:A4:CD:7E --char-write-req --handle=0x0e --value=0a004101080100000001 --listen | 
  while IFS= read -r line
  do 
    output=${line##*:}
    output2=($output)

    case ${output2[4]} in
      00)
        coloredEcho "BLACK" black
        ;;
      03)
        coloredEcho "BLUE" blue
        ;;
      05)
        coloredEcho "GREEN" green
        ;;
      07)
        coloredEcho "YELLOW" yellow
        ;;
      09)
        coloredEcho "RED" red
        ;;
      0a)
        coloredEcho "WHITE" white
        ;;
      ff)
        echo "TOO FAR"
        ;;
      *)
        echo "???"
        ;;
    esac
  done
