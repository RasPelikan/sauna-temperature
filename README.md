# sauna-temperature

A nodemcu and DS18B20 based temperature measure device indented for usage in a sauna.

There is also a [blog post](http://raspelikan.blogspot.co.at/2017/08/sauna-temperature-measure-device.html) showing some pictures.

Hint: The software reads the temperature every 10 seconds. If you load the site within the first 10 seconds, the result is an empty page. After the first 10 seconds you can click/press the shown temperature to reload the site.

# installation

1. flash your ESP module
2. put ds18b20.lua to the ESP module
3. put init.lua to the ESP module
4. register a name for your ESP module

# flash your ESP module

I used the [nodemcu-build cloud service](https://nodemcu-build.com/) to build a firmware based on master (2017-08-20 18:07:02).

1. Open the site and enter your email-address
2. Select the proper modules (encoder, file, gpio, net, node, 1-wire, timer, uart, wifi)
3. Press the "Start your build" button

After a while you receive an email containing a link like this: "nodemcu-master-9-modules-2017-08-20-18-07-02-float.bin".

I used ESP8266 flasher as shown on this [site](http://randomnerdtutorials.com/flashing-nodemcu-firmware-on-the-esp8266-using-windows/) starting at the headline "Downloading NodeMCU Flasher for Windows".

Now open [ESPlorer](https://esp8266.ru/esplorer/), select the proper COM port and press open. I needed to set the baud rate to 115200 and reset the ESP module to see the output. 

# put ds18b20.lua to the ESP module

This file is a copy of [ds18b20.lua](https://github.com/nodemcu/nodemcu-firmware/blob/925991715f2472d66ce73f5e636d72cfa40d9db2/lua_modules/ds18b20/ds18b20.lua). In the meantime there is a never version but since the older version works there is no need for this project to upgrade the code.

Simply open the file in ESPlorer and press the button "Save to ESP".

# put init.lua to the ESP module

First you have to open the file in ESPlorer. Now adopt the lines

    station_cfg.ssid = "MyWiFi"
    station_cfg.pwd = "high-secure-password"

according your WiFi settings.

Then press the button "Save to ESP". After uploading the file the ESP module will reboot and connect to your WiFi. The device is now ready to use.

# register a name for your ESP module

I configured my WiFi router to assign a static address to the ESP module. Additionally I entered a name in the router config. So I'm able to load the page using the URL http://sauna.local.
