from sqlalchemy import func
from __init__ import db


class Device(db.Model):
    __tablename__ = 'device'
    id_device = db.Column(db.Integer, primary_key=True)
    device_type = db.Column(db.VARCHAR(length=50), nullable=False, unique=True)
    data_rel = db.relationship("Data", cascade="all, delete")

    def __init__(self, device_type):
        self.device_type = device_type

    def __str__(self):
        return f"id: {self.id_device}, type: {self.device_type}"

    def to_dict(self):
        return {
            "id_device": self.id_device,
            "device_type": self.device_type
        }


class Data(db.Model):
    __tablename__ = 'data'
    id_data = db.Column(db.Integer, primary_key=True)
    capture = db.Column(db.TIMESTAMP(timezone=True), nullable=False, server_default=func.now())
    value = db.Column(db.Float, nullable=False)
    fk_device = db.Column(db.Integer, db.ForeignKey("device.id_device", onupdate="CASCADE", ondelete="RESTRICT"),
                          nullable=False)

    def __init__(self, value, fk_device):
        self.value = value
        self.fk_device = fk_device

    def __str__(self):
        return f"id: {self.id_data}, capture: {self.capture}, value: {self.value}, fk: {self.fk_device}"

    def to_dict(self):
        return {
            "id": self.id_data,
            "capture": self.capture,
            "value": self.value,
            "fk": self.fk_device
        }
