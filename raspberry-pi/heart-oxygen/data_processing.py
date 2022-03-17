#!/usr/bin/env python3

import csv
import statistics
from enum import Enum


class DeviceType(Enum):
    HEART_RATE = 0
    OXYGEN_SATURATION = 1


def write(device_type: DeviceType, value: float):
    with open('../results.csv', 'a') as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow([device_type.name, value])


def read(filename):
    with open(filename, 'r') as f:
        reader = csv.reader(f)

        for row in reader:
            yield row


if __name__ == '__main__':
    bpm = [int(x[0]) for x in read('heart.csv')]
    spo = [float(x[0]) for x in read('spo2.csv')]

    write(DeviceType.HEART_RATE, round(statistics.mean(bpm), 2))
    write(DeviceType.OXYGEN_SATURATION, round(statistics.mean(spo), 2))
