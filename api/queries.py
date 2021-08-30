from models import Data, Device
from __init__ import Session


def resolve_get_by_type(obj, info, device_type):
    try:
        device = [device.to_dict() for device in Device.query.filter_by(device_type=device_type)]

        data = [data.to_dict() for data in Data.query.filter_by(fk_device=device[0]["id_device"]).all()]
        payload = {
            "success": True,
            "data": data
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


def resolve_get_max(obj, info):
    try:
        with Session() as session:
            result = session.execute("""
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
            session.commit()

            data = [to_dict(r) for r in result]

            payload = {
                "success": True,
                "data": data
            }
    except Exception as error:
        payload = {
            "success": False,
            "error": str(error)
        }
    return payload
