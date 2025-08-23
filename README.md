# autorotate-hyprland
Rotate your display based on accelerometer input automatically in hyprland

# Installation
Install dependencies
```sh
yay -S iio-sensor-proxy iio-hyprland
```

Copy the scripts to a location of your choice, for example:
`~/.config/hypr/scripts/`
Make the files executable:
```sh
chmod +x ~/.config/hypr/scripts/rotate-screen.sh ~/.config/hypr/scripts/toggle-rotation.sh
```

Then add `rotate-screen.sh` to hyprland execs:
```sh
exec-once = ~/.config/hypr/scripts/rotate-screen.sh
```
and add a binding to enable/disable screen rotation:
```sh
bind = SUPER, R, exec, ~/.config/hypr/scripts/toggle-rotation.sh
```

Restart hyprland and you're good to go!
