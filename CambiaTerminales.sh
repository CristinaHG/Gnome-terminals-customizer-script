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
#gconftool-2 -t --set /desktop/gnome/background --type string "$FILED"
gsettings set org.gnome.desktop.background picture-uri "file:///$FILED"

#get hibstogram of colours from terminal Image


convert "/var/tmp/$FILECONV" -colors 16 -depth 8 -format '%c' histogram:info:- \
    | sort --numeric-sort \
    | gawk 'match ($0, /^ *[0-9]+: \([^)]+\) (#[0-9A-F]+) .+$/, a) { print a[1] }' \
    | tee "paleta.txt" >/dev/null
  #  | while read colour; do convert -size 20x20 "xc:$colour" +depth miff:-; done \
 #   | montage - -geometry +0+0 "palette.png"


#done

