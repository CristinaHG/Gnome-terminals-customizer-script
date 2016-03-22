#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export DISPLAY=:0.0


if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] ; then
 TMP=~/.dbus/session-bus
 export $(grep -h DBUS_SESSION_BUS_ADDRESS= $TMP/$(ls -1t $TMP | head -n 1))
 echo $DBUS_SESSION_BUS_ADDRESS >> $LOG
fi



#export $(xargs -n 1 -0 echo </proc/$(pidof x-session-manager)/environ | grep -Z DBUS_SESSION_BUS_ADDRESS=) >/dev/null
#DBUSFILE=$HOME/.dbus_session_bus_address
#export DBUS_SESSION_BUS_ADDRESS =`cat $DBUSFILE`

GCONFT=/usr/bin/gconftool-2
GSTNS=/usr/bin/gsettings
GCONFKEY=/.gconf/desktop/gnome/background
ROUTE=/home/cris/mrcrstnherediagmez@gmail.com/HD/*
FILE=$(shuf -n 1 -e $ROUTE)
#echo $FILE
FILED=$(shuf -n 1 -e $ROUTE)
#echo $FILED
FILECONV=$(basename "$FILE")




#export $(xargs -n 1 -0 echo </proc/$(pidof x-session-manager)/environ | grep -Z DBUS_SESSION_BUS_ADDRESS=)


#echo $FILECONV
convert "$FILE" -resize %50 "/tmp/$FILECONV" 
#echo $FILECONV
#mv "$FILECONV" "/var/tmp/$FILECONV" > /dev/null
$GCONFT --set /apps/gnome-terminal/profiles/Default/use_custom_default_size --type bool "true"
$GCONFT --set /apps/gnome-terminal/profiles/Default/background_image --type string "/tmp/$FILECONV"

$GCONFT --set /apps/gnome-terminal/profiles/Default/background_darkness --type float "0.78"
#change Desktop image
#gconftool-2 -t --set /desktop/gnome/background --type string "$FILED"
$GSTNS set org.gnome.desktop.background picture-uri "file:///$FILED"


#get hibstogram of colours from terminal Image to set color lettering that suits 
	
/usr/bin/convert "/tmp/$FILECONV" -colors 25 -depth 6 -format '%c' histogram:info:- \
    | /usr/bin/sort --numeric-sort \
    | /usr/bin/gawk 'match ($0, /^ *[0-9]+: \([^)]+\) (#[0-9A-F]+) .+$/, a) { print a[1] }' \
    | /usr/bin/tee "/tmp/paleta.txt" >/dev/null

exec 3< /tmp/paleta.txt
read color1 <&3
read color2 <&3
read color3 <&3
read color4 <&3
read color5 <&3
read color6 <&3
exec 3<&-

$GCONFT --set /apps/gnome-terminal/profiles/Default/foreground_color --type string "$color6"

#gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_color --type string "$color4"
#export PS1
#PS1='${debian_chrootoot)}\[\033[1;32m\]\u@\h\[\e[1;#2C514D\a]:\[\033[01;34m\]\w\[\033[1;37m\]\$ '


#done

