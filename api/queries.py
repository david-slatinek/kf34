from models import Data, Device
from __init__ import Session


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
        "value": r["value"],
        "device_type": r["device_type"],
        "capture": r["capture"]
    }


def resolve_get_(obj, info, query):
    try:
        with Session() as session:
            result = session.execute(query)
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
    return resolve_get_(obj, info, """
            SELECT data.value, t.device_type, data.capture
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
    return resolve_get_(obj, info, """
            SELECT data.value, t.device_type, data.capture
            FROM data,
                (SELECT MIN(data.value) AS min, device.device_type
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                GROUP BY device.device_type) t
            WHERE data.value = t.min
            ORDER BY t.device_type;
            """)
