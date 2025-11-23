# CrocLinux Theme Guide

## Overview
CrocLinux features a custom dark theme with blue accents, designed for SOC analysts and security professionals. The theme provides a professional, easy-on-the-eyes interface optimized for long hours of monitoring and analysis.

## Theme Design

### Color Scheme
- **Background**: Dark (#1a1a1a) - Reduces eye strain
- **Foreground**: Light (#e0e0e0) - High contrast for readability
- **Accent Color**: Blue (#00a8ff) - CrocLinux brand color
- **Selection**: Blue (#00a8ff) - Clear visual feedback

### Typography
- **Font**: JetBrains Mono 11pt
- **Monospace**: JetBrains Mono 11pt
- **Style**: Modern, clean, readable

### Icons
- **Icon Theme**: CrocLinux (custom) / Papirus (fallback)
- **Cursor Theme**: Adwaita
- **Style**: Flat, modern, professional

## Theme Components

### Desktop Environment
- **Window Manager**: XFWM4 with CrocLinux theme
- **Panel**: Dark panel with blue accents
- **Desktop**: Dark background with optional wallpaper
- **Menu**: Dark menu with blue highlights

### Terminal
- **Color Scheme**: Dark with blue accents
- **Transparency**: 90% opacity
- **Cursor**: Blue (#00a8ff)
- **Font**: JetBrains Mono 11pt

### Login Screen
- **Theme**: CrocLinux dark theme
- **Background**: CrocLinux wallpaper
- **Branding**: CrocLinux logo and branding
- **Style**: Clean, professional, secure

## Theme Configuration

### Applying Theme
The theme is automatically applied during installation. To manually apply:

```bash
# Run theme configuration script
sudo /opt/croc/scripts/base/configure_theme.sh

# Or configure manually
xfconf-query -c xsettings -p /Net/ThemeName -s "CrocLinux"
xfconf-query -c xsettings -p /Net/IconThemeName -s "CrocLinux"
```

### Customizing Theme

#### Change Colors
Edit `/usr/share/themes/CrocLinux/gtk-3.0/gtk.css`:

```css
@define-color croc_dark_bg #1a1a1a;
@define-color croc_dark_fg #e0e0e0;
@define-color croc_blue_accent #00a8ff;
```

#### Change Fonts
Edit `~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml`:

```xml
<property name="FontName" type="string" value="JetBrains Mono 11"/>
```

#### Change Wallpaper
```bash
# Set wallpaper
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "/path/to/wallpaper.png"

# Or use Settings → Desktop → Background
```

### Terminal Theme
Edit `~/.config/xfce4/terminal/terminalrc`:

```ini
[Configuration]
BackgroundColor=#1a1a1a
ForegroundColor=#e0e0e0
CursorColor=#00a8ff
FontName=JetBrains Mono 11
```

## Theme Files

### Location
- **GTK Theme**: `/usr/share/themes/CrocLinux/`
- **Icon Theme**: `/usr/share/icons/CrocLinux/`
- **Wallpaper**: `/usr/share/backgrounds/CrocLinux/`
- **Configuration**: `~/.config/xfce4/`

### Key Files
- `gtk-3.0/gtk.css` - GTK3 theme styles
- `gtk-2.0/gtkrc` - GTK2 theme styles
- `index.theme` - Theme metadata
- `xfwm4/` - Window manager theme

## Theme Features

### Dark Mode
- Reduces eye strain
- Professional appearance
- Better for SOC environments
- Energy efficient (OLED displays)

### Blue Accents
- CrocLinux brand color
- Clear visual feedback
- Professional appearance
- Easy to distinguish

### High Contrast
- Improved readability
- Better accessibility
- Clear visual hierarchy
- Professional appearance

## Customization Options

### Change Theme
```bash
# Install new theme
sudo apt-get install arc-theme

# Apply theme
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
```

### Change Icons
```bash
# Install new icon theme
sudo apt-get install papirus-icon-theme

# Apply icon theme
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
```

### Change Fonts
```bash
# Install new font
sudo apt-get install fonts-roboto

# Apply font
xfconf-query -c xsettings -p /Net/FontName -s "Roboto 11"
```

## Theme Troubleshooting

### Theme Not Applying
```bash
# Check theme files
ls -la /usr/share/themes/CrocLinux/

# Verify theme configuration
xfconf-query -c xsettings -p /Net/ThemeName

# Restart XFCE
xfce4-panel -r
```

### Icons Not Showing
```bash
# Check icon theme
ls -la /usr/share/icons/CrocLinux/

# Verify icon configuration
xfconf-query -c xsettings -p /Net/IconThemeName

# Refresh icon cache
sudo gtk-update-icon-cache /usr/share/icons/CrocLinux/
```

### Fonts Not Loading
```bash
# Check font files
ls -la /usr/share/fonts/truetype/jetbrains-mono/

# Verify font configuration
xfconf-query -c xsettings -p /Net/FontName

# Refresh font cache
fc-cache -fv
```

## Best Practices

### Theme Maintenance
- Keep theme files updated
- Test theme changes
- Backup theme configuration
- Document customizations

### Performance
- Use lightweight themes
- Optimize theme files
- Cache theme assets
- Minimize theme complexity

### Accessibility
- High contrast colors
- Readable fonts
- Clear visual feedback
- Consistent styling

## Next Steps

1. **Customize Theme**: Adjust colors, fonts, and icons
2. **Test Theme**: Verify theme works correctly
3. **Share Theme**: Contribute theme improvements
4. **Document Changes**: Document customizations

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

