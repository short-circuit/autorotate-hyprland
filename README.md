## autorotate-hyprland

🔄 Automatic display rotation for Hyprland based on accelerometer input - perfect for tablets and convertible laptops!

### 🚀 Features

- **Automatic rotation**: Seamlessly rotates your display based on device orientation
- **Accelerometer integration**: Uses `iio-sensor-proxy` for reliable sensor data
- **Hyprland native**: Built specifically for the Hyprland compositor
- **Toggle control**: Easy keyboard shortcut to enable/disable rotation
- **Lightweight**: Minimal resource usage with efficient shell scripts

### 📱 Perfect for

- Tablet PCs running Hyprland
- Convertible laptops (2-in-1 devices)
- Any device with accelerometer sensors
- Users who frequently switch between portrait and landscape modes

### 🛠️ Installation

**Install dependencies:**
```bash
yay -S iio-sensor-proxy iio-hyprland
```

**Setup scripts:**
1. Copy the scripts to your preferred location (e.g., `~/.config/hypr/scripts/`)
2. Make the files executable:
   ```bash
   chmod +x ~/.config/hypr/scripts/rotate-screen.sh ~/.config/hypr/scripts/toggle-rotation.sh
   ```

**Configure Hyprland:**
1. Add to your Hyprland config for auto-start:
   ```
   exec-once = ~/.config/hypr/scripts/rotate-screen.sh
   ```

2. Add keybinding to toggle rotation:
   ```
   bind = SUPER, R, exec, ~/.config/hypr/scripts/toggle-rotation.sh
   ```

3. Restart Hyprland and enjoy automatic rotation!

### 🎮 Usage

- **Automatic mode**: Simply rotate your device - the screen follows automatically
- **Manual toggle**: Press `Super + R` to enable/disable auto-rotation
- **Instant response**: Smooth transitions without lag

### 🤝 Contributing

Contributions welcome! Whether it's bug fixes, feature enhancements, or compatibility improvements.

### 📋 Requirements

- Hyprland compositor
- Device with accelerometer sensor
- `iio-sensor-proxy`
- `iio-hyprland`
