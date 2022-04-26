#!/usr/bin/env python3

from board import SCL, SDA
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
import matplotlib.pyplot as plt
import collections

i2c = busio.I2C(SCL, SDA)
ads = ADS.ADS1115(i2c)
channel = AnalogIn(ads, ADS.P0)


if __name__ == "__main__":
    data = collections.deque(0 for _ in range(10))

    while True:
        try:
            # print((channel.value,))
            data.popleft()
            data.append(channel.value)

            plt.cla()
            plt.title("ECG")
            plt.plot(data)
            plt.pause(0.01)
        except KeyboardInterrupt:
            break

plt.savefig("image.png")