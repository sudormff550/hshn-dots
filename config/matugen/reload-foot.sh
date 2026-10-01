#!/usr/bin/env bash
f=~/.config/foot/colors.ini
get() { grep -m1 "^$1=" "$f" | cut -d= -f2; }

seq=""
seq+="\e]10;#$(get foreground)\e\\"
seq+="\e]11;#$(get background)\e\\"
for i in 0 1 2 3 4 5 6 7; do
  seq+="\e]4;$i;#$(get regular$i)\e\\"
  seq+="\e]4;$((i+8));#$(get bright$i)\e\\"
done

for pts in /dev/pts/[0-9]*; do
  printf "$seq" > "$pts" 2>/dev/null
done
