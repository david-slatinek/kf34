import requests
from os import environ
from kf34_types import DeviceType
from kf34_error_handling import handle_error
import csv
from datetime import datetime


def upload(device_type: DeviceType, value: float, path: str = '../values.csv', mode: str = 'a'):
    url = ''
    query = """
                mutation AddData($value: Float!, $device_type: DeviceType!) {
                    addData(value: $value, device_type: $device_type) {
                        success
                        error
                    }
                }
            """

    variables = {'value': value, 'device_type': str(device_type)}

    r = requests.post(url=url, json={'query': query, 'variables': variables}, headers={'X-API-Key': environ.get('KEY')})
    if r.status_code == 200:
        data = r.json()
        if not data['data']['addData']['success']:
            handle_error(data['data']['addData']['error'])
            _write(device_type, value, path, mode)
    else:
        handle_error(str(r.status_code) + '-' + str(device_type))
        _write(device_type, value, path, mode)


def _write(device_type: DeviceType, value: float, path: str = '../values.csv', mode: str = 'a'):
    with open(path, mode) as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([datetime.now().strftime('%d.%m.%Y %H:%M:%S'), device_type, value])
