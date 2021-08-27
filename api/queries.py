from models import Data, Device


def resolve_getByType(obj, info, device_type):
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
            "errors": [str(error)]
        }
    return payload
