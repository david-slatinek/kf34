![Logo project](/images/logo.png)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [About](#about)
- [Raspberry Pi](#raspberry-pi)
- [Arduino](#arduino)
- [Database](#database)
- [API](#api)

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

Raspberry Pi is responsible to get data from the DHT22 sensor (temperature, humidity) every 15 minutes - by using **cron**. It also gets data from Arduino. After that, it uploads data to the API by calling an appropriate mutation:
```
mutation AddData($value: Float!, $device_type: DeviceType!) {
    addData(value: $value, device_type: $device_type) {
        success
        error
    }
}
```

In case of errors, the LED and buzzer are turned on. In addition to that, Raspberry Pi also sends an email, and thus notifying the system admin about the occurred error with the following syntax:
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

# API
<div align="center">
  <img alt="Docker" src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white"/>
  <img alt="Shell Script" src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white"/>
  <img alt="Heroku" src="https://img.shields.io/badge/heroku-%23430098.svg?style=for-the-badge&logo=heroku&logoColor=white"/>
  <img alt="Bash" src="https://img.shields.io/badge/GNU%20Bash-4EAA25?style=for-the-badge&logo=GNU%20Bash&logoColor=white"/>
  <img alt="Python" src="https://img.shields.io/badge/Python-FFD43B?style=for-the-badge&logo=python&logoColor=darkgreen"/>
  <img alt="Flask" src="https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white"/>
 <img alt="JSON" src="https://img.shields.io/badge/JSON-000000?style=for-the-badge&logo=JSON&logoColor=white"/>
 <img alt="JSON" src="https://img.shields.io/badge/GraphQl-E10098?style=for-the-badge&logo=graphql&logoColor=white"/>
 <img alt="JSON" src="https://img.shields.io/badge/curl-073551?style=for-the-badge&logo=curl&logoColor=white"/>
 <img alt="Postman" src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=red"/>
</div>

The API was made with a python framework **flask** with Graphql and returns data in JSON format. The API is hosted on Heroku, and it's running inside a docker container. To make the API production-ready, we used the **gunicorn** server.

To prevent unauthorized access, we use API keys along with the HTTPS protocol - provided by Heroku.

Main route:
```python
@app.route("/graphql", methods=["POST"])
def graphql_server():
    if request.headers.get('X-API-Key') != app.config["KEY"]:
        return jsonify({'error': 'api key not given or invalid'}), 401

    data = request.get_json()
    success, result = graphql_sync(
        schema,
        data,
        context_value=request,
        debug=app.debug
    )
    return jsonify(result), 200 if success else 400
```