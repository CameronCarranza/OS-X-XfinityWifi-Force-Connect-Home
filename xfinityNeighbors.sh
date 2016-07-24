#!/bin/sh

# Config Options
home_SSID="pfsense-ap-5g-1"
home_SSID_passwordfile="$HOME/.xfinitywifi-pwd" # Generated if it does not exist.
connect_VPN=true
tunnelblick_applescript_connect_script="$HOME/Code/Scripts/xfinityNeighbors.scpt"
# /Config Options

if [ ! -z $PS1 ] && [ ! -f home_SSID_passwordfile ]; then
    # Generate PasswordFile if it does not exist if interactive session.
    while [ -z $home_ssid_password ]; do
        echo "$home_SSID password (will be stored in $home_SSID_passwordfile): "
        read -r -s home_ssid_password
    done
    
    echo $home_ssid_password > $home_SSID_passwordfile
    
fi

sleep 3
wifi_state=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep state | awk '{print $2}')
if [ "$wifi_state" == "init" ]; then
    # Prevent execution loop if WiFi connection fails.
    # Also prevent execution of script if WiFi is not already connected.
    exit 0
fi

# Gather WiFi Info
connection_string=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s | grep $home_SSID)
home_connectivity=$(echo $connection_string | awk '{print $3}')

if [ $home_connectivity -ge -60 ]; then
    # Home network is close enough to connect, so connect to it.
    networksetup -setairportnetwork en0 pfsense-ap-5g-1 $(cat $home_SSID_passwordfile)
else
    # Not close enough, launch VPN if desired
    if [ $connect_VPN ]; then
        osascript $tunnelblick_applescript_connect_script
    fi
fi
