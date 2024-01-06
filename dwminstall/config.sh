#!/bin/bash

CONFIG_DIR="$HOME/.config"

if [ -d "$CONFIG_DIR" ]; then
    rm -r "$CONFIG_DIR/kitty"
    rm -r "$CONFIG_DIR/rofi"
    mv config/kitty "$CONFIG_DIR"
    mv config/rofi "$CONFIG_DIR"
    
    echo "Configuration files moved successfully."
else
    echo "Failure to find ~/.config directory."
fi

