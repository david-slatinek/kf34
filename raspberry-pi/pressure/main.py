#!/usr/bin/env python3

import adafruit_bmp280
import board
from kf34_upload import DeviceType, upload

i2c = board.I2C()
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address=0x76)
bmp280.sea_level_pressure = 1026


if __name__ == '__main__':
    upload(DeviceType.PRESSURE, round(bmp280.pressure, 2))
