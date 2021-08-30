from models import Data, Device
from __init__ import Session
from datetime import date


def resolve_get_by_type(obj, info, device_type):
    try:
        device = [device.to_dict() for device in Device.query.filter_by(device_type=device_type)]
        payload = {
            "success": True,
            "data": [data.to_dict() for data in Data.query.filter_by(fk_device=device[0]["id_device"]).all()]
        }
    except Exception as error:
        payload = {
            "success": False,
            "error": str(error)
        }
    return payload


def to_dict(r):
    return {
        "id_data": r["id_data"],
        "capture": r["capture"],
        "value": r["value"],
        "device_type": r["device_type"],
    }


def data_retrieve(obj, info, query, params=None):
    try:
        with Session() as session:
            result = session.execute(query, params)
            session.commit()
            payload = {
                "success": True,
                "data": [to_dict(r) for r in result]
            }
    except Exception as error:
        payload = {
            "success": False,
            "error": str(error)
        }
    return payload


def resolve_get_max(obj, info):
    return data_retrieve(obj, info, """
            SELECT data.id_data, data.capture, data.value, t.device_type
            FROM data,
                (SELECT MAX(data.value) AS max, device.device_type
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                GROUP BY device.device_type) t
            WHERE data.value = t.max
            ORDER BY t.device_type;
            """)


def resolve_get_min(obj, info):
    return data_retrieve(obj, info, """
            SELECT data.id_data, data.capture, data.value, t.device_type
            FROM data,
                (SELECT MIN(data.value) AS min, device.device_type
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                GROUP BY device.device_type) t
            WHERE data.value = t.min
            ORDER BY t.device_type;
            """)


def resolve_get_today(obj, info, device):
    return data_retrieve(obj, info, """
            SELECT data.id_data, data.capture, data.value, device.device_type
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE CAST(capture AS DATE) = :today
            AND device.device_type = :device;
            """, {'today': str(date.today()), 'device': device.lower()})
