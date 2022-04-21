#!/usr/bin/env python3

from kf34_upload import DeviceType, upload
from kf34_error_handling import handle_error

import adafruit_dht
from board import D17


if __name__ == "__main__":
    try:
        dht = adafruit_dht.DHT22(D17, use_pulseio=False)
        upload(DeviceType.TEMPERATURE, dht.temperature)
        upload(DeviceType.HUMIDITY, dht.humidity)
    except RuntimeError as error:
        handle_error(error.args[0])
        dht.exit()
    except Exception as error:
        handle_error(error.args[0])
        dht.exit()
