![Logo project](/images/logo.png)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [About](#about)
- [Raspberry Pi](#raspberry-pi)
- [Arduino](#arduino)
- [Database](#database)

# About
A smart home system with Raspberry Pi, Arduino, PostgreSQL, Docker, Flask, GraphQL, and Flutter.

The project consists of 4 main components:
- Capturing data from sensors using Raspberry Pi and Arduino
- Database for data storage
- API for storing and retrieving data
- Mobile app for displaying values 

Project infrastructure:
![Project infrastructure](/images/project-infrastructure.png)

# Raspberry Pi
<div align="center">
  <img alt="Raspberry Pi" src="https://img.shields.io/badge/Raspberry%20Pi-A22846?style=for-the-badge&logo=Raspberry%20Pi&logoColor=white"/>
  <img alt="Python" src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
</div>

Raspberry Pi is responsible to get data from the DHT22 sensor (temperature, humidity) every 15 minutes - by using **cron**. It also gets data from Arduino. After that, it uploads data to the API. In case of errors, the LED and buzzer are turned on. In addition to that, Raspberry Pi also sends an email, and thus notifying the system admin about the occurred error with the following syntax:
```
Sensor: DHT22
Error: <error>
Date: <date of error>
```

Sensor schematic:
![Raspberry Pi sensor wiring](/images/pi-wiring.png)

# Arduino
<div align="center">
  <img alt="Arduino" src="https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=Arduino&logoColor=white"/>
</div>

When Arduino receives a request from the Raspberry Pi, it replies with an air pressure value, which he gets from the BMP280 sensor. 

Sensor schematic:
![Arduino sensor wiring](/images/arduino-wiring.png)

# Database
<div align="center">
  <img alt="PostgreSQL" src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img alt="diagrams.net" src="https://img.shields.io/badge/diagrams.net-F08705?style=for-the-badge&logo=diagrams.net&logoColor=white"/>
</div>

For the relational database management system, we choose Postgresql. In the database, we are storing information about the device and data capture.

ER diagram can be seen from the following image:
<div align="center">
  <img alt="ER diagram" src="images/er.png"/>
</div>
