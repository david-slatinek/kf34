#!/usr/bin/env python3

from smbus2 import SMBus
import csv
from enum import Enum

ADDRESS = 0x48
TEMP_REGISTER = 0x0


class DeviceType(Enum):
    BODY_TEMPERATURE = 0


def write(device_type: DeviceType, value: float):
    with open('../results.csv', 'a') as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([device_type.name, value])


if __name__ == "__main__":
    with SMBus(1) as bus:
        raw_data = bus.read_i2c_block_data(ADDRESS, TEMP_REGISTER, 2)
        temp = (raw_data[0] << 8 | raw_data[1]) * 0.00390625
        write(DeviceType.BODY_TEMPERATURE, temp)
