from __init__ import Session


def resolve_add_data(obj, info, value, device_type):
    try:
        with Session() as session:
            result = session.execute("SELECT add_new_data(:value, :device_type)",
                                     {'value': value, 'device_type': device_type.lower()})
            session.commit()
            payload = {
                "success": result.first()[0]
            }
    except Exception as error:
        payload = {
            "success": False,
            "error": str(error)
        }
    return payload
