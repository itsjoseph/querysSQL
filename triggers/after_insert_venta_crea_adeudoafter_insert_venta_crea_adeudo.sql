CREATE TRIGGER after_insert_venta_crea_adeudo
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    DECLARE nuevo_id_adeudo VARCHAR(50);
    DECLARE fecha_venc DATE;
    SET nuevo_id_adeudo = CONCAT('LCDEU-', UUID());
    SET fecha_venc = DATE_ADD(NEW.fecha_venta, INTERVAL 30 DAY);
    
    INSERT INTO Adeudos (
        id_adeudo,
        id_venta_origen,
        id_cliente,
        monto_inicial,
        saldo_pendiente,
        fecha_origen,
        fecha_vencimiento,
        estado_adeudo,
        notas
    ) VALUES (
        nuevo_id_adeudo,
        NEW.id_venta,
        NEW.id_cliente,
        NEW.monto_total,
        NEW.monto_total,
        NEW.fecha_venta,
        fecha_venc,
        'Pendiente',
        NEW.notas
    );
END