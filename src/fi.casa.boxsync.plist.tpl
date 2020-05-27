<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
     <key>Label</key>
     <string>BoxSync</string>
     <key>ProgramArguments</key>
     <array>
          <string>%SCRIPT%</string>
          <string>%WATCHPATH%</string>
          <string>%DESTINATION%</string>
     </array>
     <key>WatchPaths</key>
     <array>
          <string>%WATCHPATH%</string>
     </array>
     <key>RunAtLoad</key><true/>
     <key>StartInterval</key><integer>%INTERVAL%</integer>
</dict>
</plist>