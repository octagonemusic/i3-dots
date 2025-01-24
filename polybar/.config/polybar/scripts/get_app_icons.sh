#!/bin/bash

# Define a mapping of application names to FontAwesome icons
declare -A app_icons=(
  # Browsers
  ["firefox"]="\ue007"        # Firefox
  ["google-chrome"]="\uf268" # Google Chrome
  ["chromium"]="\uf268"      # Chromium
  ["brave-browser"]="\uf267" # Brave Browser

  # Terminals
  ["alacritty"]="\uf489 "     # Alacritty
  ["gnome-terminal"]="\uf120" # GNOME Terminal
  ["kitty"]="\uf120"         # Kitty Terminal
  ["xterm"]="\uf120"         # XTerm

  # Code Editors
  ["code"]="\uf121"          # Visual Studio Code
  ["cursor"]="\uf121"        # Cursor
  ["sublime_text"]="\uf1cb"  # Sublime Text
  ["atom"]="\uf469"          # Atom Editor
  ["jetbrains-idea"]="\ue7a8" # JetBrains IDEA

  # Music/Media
  ["spotify"]="\uf1bc"       # Spotify
  ["vlc"]="\uf8e6"           # VLC Media Player
  ["rhythmbox"]="\uf025"     # Rhythmbox

  # File Managers
  ["nautilus"]="\uf07c"      # Nautilus
  ["thunar"]="\uf07c"        # Thunar
  ["dolphin"]="\uf0c5"       # Dolphin
  ["nemo"]="\uf07c"          # Nemo

  # Communication
  ["discord"]="\uf392"       # Discord
  ["slack"]="\uf198"         # Slack
  ["telegram-desktop"]="\uf2c6" # Telegram
  ["signal"]="\uf3d3"        # Signal

  # Office/Productivity
  ["libreoffice-writer"]="\uf1c2" # LibreOffice Writer
  ["libreoffice-calc"]="\uf0ce"   # LibreOffice Calc
  ["notion"]="\uf1cb"            # Notion
  ["obsidian"]="\uf249"          # Obsidian

  # Utilities
  ["gnome-screenshot"]="\uf03e" # Screenshot Tool
  ["htop"]="\uf2db"             # htop (System Monitor)
  ["system-monitor"]="\uf108"   # System Monitor

  # Miscellaneous
  ["gimp"]="\uf1fc"             # GIMP
  ["inkscape"]="\uf048"         # Inkscape
  ["steam"]="\uf1b6"            # Steam
  ["lutris"]="\uf1b6"           # Lutris
  ["bitwarden"]="\uf84a"        # Bitwarden

  # Default Icon
  ["default"]="\uf067"          # Default Icon (Any other app)
)

# Get the active window's class name using xprop
window_id=$(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5)
if [[ -n "$window_id" && "$window_id" != "0x0" ]]; then
    window_class=$(xprop -id "$window_id" WM_CLASS | cut -d '"' -f 4 | tr '[:upper:]' '[:lower:]')
else
    window_class=""
fi

# Get the icon
if [[ -n "$window_class" ]]; then
    if [[ -n "${app_icons[$window_class]}" ]]; then
        printf "%b" "${app_icons[$window_class]}"
    else
        printf "%b" "${app_icons[default]}"
    fi
else
    printf "%b" "${app_icons[default]}"
fi
