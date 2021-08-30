from models import Data, Device
from __init__ import Session
from datetime import date


def resolve_get_all(obj, info, device_type):
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
    data = Data(r["value"], r["fk_device"])
    data.add_data(r["id_data"], r["capture"])
    return data.to_dict()


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


def resolve_get_max(obj, info, device_type):
    return data_retrieve(obj, info, """
            SELECT data.*
            FROM data,
                (SELECT MAX(data.value) AS max, device.device_type
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                WHERE device.device_type = :device_type
                GROUP BY device.device_type) t
            WHERE data.value = t.max
            ORDER BY t.device_type;
            """, {'device_type': device_type.lower()})


def resolve_get_min(obj, info, device_type):
    return data_retrieve(obj, info, """
             SELECT data.*
            FROM data,
                (SELECT MIN(data.value) AS min, device.device_type
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                WHERE device.device_type = :device_type
                GROUP BY device.device_type) t
            WHERE data.value = t.min
            ORDER BY t.device_type;
            """, {'device_type': device_type.lower()})


def resolve_get_today(obj, info, device_type):
    return data_retrieve(obj, info, """
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE CAST(capture AS DATE) = :today
            AND device.device_type = :device_type;
            """, {'today': str(date.today()), 'device_type': device_type.lower()})
