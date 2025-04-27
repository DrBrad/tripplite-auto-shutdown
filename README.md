Tripplite Auto Shutdown
====

You will need to install this:
```
sudo apt-get install nut
sudo apt-get install nut-monitor
sudo upsdrvctl stop
```

Open / edit the following files as root
Example: sudo nano /etc/nut/nut.conf

1. Changes to make to file nut.conf -add the lines below:
```
MODE=standalone
```

2. Changes to make to file ups.conf file -add the lines below:
   You can find your product id by doing: `lsusb -v` then find the variable name and take the value - should be like this: 0x2012 and remove the 0x.
```
[tripplite]
driver = usbhid-ups
port = auto
productid=2012
desc = "Tripp Lite UPS"

#maxretry = 3
```

3. Changes to make to file upsd.conf -add the lines below:
```
LISTEN 127.0.0.1 3493
LISTEN ::1 3493

[tripplite]
driver = usbhid-ups
port = auto
```

4. Restart nut
```
sudo service nut-server restart
sudo upsd -c reload
```
6. Start driver
```
sudo upsdrvctl start
```

If you get an error saying Can't claim USB device [09ae:3024]: could not detach kernel driver from interface 0: Operation not permitted

You can use lsusb to find out the bus and device number for the Tripplite UPS

Then change permission of the device
```
chmod 0666 /dev/bus/usb/[bus number]/[device number]
Chmod 0666 (chmod a+rwx,u-x,g-x,o-x,ug-s,-t) sets permissions so that, (U)ser / owner can read, can write and can't execute. (G)roup can read, can write and can't execute. (O)thers can read, can write and can't execute.
```
Example: Type:
```
lsusb
```
Look for the Tripp Lite line

Bus 003 Device 012: ID 09ae:3024 Tripp Lite (Note if you unplug your usb connection and plug it back in this may change)
```
sudo chmod 0666 /dev/bus/usb/003/012
```

7. Start Driver
```
sudo upsdrvctl start
```

Service
====
If you want to make this a service you can do:

```
sudo cp ups-monitor.service /etc/systemd/system/ups-monitor.service
sudo systemctl daemon-reload
sudo systemctl enable ups-monitor.service
sudo systemctl start ups-monitor.service
```
