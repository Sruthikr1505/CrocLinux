#!/usr/bin/env bash
# Configure CrocLinux theme - Hacker aesthetic (Green on Black) or Dark theme with blue accents

set -euo pipefail

THEME_VARIANT="${1:-hacker}"  # hacker or dark

echo "[+] Configuring CrocLinux theme: $THEME_VARIANT"

if [[ "$THEME_VARIANT" == "hacker" ]]; then
  # Hacker Aesthetic: Green on Black (Matrix Style)
  THEME_NAME="CrocLinux-Hacker"
  echo "[+] Applying Hacker Aesthetic Theme (Green on Black)"
else
  # Dark Theme: Dark with Blue Accents
  THEME_NAME="CrocLinux"
  echo "[+] Applying Dark Theme (Blue Accents)"
fi

# Set XFCE theme
xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME_NAME" || true
xfconf-query -c xsettings -p /Net/IconThemeName -s "CrocLinux" || true
xfconf-query -c xsettings -p /Net/CursorThemeName -s "Adwaita" || true

# Set GTK theme
xfconf-query -c xsettings -p /Gtk/ThemeName -s "CrocLinux" || true
xfconf-query -c xsettings -p /Gtk/IconThemeName -s "CrocLinux" || true

# Set fonts
xfconf-query -c xsettings -p /Gtk/FontName -s "JetBrains Mono 11" || true
xfconf-query -c xsettings -p /Net/FontName -s "JetBrains Mono 11" || true
xfconf-query -c xsettings -p /Net/MonospaceFontName -s "JetBrains Mono 11" || true

# Set desktop wallpaper (if available)
if [[ -f /usr/share/backgrounds/CrocLinux/wallpaper.png ]]; then
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "/usr/share/backgrounds/CrocLinux/wallpaper.png" || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s "5" || true
fi

# Configure panel theme
xfconf-query -c xfce4-panel -p /panels/panel-0/background-style -s "0" || true
xfconf-query -c xfce4-panel -p /panels/panel-0/background-color -s "rgba(26,26,26,0.95)" || true

# Set window manager theme
xfconf-query -c xfwm4 -p /general/theme -s "CrocLinux" || true
xfconf-query -c xfwm4 -p /general/button_layout -s "CHM|" || true
xfconf-query -c xfwm4 -p /general/title_font -s "JetBrains Mono Bold 11" || true

# Configure LightDM theme
if [[ -f /etc/lightdm/lightdm-gtk-greeter.conf ]]; then
  sed -i 's/^theme-name=.*/theme-name=CrocLinux/' /etc/lightdm/lightdm-gtk-greeter.conf || true
  sed -i 's/^icon-theme-name=.*/icon-theme-name=CrocLinux/' /etc/lightdm/lightdm-gtk-greeter.conf || true
  sed -i 's/^background=.*/background=\/usr\/share\/backgrounds\/CrocLinux\/wallpaper.png/' /etc/lightdm/lightdm-gtk-greeter.conf || true
fi

echo "[+] CrocLinux theme configured"

