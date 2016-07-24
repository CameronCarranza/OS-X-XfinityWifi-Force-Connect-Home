tell application "Tunnelblick"
    connect "AirVPN_US-LosAngeles_Alkes_TCP-443"
    get state of first configuration where name = "AirVPN_US-LosAngeles_Alkes_TCP-443"
    repeat until result = "CONNECTED"
        delay 1
        get state of first configuration where name = "AirVPN_US-LosAngeles_Alkes_TCP-443"
    end repeat
end tell
