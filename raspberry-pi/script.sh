#!/bin/bash

cd /home/pi/Documents/kf34/temperature-humidity || exit
./temperature_humidity.py

cd ../pressure/
./pressure.py

cd ../
./upload.py

rm results.csv
