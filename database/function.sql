CREATE FUNCTION add_new_data(value DECIMAL(6, 2), d_type VARCHAR(50))
RETURNS BOOLEAN AS $$ 
DECLARE id_fk INT;

BEGIN
    SELECT id_device INTO id_fk
    FROM device
    WHERE device_type = d_type;
    
    IF FOUND THEN
        INSERT INTO data(value, fk_device)
        VALUES (value, id_fk);
        RETURN TRUE;
    END IF;
RETURN FALSE;

END;

$$ LANGUAGE plpgsql;
