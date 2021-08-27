from models import Data, db

if __name__ == "__main__":
    new_data = Data(value=25.4, fk_device=1)
    db.session.add(new_data)
    db.session.commit()

    # new_device = Device("new device")
    # db.session.add(new_device)
    # db.session.commit()
