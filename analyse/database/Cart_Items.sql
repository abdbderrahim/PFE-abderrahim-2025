-- ===========================
-- Cart Procedures
-- ===========================
-- Add Cart Item
CREATE PROCEDURE AddCartItem(
    IN p_quantity INT,
    IN p_id_product INT,
    IN p_id_order INT
) BEGIN -- Check if product exists
IF (
    SELECT COUNT(*)
    FROM Products
    WHERE id_product = p_id_product
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Product does not exist';
END IF;
-- Check if sufficient stock
IF (
    SELECT stock
    FROM Products
    WHERE id_product = p_id_product
) < p_quantity THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Insufficient stock';
END IF;
-- Add item to cart
INSERT INTO Cart_items(quantity, id_product, id_order)
VALUES (p_quantity, p_id_product, p_id_order);
-- Update stock after addition
UPDATE Products
SET stock = stock - p_quantity
WHERE id_product = p_id_product;
END;
-- Update Cart Item
CREATE PROCEDURE UpdateCartItem(
    IN p_id_item INT,
    IN p_new_quantity INT
) BEGIN -- Get old quantity
DECLARE old_quantity INT;
SELECT quantity INTO old_quantity
FROM Cart_items
WHERE id_item = p_id_item;
-- Check if item exists
IF old_quantity IS NULL THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cart item not found';
END IF;
-- Check if sufficient stock
IF (
    SELECT stock + old_quantity
    FROM Products
    WHERE id_product = (
            SELECT id_product
            FROM Cart_items
            WHERE id_item = p_id_item
        )
) < p_new_quantity THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Insufficient stock';
END IF;
-- Update quantity in cart
UPDATE Cart_items
SET quantity = p_new_quantity
WHERE id_item = p_id_item;
-- Update stock
UPDATE Products
SET stock = stock - (p_new_quantity - old_quantity)
WHERE id_product = (
        SELECT id_product
        FROM Cart_items
        WHERE id_item = p_id_item
    );
END;
-- Delete Cart Item
CREATE PROCEDURE DeleteCartItem(IN p_id_item INT) BEGIN -- Get item details
DECLARE item_quantity INT;
DECLARE item_product INT;
SELECT quantity,
    id_product INTO item_quantity,
    item_product
FROM Cart_items
WHERE id_item = p_id_item;
-- Check if item exists
IF item_quantity IS NULL THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cart item not found';
END IF;
-- Delete item from cart
DELETE FROM Cart_items
WHERE id_item = p_id_item;
-- Update stock after deletion
UPDATE Products
SET stock = stock + item_quantity
WHERE id_product = item_product;
END;