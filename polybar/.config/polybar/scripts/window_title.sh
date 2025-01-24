#!/bin/bash

# Get window information using xprop
get_window_info() {
    # Get active window ID
    window_id=$(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5)
    
    if [[ -n "$window_id" && "$window_id" != "0x0" ]]; then
        # Get window title
        title=$(xprop -id "$window_id" WM_NAME 2>/dev/null | cut -d '"' -f 2)
        
        if [[ -n "$title" ]]; then
            # Truncate title if longer than 60 chars
            if [ ${#title} -gt 60 ]; then
                echo "${title:0:57}..."
            else
                echo "$title"
            fi
        else
            echo "Desktop"
        fi
    else
        echo "Desktop"
    fi
}

# Keep the script running to update in real-time
while true; do
    # Get current window info
    title=$(get_window_info)
    icon=$(~/.config/polybar/scripts/get_app_icons.sh)
    
    # Output formatted string with explicit font settings
    if [[ "$title" != "Desktop" ]]; then
        printf "%%{T4}%b%%{T-}%%{T1} %s%%{T-}\n" "$icon" "$title"
    else
        printf "%%{T4}%%{T-}%%{T1} Desktop%%{T-}\n"
    fi
    
    sleep 0.1
done 