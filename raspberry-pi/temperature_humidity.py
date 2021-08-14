#!/usr/bin/env python3

import adafruit_dht
from board import D17
import logging
import os

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")

if __name__ == "__main__":
    dht = adafruit_dht.DHT22(D17, use_pulseio=False)

    try:
        temperature, humidity = dht.temperature, dht.humidity
        print(f"Temperature: {temperature}C, humidity: {humidity}%")
    except RuntimeError as error:
        logging.error(error.args[0])
    except Exception as error:
        logging.error(error.args[0])
        dht.exit()
        os.system("./led.py -e &")
