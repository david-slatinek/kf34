#!/usr/bin/env python3

import adafruit_bmp280
import board
from enum import Enum
import csv

i2c = board.I2C()
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address=0x76)
bmp280.sea_level_pressure = 1026


class DeviceType(Enum):
    PRESSURE = 0


def write(device_type: DeviceType, value: float):
    with open('../results.csv', 'a') as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([device_type, value])


if __name__ == '__main__':
    write(DeviceType.PRESSURE, round(bmp280.pressure, 2))
