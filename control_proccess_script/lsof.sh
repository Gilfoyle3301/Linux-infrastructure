#!/bin/bash

for pid in $(ls | grep -e "[[:digit:]]")
do

for fu in $(ls -la /proc/$pid/fd | grep -E '/([a-zA-Z]|[0-9]|[_.*#@])+' | awk '{print $4"--->"$11}')
do
echo $(file /proc/$pid/exe | awk '{print $5}') $(grep -e "PPid:" -e "^Pid:" /proc/$pid/status) "U/F: "$fu
done
done
