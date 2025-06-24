CREATE DEFINER=`conor`@`localhost` TRIGGER actualizarSaldoDespuesPago
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
  UPDATE Clientes
  SET saldo_pendiente_total = saldo_pendiente_total - NEW.monto_pagado
  WHERE id_cliente = NEW.id_cliente;
END
