#include <Adafruit_Sensor.h>
#include <DHT.h>
#include "MQ135.h"
#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

#define DHTPIN 23 //P23 for DHT22 Data pin
#define DHTTYPE DHT22
#define MQ135PIN 34 //P34 for MQ135 AOUT

DHT dht(DHTPIN, DHTTYPE);
MQ135 gasSensor(MQ135PIN);

void setup() {
  Serial.begin(9600);
  SerialBT.begin("ESP32_Sensor");
  dht.begin();
}

void loop() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  float ppm = gasSensor.getPPM();
  float correctionFactor = 0.8 + (temperature - 20) * 0.02;
  ppm *= correctionFactor;
  
  float ppmVOCs = ppm * 0.1;
  float ppmCO = ppm * 0.2;
  float ppmSmoke = ppm * 0.3;

  if (SerialBT.hasClient()) {
    String data = String(humidity) + "," + String(temperature) + "," +
                  String(ppmVOCs) + "," + String(ppmCO) + "," + String(ppmSmoke) + "\n";
    SerialBT.print(data);
    Serial.println(data);
  } else {
    // if not connected to the client, print "not connected" in the serial monitor
    Serial.println("Bluetooth not connected!");
  }
  delay(8000);
}