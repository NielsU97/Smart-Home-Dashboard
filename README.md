<h2> Build Application </h2>

`Command 1` - Install Required Qt Packages
```
sudo apt-get update
sudo apt install qt6-base-dev qt6-declarative-dev
```

`Command 2` - Build Your Project
```
qmake6
make
```

`Command 3` -  Run Your Application
```
./SmartDashboard
```

<h2> Application on Boot </h2>

`Command 1` - Create a unit file
```
sudo nano /lib/systemd/system/dashboard.service
```

</br>

`Command 2` - Add in the following text (Check your path)
```
[Unit]
Description=Smart Dashboard
After=multi-user.target

[Service]
Type=simple
User=pi
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/pi/.Xauthority
ExecStart=/home/pi/SmartDashboard
WorkingDirectory=/home/pi
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```
</br>

`Command 3` - Enable the unit file which starts the program during the boot sequence
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable dashboard.service
```

</br>

`Command 4` - Reboot Pi and your custom service should start on boot
```
sudo reboot
```

<h2> Extra: Turn off/on the screen using ToF sensor </h2>
<br>
I have added a Time-of-Flight (ToF) sensor to automatically turn the screen on and off. Without this sensor, the screen would remain constantly on, leading to increased power consumption. <a href="https://github.com/NielsU97/HomeDisplay/blob/main/display_motion_react.py" target="_blank">Click here for the code example</a>.
<br>
</br>

`Command 1` - Create a unit file
```
sudo nano /lib/systemd/system/display_motion_react.service
```

</br>

`Command 2` - Add in the following text (Check your path)
```
[Unit]
Description=Display Motion React
After=multi-user.target

[Service]
Type=simple
User=pi #Your username
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/pi/.Xauthority
ExecStart=/usr/bin/python3 /home/pi/display_motion_react.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

</br>

`Command 3` - Enable the unit file which starts the program during the boot sequence
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable display_motion_react.service
```

</br>

`Command 4` - Reboot Pi and your custom service should start on boot
```
sudo reboot
```