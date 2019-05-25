# bright
A Linux shell script to adjust an Intel backlight with brightness hotkeys (ACPI)

Can't adjust your laptop's backlight brightness? Here's the particular problem this script solves, read before use ...

Some laptops manage the screen brightness hotkeys a little different to others.

There are two main parts to your brightness hotkeys:

 * How the key press is handled
 * How the backlight brightness is adjusted

This script deals with the following scenario:

 * Brightness hotkeys are handled by ACPI (not by Xorg)
 * Backlight brightness is handled by Intel Backlight driver (not by xbacklight)

To test if this applies to you, run the following two commands:

 * acpi\_listen
  * If the result includes "video/brightnessdown" and "video/brightnessup" then they're ACPI hotkeys (not regular keystrokes)
 * ls -l /sys/class/backlight/intel\_backlight/
  * If there's a bunch of files then you've probably got the Intel backlight driver

You can simply test this script as is:

        sudo bright up
        sudo bright down

If the screen brightness goes up and down accordingly, congratulations you're almost there.

To bind the brightness hotkeys to this script, attempt the following (pressuming your system is running 'acpid' and is configured in a Debian-style ...

Copy the 'bright.sh' script into /etc/acpi and create event entries under /etc/acpi/events like so:

 /etc/acpi/events/brightness-up-support:

       event=video[ /]brightnessup
       action=/etc/acpi/bright.sh "up"

 /etc/acpi/events/brightness-down-support:
 
       event=video[ /]brightnessdown
       action=/etc/acpi/bright.sh "down"

Restart 'acpid' if you can or simply reboot and test out the brightness hotkeys. For me (currently on MX Linux 18.2) it works at both login and session.

See "man acpid" for more details and refer to your distributions documentation; I barely understand this myself.

This script is something I've very much written to solve my own problem. If it helps you then please let me know.

It was tested on MX Linux 18.2 (Debian based) kernel 4.19.0-1-amd64, on a Dell Latitude E7470; good luck to you!
