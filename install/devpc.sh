#!/bin/bash
# Dev PC extras - DCV support, lock screen disabling
# Called when omubuntu install --devpc is used

source "$OMUBUNTU_PATH/lib/core.sh"

# -----------------------------------------------------------------------------
# Disable screen lock/screensaver
# -----------------------------------------------------------------------------
# Dev PC users are created without passwords (IAM+SSM gate access). Any lock
# screen that requests a password is a dead end.

disable_screen_lock() {
  log "Disabling screen lock (passwordless dev PC)..."

  # dconf system-wide defaults for MATE + GNOME
  mkdir -p /etc/dconf/profile /etc/dconf/db/local.d /etc/dconf/db/local.d/locks

  cat > /etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

  cat > /etc/dconf/db/local.d/00-devpc-disable-lock << 'EOF'
[org/mate/screensaver]
lock-enabled=false
idle-activation-enabled=false
lock-delay=uint32 0

[org/mate/session]
idle-delay=uint32 0

[org/mate/desktop/session]
idle-delay=uint32 0

[org/mate/power-manager]
lock-use-screensaver=false
lock-on-suspend=false
sleep-computer-ac=0
sleep-computer-battery=0
sleep-display-ac=0
sleep-display-battery=0

[org/mate/lockdown]
disable-lock-screen=true

[org/gnome/desktop/screensaver]
lock-enabled=false
idle-activation-enabled=false

[org/gnome/desktop/session]
idle-delay=uint32 0

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-type='nothing'

[org/gnome/desktop/lockdown]
disable-lock-screen=true
EOF

  # Lock these settings to prevent user override
  cat > /etc/dconf/db/local.d/locks/00-devpc-disable-lock << 'EOF'
/org/mate/screensaver/lock-enabled
/org/mate/screensaver/idle-activation-enabled
/org/mate/lockdown/disable-lock-screen
/org/gnome/desktop/screensaver/lock-enabled
/org/gnome/desktop/lockdown/disable-lock-screen
EOF

  dconf update

  # Disable screensaver autostarts
  mkdir -p /etc/xdg/autostart
  for saver in mate-screensaver light-locker xscreensaver; do
    cat > "/etc/xdg/autostart/${saver}.desktop" << EOF
[Desktop Entry]
Type=Application
Name=${saver} (disabled)
Exec=/usr/bin/true
Hidden=true
NoDisplay=true
X-MATE-Autostart-enabled=false
X-GNOME-Autostart-enabled=false
EOF
  done

  # Login script to kill any remaining screensavers
  cat > /usr/local/bin/devpc-nolock.sh << 'SCRIPT'
#!/bin/sh
xset s off s noblank -dpms 2>/dev/null || true
pkill -x mate-screensaver 2>/dev/null || true
pkill -x light-locker 2>/dev/null || true
SCRIPT
  chmod 755 /usr/local/bin/devpc-nolock.sh

  cat > /etc/xdg/autostart/devpc-nolock.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=DevPC No Lock
Exec=/usr/local/bin/devpc-nolock.sh
Terminal=false
X-GNOME-Autostart-enabled=true
X-MATE-Autostart-enabled=true
EOF

  # Nuclear: mask services, disable D-Bus activation, replace binaries
  systemctl mask mate-screensaver.service light-locker.service 2>/dev/null || true
  systemctl --global mask mate-screensaver.service light-locker.service 2>/dev/null || true

  mkdir -p /etc/dbus-1/services
  cat > /etc/dbus-1/services/org.mate.ScreenSaver.service << 'EOF'
[D-BUS Service]
Name=org.mate.ScreenSaver
Exec=/usr/bin/true
EOF

  for bin in mate-screensaver light-locker; do
    if [ -x "/usr/bin/$bin" ] && [ ! -L "/usr/bin/$bin" ]; then
      dpkg-divert --add --rename --divert "/usr/bin/${bin}.real" "/usr/bin/$bin" 2>/dev/null || true
      printf '#!/bin/sh\nexit 0\n' > "/usr/bin/$bin"
      chmod 755 "/usr/bin/$bin"
    fi
  done

  success "Screen lock disabled"
}

# Run
disable_screen_lock
