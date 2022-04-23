import logging
import subprocess
from datetime import datetime
from kf34_types import DeviceType
import csv

logging.basicConfig(level=logging.ERROR, filename='errors.log', filemode='a', format='%(asctime)s---%(message)s',
                    datefmt='%d.%m.%Y %H:%M:%S')

_PATH = "/home/pi/.local/lib/python3.7/site-packages/"

def handle_error(error):
    logging.error(error)
    subprocess.Popen([_PATH + "led.py", "-e"])
    subprocess.Popen([_PATH + "email.sh", error])


def write_csv(device_type: DeviceType, value: float, path: str = '../values.csv', mode: str = 'a'):
    with open(path, mode) as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([datetime.now().strftime('%d.%m.%Y %H:%M:%S'), device_type, value])
