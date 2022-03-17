#!/usr/bin/env python3

from enum import Enum
import requests
import csv
import logging
from os import environ

logging.basicConfig(level=logging.ERROR, filename="errors.log", filemode="a", format="%(asctime)s---%(message)s",
                    datefmt="%d.%m.%Y %H:%M:%S")


def upload(device_type: str, value: float):
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


def read():
    with open('results.csv', 'r') as f:
        reader = csv.reader(f)

        for row in reader:
            yield row


if __name__ == '__main__':
    for row in read():
        upload(row[0], float(row[1]))
