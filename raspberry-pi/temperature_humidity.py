#!/usr/bin/env python3

import logging
import subprocess
from enum import Enum
from os import environ

import adafruit_dht
import requests
from board import D17

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")


class DeviceType(Enum):
    TEMPERATURE = 0
    HUMIDITY = 1


def handle_error(err):
    logging.error(err)
    subprocess.Popen(["./led_buzzer.py", "-e"])
    subprocess.Popen(["./email.sh", "DHT22", err])


def upload(value, device_type):
    url = 'url'
    query = """
                mutation AddData($value: Float!, $device_type: DeviceType!) {
                    addData(value: $value, device_type: $device_type) {
                        success
                        error
                    }
                }
            """

    variables = {'value': value, 'device_type': device_type}

    r = requests.post(url=url, json={'query': query, 'variables': variables}, headers={'X-API-Key': environ.get("KEY")})
    if r.status_code == 200:
        data = r.json()
        if not data["data"]["addData"]["success"]:
            logging.error(data["data"]["addData"]["error"])
    else:
        logging.error(str(r.status_code) + "-" + str(device_type))


if __name__ == "__main__":
    dht = adafruit_dht.DHT22(D17, use_pulseio=False)

    try:
        temperature, humidity = dht.temperature, dht.humidity
        upload(temperature, DeviceType.TEMPERATURE.name)
        upload(humidity, DeviceType.HUMIDITY.name)
        print(f"Temperature: {temperature}C, humidity: {humidity}%")
    except RuntimeError as error:
        handle_error(error.args[0])
    except Exception as error:
        handle_error(error.args[0])
        dht.exit()
