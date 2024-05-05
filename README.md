# Air Alarm

## About
This is an android based application that connects to a companion sensor device via Bluetooth to provide real-time, high-frequency monitoring of air quality as well as alarms for indicators that fall below safety or health standards. Users can decide to be alarmed in different ways.

## Showcase

### Application Pages

#### Activation Page

You can see a cloud-shaped bell surrounding the dust, which is the Air Alarm Logo.

![Activation Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/activation.jpg)

#### Overall Score Page

The Overall Score Page assigns and sums the data monitored by the sensors based on their status. 
The statuses of the 5 environment data will be sorted from top to bottom in the order of bad, poor, and good.
Each piece of data is weighted differently. The circle and color underneath the Overall score changes as the score changes, so users can see more visually how the overall air quality is.

![Overall Score Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/overall_score.jpg)

#### Data Viewer Page
The Data Viewer Page allows users to view all 5 environmental data in real time (refresh every 15s).
Users can also access the reference thresholds for 5 branches (Humidity, Temperature, VOCs, CO, Smoke).

![Data Viewer Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/dataviewer.jpg)

#### Threshold Pages

In these 5 threshold pages,
users can check the stars for the non-good statuses they want to monitor.
Then they can customize the notifications in the Notifications Page.

![Humidity Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/thrhumidity.jpg)
![Temperature Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/thrtemperature.jpg)
![VOCs Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/thrvocs.jpg)
![CO Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/thrco.jpg)
![Smoke Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/thrsmoke.jpg)

#### Notifications Page
There are 3 ways to set up notifications. When the switch is turned on, this notification methods will work. All 3 methods can be turned on at the same time, but this will result in some duplicate notifications. Therefore, we recommend that users turn on only one notification method at a time.
![Notifications Page](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/notification.jpg)

* To detect the number of POOR or BAD statuses. Users can fill in the numbers to set the minimum threshold for triggering the notification.
* There are star checkmarks in settings in the Data Viewer branches. The app will send a notification to the user when the environmental statuses of POOR or BAD corresponding to the checked star is monitored.
* The third is to monitor the overall score and will send a notification when the calculated overall score is below the threshold set by the user.

### Sensor Device
This air sensor device is mainly made up of the following components:
* Microcontroller - ESP32-WROOM-32D
* MQ135 Hazardous Gas Sensor
* DHT22 Temperature and Humidity Sensor

![Sensor Device](https://github.com/Hypersaki/casa0015-mobile-assessment/raw/main/DemoScreenshots/sensor_device.jpg)

## Installation

Installation package: .apk

## Author Contact
Zhouyu Jiang

Email Address: ucfniad@ucl.ac.uk