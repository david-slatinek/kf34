import base64
import decimal
import io
from datetime import date, datetime

from matplotlib import pyplot as plt

from __init__ import Session
from models import Data


def to_dict(r):
    data = Data(r["value"], r["fk_device"])
    data.add_data(r["id_data"], r["capture"])
    return data.to_dict()


def data_retrieve(query, params=None):
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


def central_value_result(query, params):
    try:
        with Session() as session:
            result = session.execute(query, params)
            session.commit()

            if result.rowcount == 0:
                raise Exception("No rows")

            first_record = result.fetchone()

            if first_record is None:
                raise Exception("No rows")

            captured = [r["capture"] for r in result]
            captured.insert(0, first_record["capture"])

            payload = {
                "success": True,
                "data": first_record["value"],
                "captured": captured
            }
    except Exception as error:
        payload = {
            "success": False,
            "error": str(error)
        }
    return payload


def resolve_get_max(obj, info, device_type):
    return central_value_result("""
                SELECT data.*
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                WHERE device.device_type = :device_type
                AND data.value = (SELECT MAX(data.value)
                                FROM data
                                JOIN device
                                ON data.fk_device = device.id_device
                                WHERE device.device_type = :device_type
                                GROUP BY device.id_device)
                ORDER BY data.capture DESC;
            """"", {'device_type': device_type})


def resolve_get_min(obj, info, device_type):
    return central_value_result("""
                SELECT data.*
                FROM data
                JOIN device
                ON data.fk_device = device.id_device
                WHERE device.device_type = :device_type
                AND data.value = (SELECT MIN(data.value)
                                FROM data
                                JOIN device
                                ON data.fk_device = device.id_device
                                WHERE device.device_type = :device_type
                                GROUP BY device.id_device)
                ORDER BY data.capture DESC;
            """"", {'device_type': device_type})


def average_data_retrieve(query, params):
    try:
        with Session() as session:
            result = session.execute(query, params)
            session.commit()

            if result.rowcount == 0:
                raise Exception("No rows")

            data = result.fetchone()[0]

            if data is None:
                raise Exception("No rows")

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


def resolve_get_average(obj, info, device_type):
    return average_data_retrieve("""
            SELECT ROUND(AVG(data.value), 2)
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE device.device_type = :device_type
            GROUP BY device.id_device;
        """, {'device_type': device_type})


def resolve_get_today(obj, info, device_type):
    return data_retrieve("""
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE CAST(capture AS DATE) = :today
            AND device.device_type = :device_type
            ORDER BY data.capture DESC;
        """, {'today': str(date.today()), 'device_type': device_type})


def cm_to_inch(value):
    return value / 2.54


def get_today_graph(device_type, file_id):
    payload = resolve_get_today(None, None, device_type)
    if payload["success"]:
        data = payload["data"]
        captures, values = [], []
        for d in data:
            captures.append(d["capture"].strftime("%H:%M"))
            values.append(d["value"])

        captures.reverse()

        plt.figure(figsize=(cm_to_inch(65), cm_to_inch(10)))
        plt.plot(captures, values, marker='o')

        plt.title('Today\'s values')
        plt.xlabel('Capture time')
        plt.ylabel(device_type)
        plt.grid(True)
        plt.savefig(file_id + '.jpg')
        return {
            "success": True,
        }
    return {
        "success": False,
        "error": payload["error"]
    }


def resolve_get_latest(obj, info, device_type):
    return data_retrieve("""
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE data.capture =
                (SELECT MAX(capture) FROM data
                JOIN device
                ON data.fk_device = device.id_device
                WHERE device.device_type = :device_type)
            AND device.device_type = :device_type;
        """, {"device_type": device_type})


def valid_date(input_date):
    try:
        datetime.strptime(input_date, '%Y-%m-%d')
        return True
    except ValueError:
        return False


def resolve_get_between(obj, info, begin_date, end_date, device_type):
    if not valid_date(begin_date) or not valid_date(end_date):
        return {
            "success": False,
            "error": "invalid date format; should be YYYY-MM-DD"
        }

    return data_retrieve("""
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
            AND device.device_type = :device_type
            ORDER BY data.capture DESC;
        """, {"begin_date": begin_date, "end_date": end_date, "device_type": device_type})


def resolve_get_average_between(obj, info, begin_date, end_date, device_type):
    if not valid_date(begin_date) or not valid_date(end_date):
        return {
            "success": False,
            "error": "invalid date format; should be YYYY-MM-DD"
        }

    return average_data_retrieve("""
            SELECT ROUND(AVG(data.value), 2)
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
            AND device.device_type = :device_type;
        """, {"begin_date": begin_date, "end_date": end_date, "device_type": device_type})


def resolve_get_average_today(obj, info, device_type):
    return resolve_get_average_between(obj, info, str(date.today()), str(date.today()), device_type)


def resolve_get_max_between(obj, info, begin_date, end_date, device_type):
    if not valid_date(begin_date) or not valid_date(end_date):
        return {
            "success": False,
            "error": "invalid date format; should be YYYY-MM-DD"
        }

    return central_value_result("""
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE device.device_type = :device_type
            AND data.value = (SELECT MAX(data.value)
                                FROM data
                                JOIN device
                                ON data.fk_device = device.id_device
                                WHERE device.device_type = :device_type
                                AND CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
                                GROUP BY device.id_device)
            AND CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
            ORDER BY data.capture DESC;
       """, {"begin_date": begin_date, "end_date": end_date, "device_type": device_type})


def resolve_get_max_today(obj, info, device_type):
    return resolve_get_max_between(obj, info, str(date.today()), str(date.today()), device_type)


def resolve_get_min_between(obj, info, begin_date, end_date, device_type):
    if not valid_date(begin_date) or not valid_date(end_date):
        return {
            "success": False,
            "error": "invalid date format; should be YYYY-MM-DD"
        }

    return central_value_result("""
            SELECT data.*
            FROM data
            JOIN device
            ON data.fk_device = device.id_device
            WHERE device.device_type = :device_type
            AND data.value = (SELECT MIN(data.value)
                                FROM data
                                JOIN device
                                ON data.fk_device = device.id_device
                                WHERE device.device_type = :device_type
                                AND CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
                                GROUP BY device.id_device)
            AND CAST(data.capture AS DATE) BETWEEN :begin_date AND :end_date
            ORDER BY data.capture DESC;
       """, {"begin_date": begin_date, "end_date": end_date, "device_type": device_type})


def resolve_get_min_today(obj, info, device_type):
    return resolve_get_min_between(obj, info, str(date.today()), str(date.today()), device_type)
