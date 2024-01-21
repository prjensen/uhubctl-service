#!/bin/bash

# intent of this script is to be used in a systemd unit to power cycle a usb port after boot
# set the appropriate binary location, hub, and port values in the INI file before execution

INI=/etc/uhubctl.ini

if [ -e ${INI} ]; then
   source ${INI}

   # BIN, CMDVARS, DELAY from INI file; they must have values!
   if [ -x ${BIN} ]; then
   
      CMD="${BIN} ${CMDVARS}"

      eval ${CMD}
      sleep ${DELAY}
   else
      echo "Unable to find ${BIN}...exiting!"
   fi
fi
