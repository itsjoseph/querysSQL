CREATE TRIGGER actualizarSaldoDespuesPago
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
  DECLARE saldo_actual DECIMAL(10,2);

  -- Obtener el saldo pendiente actual del cliente
  SELECT saldo_pendiente_total INTO saldo_actual
  FROM Clientes
  WHERE id_cliente = NEW.id_cliente;

  -- Solo actualizar si el saldo es mayor que 0
  IF saldo_actual > 0 THEN
    UPDATE Clientes
    SET saldo_pendiente_total = saldo_pendiente_total - NEW.monto_pagado
    WHERE id_cliente = NEW.id_cliente;
  END IF;
end