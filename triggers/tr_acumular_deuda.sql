CREATE TRIGGER tr_acumular_deuda
AFTER INSERT ON Adeudos
FOR EACH ROW
BEGIN
  UPDATE Clientes
  SET saldo_pendiente_total = saldo_pendiente_total + NEW.monto_inicial
  WHERE id_cliente = NEW.id_cliente;
END
