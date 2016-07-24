#!/bin/sh

currDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Config Options
home_SSID="yourSSID"
home_SSID_passwordfile="$HOME/.xfinitywifi-pwd" # Generated if it does not exist.
home_signal_strength_threshold="-60"
connect_VPN=false
tunnelblick_applescript_connect_script="$currDir/xfinityNeighbors.scpt"
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

if [ $home_connectivity -ge $home_signal_strength_threshold ]; then
    # Home network is close enough to connect, so connect to it.
    networksetup -setairportnetwork en0 $home_SSID $(cat $home_SSID_passwordfile)
else
    # Not close enough, launch VPN if desired
    if [ $connect_VPN ]; then
        osascript $tunnelblick_applescript_connect_script
    fi
fi
