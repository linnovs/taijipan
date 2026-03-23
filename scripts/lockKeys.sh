#!/usr/bin/env bash

numlock='false'
capslock='false'
scrolllock='false'

cat /sys/class/leds/input*::numlock/brightness | grep -q 1 && numlock='true'
cat /sys/class/leds/input*::capslock/brightness | grep -q 1 && capslock='true'
cat /sys/class/leds/input*::scrolllock/brightness | grep -q 1 && scrolllock='true'

printf '{"numlock":%s,"capslock":%s,"scrolllock":%s}' "$numlock" "$capslock" "$scrolllock"
