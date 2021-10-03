#include <Wire.h>
#include <SPI.h>
#include <Adafruit_BMP280.h>

#define BMP280_ADDRESS 0x76

Adafruit_BMP280 bmp280;

void setup() {
  Serial.begin(9600);

  while (!bmp280.begin(BMP280_ADDRESS)) {
    Serial.println("Could not find a valid BMP280 sensor, check wiring!");
    delay(1000);
  }
}

void loop() {
  if (Serial.available() > 0) {
    String data = Serial.readStringUntil('\n');

    if (data == "get") {
      float pressure = bmp280.readPressure();
      Serial.println(pressure / 100);
    }
  }
}
