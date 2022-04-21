#!/usr/bin/env python3

import statistics
from kf34_upload import DeviceType, upload


def read(filename):
    with open(filename, 'r') as f:
        reader = csv.reader(f)

        for row in reader:
            yield row


if __name__ == '__main__':
    bpm = [int(x[0]) for x in read('heart.csv')]
    spo = [float(x[0]) for x in read('spo2.csv')]

    upload(DeviceType.HEART_RATE, round(statistics.mean(bpm), 2))
    upload(DeviceType.OXYGEN_SATURATION, round(statistics.mean(spo), 2))
