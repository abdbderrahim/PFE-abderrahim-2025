-- ===========================
-- Payment Procedures
-- ===========================
-- Add Payment
CREATE PROCEDURE AddPayment(
    IN p_payment_method VARCHAR(50),
    IN p_amount DECIMAL(10, 2),
    IN p_id_order INT
) BEGIN IF (
    SELECT COUNT(*)
    FROM Orders
    WHERE id_order = p_id_order
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Order does not exist';
END IF;
IF (
    SELECT total_price
    FROM Orders
    WHERE id_order = p_id_order
) != p_amount THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Payment amount does not match order total';
END IF;
INSERT INTO Payments(payment_method, payment_date, amount, id_order)
VALUES (
        p_payment_method,
        CURRENT_TIMESTAMP,
        p_amount,
        p_id_order
    );
END;