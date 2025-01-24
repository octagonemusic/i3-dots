#!/bin/bash
# FontAwesome icons
WIFI_CONNECTED_ICON=$'\uf1eb'    # Wi-Fi connected
WIFI_DISCONNECTED_ICON=$'\uf05e'  # Wi-Fi disconnected
AVAILABLE_NETWORK_ICON=$'\uf0ac'   # Network icon
REFRESH_ICON=$'\uf021'           # Refresh
DISCONNECT_ICON=$'\uf052'        # Disconnect
SECURED_ICON=$'\uf023'          # Secured network
OPEN_ICON=$'\uf13e'             # Open network

# Function to display the current Wi-Fi status (icon only for the bar)
wifi_status() {
    SSID=$(nmcli -t -f ACTIVE,SSID device wifi | grep '^yes' | cut -d ':' -f 2)
    if [[ -n "$SSID" ]]; then
        echo "$WIFI_CONNECTED_ICON "
    else
        echo "$WIFI_DISCONNECTED_ICON "
    fi
}

# Function to list available Wi-Fi networks
list_networks() {
    if [[ "$1" == "refresh" ]]; then
        nmcli dev wifi rescan
        sleep 1  # Allow time for scanning
    fi
    
    nmcli -t -f SSID,SECURITY,SIGNAL device wifi list | awk -F: -v icon="$AVAILABLE_NETWORK_ICON" -v secured="$SECURED_ICON" -v open="$OPEN_ICON" '
    {
        security = ($2 == "--" ? open : secured);
        printf "%s %s [%s%%] %s\n", icon, $1, $3, security
    }'
}

# Function to connect to a network
connect_to_network() {
    local ssid="$1"
    # Force disconnect first to ensure clean connection
    nmcli device disconnect wlan0 >/dev/null 2>&1
    sleep 1
    
    if nmcli device wifi connect "$ssid"; then
        notify-send "$WIFI_CONNECTED_ICON  Wi-Fi Manager" "Connected to $ssid"
        return 0
    else
        # Try to connect with password prompt if initial connection fails
        if nmcli --ask device wifi connect "$ssid"; then
            notify-send "$WIFI_CONNECTED_ICON  Wi-Fi Manager" "Connected to $ssid"
            return 0
        else
            notify-send "$WIFI_DISCONNECTED_ICON  Wi-Fi Manager" "Failed to connect to $ssid"
            echo "Failed to connect to $ssid"
            return 1
        fi
    fi
}

# Function to manage Wi-Fi with Rofi menu (full info in the prompt)
wifi_menu() {
    SSID=$(nmcli -t -f ACTIVE,SSID device wifi | grep '^yes' | cut -d ':' -f 2)
    current_status="$WIFI_CONNECTED_ICON $SSID"
    [ -z "$SSID" ] && current_status="$WIFI_DISCONNECTED_ICON Disconnected"
    
    networks=$(list_networks)
    menu="$REFRESH_ICON Refresh Networks\n$DISCONNECT_ICON Disconnect\n$networks"
    selection=$(echo -e "$menu" | rofi -dmenu -i -p "$current_status" -theme-str 'listview { lines: 8; }')

    if [[ -z "$selection" ]]; then
        exit 0  # Do nothing if no selection
    elif [[ "$selection" == "$REFRESH_ICON Refresh Networks" ]]; then
        networks=$(list_networks "refresh")
        wifi_menu  # Refresh by calling itself
    elif [[ "$selection" == "$DISCONNECT_ICON Disconnect" ]]; then
        SSID=$(nmcli -t -f NAME connection show --active | head -n 1)
        if [[ -n "$SSID" ]]; then
            nmcli device disconnect wlan0
            notify-send "$WIFI_DISCONNECTED_ICON  Wi-Fi Manager" "Disconnected from $SSID"
            sleep 1  # Give time for disconnect to complete
        else
            notify-send "$WIFI_DISCONNECTED_ICON  Wi-Fi Manager" "No active connection to disconnect"
        fi
    else
        # Modified SSID extraction to handle the WiFi icon
        selected_ssid=$(echo "$selection" | sed "s/^$AVAILABLE_NETWORK_ICON //" | sed 's/ \[.*\] .//' | sed 's/[[:space:]]*$//')
        connect_to_network "$selected_ssid"
    fi
}

# Click handling
if [[ "$1" == "click" ]]; then
    wifi_menu
    exit 0
fi

# Default to showing Wi-Fi status
wifi_status