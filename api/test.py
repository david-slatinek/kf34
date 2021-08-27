from models import Data, db, Device
from queries import resolve_getByType

if __name__ == "__main__":
    # new_data = Data(value=25.4, fk_device=1)
    # db.session.add(new_data)
    # db.session.commit()

    # print(resolve_getByType(None, None, "temperature"))

    # data = Data(-555, 2)
    # db.session.add(data)
    # db.session.commit()

    # q = db.session.query(Data).join(Device).all()
    # print(q)
    q = db.session.query(
        Data.id_data,
        Data.capture,
        Data.value,
        Device.id_device,
        Device.device_type
    ).join(Device).all()
    print(q[0])

    # new_device = Device("new device")
    # db.session.add(new_device)
    # db.session.commit()
