#!/usr/bin/env python3

import logging
import subprocess
import time
from enum import Enum
from os import environ

import adafruit_dht
import requests
import serial
from board import D17

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")


class DeviceType(Enum):
    TEMPERATURE = 0
    HUMIDITY = 1
    PRESSURE = 2


def handle_error(err):
    logging.error(err)
    subprocess.Popen(["./led_buzzer.py", "-e"])
    subprocess.Popen(["./email.sh", "DHT22", err])


def upload(value, device_type):
    url = ''
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
    try:
        ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
        time.sleep(2)
        ser.flush()
        
        dht = adafruit_dht.DHT22(D17, use_pulseio=False)
        
        temperature, humidity = dht.temperature, dht.humidity
        upload(temperature, DeviceType.TEMPERATURE.name)
        upload(humidity, DeviceType.HUMIDITY.name)
        
        ser.write(b"get\n")
        pressure = ser.readline().decode("utf-8").rstrip()
        upload(pressure, DeviceType.PRESSURE.name)

        print(f"Temperature: {temperature}C, humidity: {humidity}%")
        print(f"Pressure: {pressure}hPa")
    except RuntimeError as error:
        handle_error(error.args[0])
        dht.exit()
        ser.close()
    except Exception as error:
        handle_error(error.args[0])
        dht.exit()
        ser.close()
