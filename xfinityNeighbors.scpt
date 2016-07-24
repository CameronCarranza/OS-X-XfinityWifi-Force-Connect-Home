tell application "Tunnelblick"
    connect "yourVPNConnectionName"
    get state of first configuration where name = "yourVPNConnectionName"
    repeat until result = "CONNECTED"
        delay 1
        get state of first configuration where name = "yourVPNConnectionName"
    end repeat
end tell
