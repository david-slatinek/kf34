from enum import Enum

class DeviceType(Enum):
    BODY_TEMPERATURE = 0
    HEART_RATE = 1
    OXYGEN_SATURATION = 2
    PRESSURE = 3
    TEMPERATURE = 4
    HUMIDITY = 5

    def __str__(self):
        return str(self.name)
