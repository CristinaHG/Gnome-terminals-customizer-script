#!/bin/bash
#FILES=(/home/cris/mrcrstnherediagmez@gmail.com/HD/*)
#for f in $FILES;
#do echo "${FILES[RANDOM % ${#files[@]}]}";
ROUTE=/home/cris/mrcrstnherediagmez@gmail.com/HD/*
FILE=$(shuf -n 1 -e $ROUTE)
echo $FILE
FILED=$(shuf -n 1 -e $ROUTE)
echo $FILED
FILECONV=$(basename "$FILE")
echo $FILECONV
convert "$FILE" -resize %50 "/var/tmp/$FILECONV" 
echo $FILECONV
mv "$FILECONV" "/var/tmp/$FILECONV"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_custom_default_size --type bool "true"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_image --type string "/var/tmp/$FILECONV"
#comprobar version gnome
#gconftool-2 -t --set /desktop/gnome/background --type string "/var/tmp/$FILED"
gsettings set org.gnome.desktop.background picture-uri "file:///$FILED"

#done

