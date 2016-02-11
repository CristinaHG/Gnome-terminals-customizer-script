#!/bin/bash
#FILES=(/home/cris/mrcrstnherediagmez@gmail.com/HD/*)
#for f in $FILES;
#do echo "${FILES[RANDOM % ${#files[@]}]}";
ROUTE=/home/cris/mrcrstnherediagmez@gmail.com/HD/*
FILE=$(shuf -n 1 -e $ROUTE)
echo $FILE.$1
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_custom_default_size --type bool "true"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_image --type string "$FILE"

#gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_image --type string "/home/cris/mrcrstnherediagmez@gmail.com/HD/[1600x900] - wallpaper_619186188.jpg"

#done

