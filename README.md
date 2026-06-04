# XFCE4 Desktop Hardware Brightness Controller

A lightweight, minimal, and dependency-aware brightness panel utility designed specifically for **XFCE4** desktop users. This script interfaces directly with desktop monitors using hardware **DDC/CI** communication via `ddcutil`, providing a live percentage readout on your top bar and an interactive, clean GTK slider window upon clicking.

---

## ⚡ Features

* 📟 **Live Hardware Status:** Queries your external monitor's VCP memory directly for accurate backlighting reads.
* 🖥️ **Sleek Unified UI:** Styled in bold text matching high-visibility system readouts.
* 🎛️ **Pop-up GTK Slider:** Clicking the panel metric reveals an elegant, mouse-centered brightness slider using `yad`.
* 🔋 **Ultra Lightweight:** Uses `ddcutil`'s raw/terse `-t` data mode to bypass heavy text processing and conserve system loops.

---

## 📋 Prerequisites & Installation

Since desktop monitors lack direct operating system backlight hooks, this implementation relies on the **I2C pins** inside your video cable (VGA/HDMI/DisplayPort). Follow these steps to authorize your system:

### 1. Install Necessary System Tools
On **Arch Linux**, run:
```bash
sudo pacman -S ddcutil yad xfce4-genmon-plugin
```

### 2. Configure Hardware Communication Kernel Modules
Force Linux to spin up the I2C interface line on startup:
```bash
sudo echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c.conf
```
*Load it immediately for your current session without rebooting:*
```bash
sudo modprobe i2c-dev
```

### 3. Setup Hardware Access Rules (Udev Permissions)
By default, only the `root` user can adjust display configurations. Create a system rule to safely grant access to your account:
```bash
sudo nano /etc/udev/rules.d/99-i2c.rules
```
Paste this inside the file:
```text
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
```
Save and apply the rules:
```bash
sudo udevadm control --reload-rules && sudo udevadm trigger
```
```bash
sudo usermod -aG i2c $USER
```
⚠️ **Important:** Log out of your XFCE desktop environment session and log back in to finalize user security clearances.

---

## 🚀 Setup & Script Configuration

1. Download the script file from this repo's **Releases** tab:
   ```bash
   monitor_brightness.sh
   ```
2. Put the script file in your local binary path:
   Enable show hidden files and create the folders then put the script file there
   ```bash
   /home/YOUR_USERNAME/.local/bin/monitor_brightness.sh
   ```

### 🛠️ Add to the XFCE Top Panel
1. Right-click your top bar -> **Panel** -> **Add New Items...**
2. Select **Generic Monitor** (`genmon`) and click Add.
3. Right-click the newly populated item -> **Properties**.
4. Configure it precisely as follows:
   * **Command:** `/home/YOUR_USERNAME/.local/bin/monitor_brightness.sh` *(Make sure to replace with your actual directory path)*
   * **Label:** *Uncheck* (Keep this blank for the minimalist look)
   * **Period (s):** Set to `3.00`
5. Click Close.

---

## 📄 License
This utility is open-sourced under the MIT License. Feel free to copy, modify, and distribute!
