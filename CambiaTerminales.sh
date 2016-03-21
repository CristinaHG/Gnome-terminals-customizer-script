#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export DISPLAY=:0.0

ROUTE=/home/cris/mrcrstnherediagmez@gmail.com/HD/*
FILE=$(shuf -n 1 -e $ROUTE)
#echo $FILE
FILED=$(shuf -n 1 -e $ROUTE)
#echo $FILED
FILECONV=$(basename "$FILE")
#echo $FILECONV
convert "$FILE" -resize %50 "/var/tmp/$FILECONV" 
#echo $FILECONV
#mv "$FILECONV" "/var/tmp/$FILECONV" > /dev/null
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_custom_default_size --type bool "true"
gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_image --type string "/var/tmp/$FILECONV"
#comprobar version gnome
#gconftool-2 -t --set /desktop/gnome/background --type string "$FILED"

gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_darkness --type float "0.78"
 
gsettings set org.gnome.desktop.background picture-uri "file:///$FILED"

#get hibstogram of colours from terminal Image

convert "/var/tmp/$FILECONV" -colors 25 -depth 6 -format '%c' histogram:info:- \
    | sort --numeric-sort \
    | gawk 'match ($0, /^ *[0-9]+: \([^)]+\) (#[0-9A-F]+) .+$/, a) { print a[1] }' \
    | tee "/var/tmp/paleta.txt" >/dev/null

exec 3< /var/tmp/paleta.txt
read color1 <&3
read color2 <&3
read color3 <&3
read color4 <&3
read color5 <&3
read color6 <&3
exec 3<&-

gconftool-2 --set /apps/gnome-terminal/profiles/Default/foreground_color --type string "$color6"
#gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_color --type string "$color4"
#export PS1
#PS1='${debian_chrootoot)}\[\033[1;32m\]\u@\h\[\e[1;#2C514D\a]:\[\033[01;34m\]\w\[\033[1;37m\]\$ '


#done

