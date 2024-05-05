
# Air Alarm

## About
This is an android based application that connects to a companion sensor device via Bluetooth to provide real-time, high-frequency monitoring of air quality as well as alarms for indicators that fall below safety or health standards. Users can decide to be alarmed in different ways.

## Showcase

### Application Page

#### Activation Page
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/activation.jpg" alt="Activation Page" style="width: 50%;">

You can see a bell surrounding the dust, which is the Air Alarm Logo.

#### Overall Score Page
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/overall_score.jpg" alt="Overall Score Page" style="width: 50%;">

The Overall Score Page assigns and sums the data monitored by the sensors based on their status. Each piece of data is weighted differently. The circle and color underneath the Overall score changes as the score changes, so users can see more visually how the overall air quality is.

####  Data Viewer Page
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/dataviewer" alt="Data Viewer Page" style="width: 50%;">

The Data Viewer Page allows users to view the reference thresholds for 5 sub-screens (Humidity, Temperature, VOCs, CO, Smoke). In addition, users can check the asterisks for the non-good statuses they want to listen to and customize the notifications in the Notifications Page.

Humidity Page 
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/thrhumidity.jpg" alt="Humidity Page" style="width: 20%;">
Temperature Page 
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/thrtemperature.jpg" alt="Temperature Page" style="width: 20%;">
VOCs Page 
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/thrvocs.jpg" alt="VOCs Page" style="width: 20%;">
CO Page 
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/thrco.jpg" alt="CO Page" style="width: 20%;">
Smoke Page 
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/thrsmoke.jpg" alt="Temperature Page" style="width: 20%;">

#### Notifications Page
<img src="https://github.com/Hypersaki/casa0015-mobile-assessment/tree/main/DemoScreenshots/notification.jpg" alt="Notification Page" style="width: 20%;">

Users have 3 ways to set up notifications. When the switch is turned on, this notification method will continue to work. all 3 methods can be turned on at the same time, but this will result in some duplicate notifications. Therefore, we recommend that users turn on only one notification method at a time.
* The first is to detect the number of POOR or BAD statuses. Users can fill in the numbers to set the minimum threshold for triggering the notification.
* The second is an star checkmark for the 5 settings in the Data Viewer sub-screen. The app will send a notification to the user when the environmental statuses of POOR or BAD corresponding to the checked star is monitored.
* The third is to monitor the overall score and will send a notification when the calculated overall score is below the threshold set by the user.

### Sensor Device
This air sensor device is mainly made up of the following components:
* Microcontroller - ESP32-WROOM-32D
* MQ135 Hazardous Gas Sensor
* DHT22 temperature and humidity sensor

<img src="https://github.com/Hypersaki/!!!" alt="!!!" style="width: 50%;">

## Installation

Installation package: .apk

## Author Contact
Zhouyu Jiang
Email Address: ucfniad@ucl.ac.uk 