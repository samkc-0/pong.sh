#!/bin/bash

case "$1" in
black) bg_code=0 ;;
red) bg_code=1 ;;
green) bg_code=2 ;;
yellow) bg_code=3 ;;
blue) bg_code=4 ;;
magenta) bg_code=5 ;;
cyan) bg_code=6 ;;
*) bg_code=0 ;;
esac

# hide cursor
tput civis
clear
tput setab $bg_code
tput setaf 7

cols=$(tput cols)
rows=$(tput lines)
mid_x=$((cols / 2))
mid_y=$((rows / 2))

paddle_height=4
p1_y=$((mid_y - paddle_height / 2))
p1_x=2
p2_y=$((mid_y - paddle_height / 2))
p2_x=$((cols - 3))

# for ((y = 0; y < rows; y++)); do
#  for ((x = 0; x < cols; x++)); do
#    tput cup $y 0
#    printf '%*s' "$cols" ''
#  done
#done

# draw borders
for ((x = 0; x < cols; x++)); do
  tput cup 0 $x
  echo -n '-'
  tput cup $((rows - 1)) $x
  echo -n '-'
done
for ((y = 1; y < rows - 1; y++)); do
  tput cup $y 0
  echo -n '|'
  tput cup $y $((cols - 1))
  echo -n '|'
done

# draw player one
for ((i = 0; i < paddle_height; i++)); do
  tput cup $((p1_y + i)) $p1_x
  echo -n '|'
done

# draw player one
for ((i = 0; i < paddle_height; i++)); do
  tput cup $((p2_y + i)) $p2_x
  echo -n '|'
done

#draw ball
tput cup $mid_y $mid_x
echo -n 'O'

tput sgr0
tput cup $((rows - 1)) 0

ball_x=$mid_x
ball_y=$mid_y
ball_dx=1
ball_dy=1
ball_char="O"
trap "tput sgr0; tput cnorm; clear; exit" SIGINT

while true; do
  tput cup $ball_y $ball_x
  echo -n ' '

  ball_x=$((ball_x + ball_dx))
  ball_y=$((ball_y + ball_dy))

  # bounce
  if ((ball_y <= 1 || ball_y >= rows - 2)); then
    ball_dy=$((-ball_dy))
  fi
  if ((ball_x <= 1 || ball_x >= cols - 2)); then
    ball_dx=$((-ball_dx))
  fi

  tput cup $ball_y $ball_x
  echo -n "$ball_char"

  sleep 0.05
done
