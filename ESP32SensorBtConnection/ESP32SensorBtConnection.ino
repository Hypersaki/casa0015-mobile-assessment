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


  float rs = gasSensor.getResistance(); // updated rs
  float rzero = gasSensor.getRZero();   // calculate rzero
  float ratio = rs / rzero;             // caculate ratio
  float ppm = gasSensor.getPPM();       // total ppm, considering as smoke
  float ppmVOCs = (1 / ratio) * 0.28;
  float ppmCO = (1 / ratio) * 3;
  float ppmSmoke = (1 / ratio)* 30;


  if (SerialBT.hasClient()) {
    String data = String(humidity) + "," + String(temperature) + "," +
                  String(ppmVOCs) + "," + String(ppmCO) + "," + String(ppmSmoke) + "\n";
    SerialBT.print(data);
    Serial.println(data);
  } else {
    // if not connected to the client, print "not connected" in the serial monitor
    Serial.println("Bluetooth not connected!");
  }
    // 在 Serial Monitor 打印环境数据
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("%, Temperature: ");
  Serial.print(temperature);
  Serial.print("C, VOCs: ");
  Serial.print(ppmVOCs);
  Serial.print(" ppm, CO: ");
  Serial.print(ppmCO);
  Serial.print(" ppm, Smoke: ");
  Serial.print(ppmSmoke);
  Serial.println(" ppm");
  delay(20000);
}