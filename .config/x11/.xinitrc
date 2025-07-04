xrdb -merge ~/.Xresources
xrandr --dpi 192
exec ${1:-bspwm}
