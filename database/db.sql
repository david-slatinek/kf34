CREATE TABLE IF NOT EXISTS device (
    id_device INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    device_type VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS data (
    id_data INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    capture TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    value DECIMAL(5, 2) NOT NULL,
    fk_device INT NOT NULL
);

ALTER TABLE
    data
ADD
    CONSTRAINT fkc_device_data FOREIGN KEY (fk_device) REFERENCES device(id_device) ON UPDATE CASCADE ON DELETE RESTRICT;

SET
    TIMEZONE TO 'Europe/Ljubljana';

INSERT INTO
    device (device_type)
VALUES
    ('temperature'),
    ('humidity');