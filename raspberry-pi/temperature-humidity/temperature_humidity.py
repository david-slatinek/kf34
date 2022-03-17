#!/usr/bin/env python3

import logging
import subprocess
from enum import Enum
import csv

import adafruit_dht
from board import D17

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")


class DeviceType(Enum):
    TEMPERATURE = 0
    HUMIDITY = 1


def handle_error(err):
    logging.error(err)
    subprocess.Popen(["../led.py", "-e"])
    subprocess.Popen(["../email.sh", err])


def write(device_type: DeviceType, value: float):
    with open('../results.csv', 'a') as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([device_type.name, value])


if __name__ == "__main__":
    try:
        dht = adafruit_dht.DHT22(D17, use_pulseio=False)
        write(DeviceType.TEMPERATURE, dht.temperature)
        write(DeviceType.HUMIDITY, dht.humidity)
    except RuntimeError as error:
        handle_error(error.args[0])
        dht.exit()
    except Exception as error:
        handle_error(error.args[0])
        dht.exit()
