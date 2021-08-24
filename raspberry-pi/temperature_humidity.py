#!/usr/bin/env python3

import adafruit_dht
from board import D17
import logging
import subprocess

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")


def handle_error(err):
    logging.error(err)
    subprocess.Popen(["./led_buzzer.py", "-e"])
    subprocess.Popen(["./email.sh", "DHT22", err])


if __name__ == "__main__":
    dht = adafruit_dht.DHT22(D17, use_pulseio=False)

    try:
        temperature, humidity = dht.temperature, dht.humidity
        print(f"Temperature: {temperature}C, humidity: {humidity}%")
    except RuntimeError as error:
        handle_error(error.args[0])
    except Exception as error:
        handle_error(error.args[0])
        dht.exit()
