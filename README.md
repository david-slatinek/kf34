![Logo project](/images/logo.png)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [About](#about)
- [Raspberry Pi](#raspberry-pi)

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

Raspberry Pi is responsible to get data from the DHT22 sensor (temperature, humidity) every 15 minutes - by using **cron**. It also gets data from Arduino, which gets air pressure from the BMP280 sensor. After that, it uploads data to the API. In case of errors, the LED and buzzer are turned on. In addition to that, Raspberry Pi also sends an email, and thus notifying the system admin about the occurred error with the following syntax:
```
Sensor: DHT22
Error: <error>
Date: <date of error>
```

Sensor schematic:
![Raspberry Pi sensor wiring](/images/pi-wiring.png)