#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export DISPLAY=:0.0
GSETTINGS_BACKEND=dconf
export GSETTINGS_BACKEND

#declaracion de variables
GCONFT="/usr/bin/gconftool-2"
SORT="/usr/bin/sort"
GAWK="/usr/bin/gawk"
TEE="/usr/bin/tee"
CNVRT="/usr/bin/convert"
ROUTE="/home/cris/mrcrstnherediagmez@gmail.com/HD/*"

#toma aleatoriamente una imágen para la terminal
FILE=$(shuf -n 1 -e $ROUTE)
#toma aleatoriamente otra imágen para el desktop (opcional)
FILED=$(shuf -n 1 -e $ROUTE)
#limpiamos la ruta, nos quedamos solo con el nombre de la imágen
FILECONV=$(basename "$FILE")


#PID=$(pgrep -u $USER gnome-session)
#export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

#redimensionar imágen,esto depende del tamaño de la imágen, no siempre es necesario
#para no modificar la original ni guardar copias innecesarias, la guardamos en /tmp
convert "$FILE" -resize %50 "/tmp/$FILECONV" 

#configuraciones antes de aplicar los cambios para que tengan efecto
$GCONFT --set /apps/gnome-terminal/profiles/Default/background_type --type string "image" #solid por defecto
$GCONFT --set /apps/gnome-terminal/profiles/Default/use_custom_command --type bool "false" 
$GCONFT --set /apps/gnome-terminal/profiles/Default/use_theme_colors --type bool "false"  #true por defecto
$GCONFT --set /apps/gnome-terminal/profiles/Default/use_custom_default_size --type bool "true"
#tomamos la imágen redimensionada y la ponemos como imágen de fondo del terminal
$GCONFT --set /apps/gnome-terminal/profiles/Default/background_image --type string "/tmp/$FILECONV"
#ponemos un color oscuro de fondo de terminal y un nivel de transparencia bajo
#para que se vea mejor el texto
$GCONFT --set /apps/gnome-terminal/profiles/Default/background_color --type string "#181824243131"
$GCONFT --set /apps/gnome-terminal/profiles/Default/background_darkness --type float "0.78"


#get hibstogram of colours from terminal Image to set color lettering that suits 
#hay que poner un color de letra que vaya con los tonos de la imágen, pero que se aprecien bien.
#Para ello:
#1) sacamos el hibstograma de colores de la imágen 
#2) los ordenamos por valor numérico 
#3) filtramos con un patrón solo los código hexadecimal de los colores
#4) escribe valores hexadecimales en fichero de salida
$CNVRT "/tmp/$FILECONV" -colors 25 -depth 6 -format '%c' histogram:info:- \
    | $SORT --general-numeric-sort \
    | $GAWK 'match ($0, /^ *[0-9]+: \([^)]+\) (#[0-9A-F]+) .+$/, a) { print a[1] }' > "/tmp/paleta.txt" #>/dev/null

#abrimos el fichero
exec 3< /tmp/paleta.txt
#leemos 6 lineas del fichero
read color1 <&3
read color2 <&3
read color3 <&3
read color4 <&3
read color5 <&3
read color6 <&3
exec 3<&- #cerrar

#tomamos el último color leído y lo ponemos como color de letra
$GCONFT --set /apps/gnome-terminal/profiles/Default/foreground_color --type string "$color6"

#Cambia la imágen del escritorio
gsettings set org.gnome.desktop.background picture-uri "file:///$FILED"
#dconf write "/org/gnome/desktop/background/picture-uri" "'file://$FILED'"


