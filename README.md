  <br>
  <h1 align="center">QT Dashboard for Raspberry Pi with Home Assistant api</h1>
  <br>
 <p align="center">
<img src="https://github.com/NielsU97/HomeDisplay/blob/main/screenshot.png" width="1000">
  </br>
</br>  
<p>
<h2> Preparation </h2>
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