# OS X XfinityWifi Force Connect Home

## TRUSTED SYSTEMS ONLY
This script currently requires that your Wireless password is stored in plaintext in a dotfile due to limitations of `networksetup` command failing to connect when the password is not provided directly. It is recommended that you only run this on a system that is 100% your own with an encrypted drive should it be lost. Solutions are welcome.

### What does it do?
This script checks if your home network is nearby and within a certain threshold (default is greater than **-60 RSSI**). If it is found and meets the RSSI, it will connect you. If the criteria are not met, you may optionally launch a **TunnelBlick** VPN connection to secure your connection.

### How does it work?
This shell script and apple script are designed to 
be executed by [ControlPlane](http://www.controlplaneapp.com/) when the SSID is equal to "xfinitywifi". If your home 
network is found you are connected to it via `networksetup`.
The applescript file is executed by the shellscript if a VPN connection is desired upon failure to connect to the home network.

## Requirements

* [ControlPlane](http://www.controlplaneapp.com/)
* OS X
* A nearby xfinitywifi network.
* (Optional - if you want to launch a VPN when connected to XfinityWifi) [TunnelBlick](https://tunnelblick.net/)

## Script Setup

1. Download the two scripts from this Repository and place them somewhere on your hard drive (in my case, they will be in the `$HOME/Code/Scripts/` folder.
2. Edit `xfinityNeighbors.sh`
    * Change any options in the Config Options section
        * `home_SSID`: the SSID of your home network.
        * `home_SSID_passwordfile`: Dotfile that your network password is stored in (run this script once from the terminal to generate the file from your input).
        * `home_signal_strength_threshold`: maximum RSSI allowed to connect to Home Network. Set this higher if you are not getting autoconnected.
        * `connect_VPN`: Do you want to connect to a TunnelBlick VPN if your home network is not found / cannot be connected to?
        * `tunnelblick_applescript_connect_script`: Path to script if you place it separate from the shell script (otherwise leave this as default).
3. (Optional - TunnelBlick VPN Desired only) `xfinityNeighbors.scpt`
    * Replace all instances of `yourVPNConnectionName` with your VPN name from the TunnelBlick dropdown / Menu.

## ControlPlane Setup

1. Under `Context`, create one called **XfinityWifi**.
2. Under `Evidence Sources`, make sure *Nearby WiFi Network* is checked.
3. Connect to any XfinityWifi Access Point.
4. Under `Rules`, Click the Plus sign at the bottom left and select Add Nearby WiFi Network Rule > WiFi SSID.
    * select `xfinitywifi` for SSID
    * select `XfinityWifi` for Context.
    * leave the Confidence slider at the default (90%)

    ![XfinityWifi Rule](https://i.imgur.com/blgjc3r.png)
