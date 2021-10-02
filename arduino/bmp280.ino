#include <Wire.h>
#include <SPI.h>
#include <Adafruit_BMP280.h>

#define BMP280_ADDRESS  0x76

Adafruit_BMP280 bmp280;

void setup() {
  Serial.begin(9600);

  while (!bmp280.begin(BMP280_ADDRESS)) {
    Serial.println("Could not find a valid BMP280 sensor, check wiring!");
    delay(1000);
  }
  Serial.println("Sensor found!");
}

void loop() {
  float pressure = bmp280.readPressure();

  Serial.print("Pressure    = ");
  Serial.print(pressure / 100);
  Serial.println(" hPa\n");

  delay(1000);
}
