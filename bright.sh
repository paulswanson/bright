#!/bin/sh
 
#  Copyright (C) 2019 Paul Swanson
# 
#  Licensed under the GNU General Public License Version 2
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

# ************************************
#
# Adjust Brightness on Intel Backlight
#
# ************************************

# This script enables the brightness up / down (ACPI) hotkeys to adjust an Intel backlight
#
# Tested on MX Linux 18.2 (Debian based) kernel 4.19.0-1-amd64, on a Dell Latitude E7470; good luck to you!
#
# See "man acpid" for implementation details. But basically, this goes in /etc/acpi and events entries are created under /etc/acpi/events like so:
#
# /etc/acpi/events/brightness-up-support:
#
#       event=video[ /]brightnessup
#       action=/etc/acpi/bright.sh "up"
#
# /etc/acpi/events/brightness-down-support:
# 
#       event=video[ /]brightnessdown
#       action=/etc/acpi/bright.sh "down" 
#

MAXB_FILE="/sys/class/backlight/intel_backlight/max_brightness"
B_FILE="/sys/class/backlight/intel_backlight/brightness"
DIVISOR=10 # Adjust in increments of 10%

if [ -z "$1" ]; then
	echo "Usage: $0 up | down"
	return
fi

if [ $1 = "up" -o $1 = "UP" ]; then
	DIRECTION=1
elif [ $1 = "down" -o $1 = "DOWN" ]; then
	DIRECTION=0
else
	echo "Unrecognised parameter. Usage: $0 up | down" 
	return
fi

if [ -f "$MAXB_FILE" ]; then
	read -r MAXB<$MAXB_FILE
	if ! [ "$MAXB" -eq "$MAXB" ] 2> /dev/null
	then
	    	echo "Erro: $MAXB_FILE must contain only one number"
		return
	fi
else 
    	echo "$MAXB_FILE does not exist"
	return
fi


if [ -f "$B_FILE" ]; then
	read -r CURRB<$B_FILE
	if ! [ "$CURRB" -eq "$CURRB" ] 2> /dev/null
	then
	    	echo "Erro: $B_FILE must contain only one number"
		return
	fi
else 
    	echo "$B_FILE does not exist"
	return
fi

if [ "$DIRECTION" -eq "1" ]; then
	NEWB=$(($CURRB+($MAXB/$DIVISOR)))
	if [ "$NEWB" -gt "$MAXB" ]; then
		NEWB=$MAXB
	fi
	echo "$NEWB" > $B_FILE
else
	NEWB=$(($CURRB-($MAXB/$DIVISOR)))

	if [ "$NEWB" -lt "0" ]; then
		NEWB=0
	fi
	echo "$NEWB" > $B_FILE
fi
