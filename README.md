  <br>
  <h1 align="center">Raspberry Pi Dashboard with Home Assistant</h1>
  <br>
</br>  
<p>	  
<h2> Preperation </h2>
</br>
The application is build for my homeassistant. Change the home assisant api token and ip address in main.cpp. 
Change the light and other entities to your entities. 


`SSH` - Connect to your Pi using Secure Shell (Command prompt) with Hostname or IP address
```
ssh username@hostname

ssh username@192.xxx.x.xx
```
Or use PuTTY instead of command prompt. 

`Command 1` - Check and Update our Pi
```
sudo apt-get update -y
```
```
sudo apt-get upgrade -y
```

<h2> Build Application </h2>

`Command 1` - Install Qt6
```
sudo apt install qt6-base-dev qt6-declarative-dev
```

`Command 2` - Install Required Qt Packages
```
sudo apt-get install $(apt-cache search qml6-module | awk '{print $1}')
```

`Command 3` - Build Your Project
```
qmake6
make
```

I'm installed the Raspberry Pi headless with Raspbian OS lite. For running the application on my DSI display, i used eglfs

`Command 4` -  Run Your Application
```
./SmartDashboard -platform eglfs
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
Description=Smart Home Dashboard
After=multi-user.target

[Service]
Type=simple
WorkingDirectory=/home/pi/Smart-Home-Dashboard/
ExecStart=/home/pi/Smart-Home-Dashboard/SmartDashboard -platform eglfs
Restart=always
User=pi
Environment=QT_QPA_PLATFORM=eglfs

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
I have added a Time-of-Flight (ToF) sensor to automatically turn the screen on and off. Without this sensor, the screen would remain constantly on, leading to increased power consumption. <a href="https://github.com/NielsU97/Smart-Home-Dashboard/blob/main/display_motion_react.py" target="_blank">Click here for the code example</a>.
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
User=Niels
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/Niels/Smart-Home-Dashboard/.Xauthority
ExecStart=/usr/bin/python3 /home/Niels/Smart-Home-Dashboard/display_motion_react.py
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