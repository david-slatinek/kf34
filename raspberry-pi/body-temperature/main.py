#!/usr/bin/env python3

from smbus2 import SMBus
from kf34_upload import DeviceType, upload


ADDRESS = 0x48
TEMP_REGISTER = 0x0


if __name__ == "__main__":
    with SMBus(1) as bus:
        raw_data = bus.read_i2c_block_data(ADDRESS, TEMP_REGISTER, 2)
        temp = (raw_data[0] << 8 | raw_data[1]) * 0.00390625
        upload(DeviceType.BODY_TEMPERATURE, temp)
