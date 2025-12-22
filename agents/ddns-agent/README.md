# Cloudflare DDNS Agent

About SDK: [https://developers.cloudflare.com/api/go/resources/dns/](https://developers.cloudflare.com/api/go/resources/dns/)

## Build
```bash
go build -o ddns-agent main.go
chmod +x ddns-agent
sudo mv ddns-agent /usr/local/bin/ddns-agent
```

## Environment Variables
```plaintext
CF_API_TOKEN        Cloudflare API token (DNS_READ, DNS_WRITE requried)
ZONE_ID             Cloudflare zone ID
DOMAIN_NAME         DNS record name to update (e.g. home.example.com)
```


## Systemd Setup (for Linux)
```ini
# /etc/systemd/system/ddns.service
[Unit]
Description=DDNS Agent (Cloudflare)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ddns-agent
Environment=CF_API_TOKEN=xxxx
Environment=ZONE_ID=xxxx
Environment=DOMAIN_NAME=xxxx

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/ddns.timer
[Unit]
Description=Run DDNS Agent periodically

[Timer]
OnBootSec=30
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
```


Apply:

```bash
sudo systemctl daemon-reload
sudo systemctl enable ddns.timer
sudo systemctl start ddns.timer
```

Check:
```bash
systemctl list-timers | grep ddns
```


## LaunchDaemon plist Setup (for MacOS)


```xml
# ~/Library/LaunchAgents/com.yourname.ddns-agent.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.yourname.ddns-agent</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/ddns-agent</string>
    </array>

    <!-- EnvironmentVariables key and its dictionary -->
    <key>EnvironmentVariables</key>
    <dict>
        <key>CF_API_TOKEN</key>
        <string>YOUR_CF_API_TOKEN</string>
        <key>ZONE_ID</key>
        <string>YOUR_CF_ZONE_ID</string>
        <key>DOMAIN_NAME</key>
        <string>YOUR_DDNS_RECORD_NAME</string>
    </dict>

    <!-- AutoRun when Startup -->
    <key>RunAtLoad</key>
    <true/>

    <key>StartInterval</key>
    <integer>300</integer> <!-- 5 mins interval-->

    <!-- stdout/stderr -->
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/ddns.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/ddns.err</string>
</dict>
</plist>
```

Apply:
```bash
launchctl load ~/Library/LaunchAgents/com.yourname.ddns-agent.plist
launchctl start com.yourname.ddns-agent
```

Check:
```bash
launchctl list | grep ddns
```
