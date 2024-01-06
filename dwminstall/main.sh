#!/bin/bash

LOG="error-logs\main.log"
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

chmod +x main.sh
chmod +x tty1.sh
chmod +x config.sh
chmod +x neovim.sh
log "Granted permissions to necessary shell scripts"


sudo pacman -S --noconfirm rofi picom kitty

log "Running DWM installation script"
./tty1.sh
log "Completed DWM installation script"

sleep (90)

log "Running dwm configuration script"
./config.sh
log "Completed dwm configuration script"