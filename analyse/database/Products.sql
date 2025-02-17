-- ===========================
-- Product Procedures
-- ===========================
-- Add Product
CREATE PROCEDURE AddProduct(
    IN p_name VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_price DECIMAL(10, 2),
    IN p_stock INT,
    IN p_img_product VARCHAR(255),
    IN p_id_categorie INT
) BEGIN IF (
    SELECT COUNT(*)
    FROM Categories
    WHERE id_categorie = p_id_categorie
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Category does not exist';
END IF;
IF (
    SELECT COUNT(*)
    FROM Products
    WHERE name = p_name
        AND id_categorie = p_id_categorie
) > 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Product already exists in this category';
END IF;
INSERT INTO Products (
        name,
        description,
        price,
        stock,
        img_product,
        id_categorie
    )
VALUES (
        p_name,
        p_description,
        p_price,
        p_stock,
        p_img_product,
        p_id_categorie
    );
SELECT LAST_INSERT_ID() AS NewProductID;
END;
-- Update Product
CREATE PROCEDURE UpdateProduct(
    IN p_id_product INT,
    IN p_name VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_price DECIMAL(10, 2),
    IN p_stock INT,
    IN p_img_product VARCHAR(255),
    IN p_id_categorie INT
) BEGIN IF (
    SELECT COUNT(*)
    FROM Products
    WHERE id_product = p_id_product
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Product does not exist';
END IF;
IF (
    SELECT COUNT(*)
    FROM Categories
    WHERE id_categorie = p_id_categorie
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Category does not exist';
END IF;
IF (
    SELECT COUNT(*)
    FROM Products
    WHERE name = p_name
        AND id_categorie = p_id_categorie
        AND id_product != p_id_product
) > 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Another product with the same name exists in this category';
END IF;
UPDATE Products
SET name = p_name,
    description = p_description,
    price = p_price,
    stock = p_stock,
    img_product = p_img_product,
    id_categorie = p_id_categorie
WHERE id_product = p_id_product;
END;
-- Delete Product
CREATE PROCEDURE DeleteProduct(IN p_id_product INT) BEGIN IF (
    SELECT COUNT(*)
    FROM Products
    WHERE id_product = p_id_product
) = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Product does not exist';
END IF;
IF (
    SELECT COUNT(*)
    FROM Facture_items
    WHERE id_product = p_id_product
) > 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot delete product, it exists in invoices';
END IF;
IF (
    SELECT COUNT(*)
    FROM Cart_items
    WHERE id_product = p_id_product
) > 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot delete product, it exists in cart';
END IF;
DELETE FROM Products
WHERE id_product = p_id_product;
END;
-- After Product Insert Trigger
CREATE TRIGGER AfterProductInsert
AFTER
INSERT ON Products FOR EACH ROW BEGIN
UPDATE Products
SET created_date = CURRENT_TIMESTAMP
WHERE id_product = NEW.id_product;
END;
-- After Product Update Trigger
CREATE TRIGGER AfterProductUpdate
AFTER
UPDATE ON Products FOR EACH ROW BEGIN
UPDATE Products
SET updated_date = CURRENT_TIMESTAMP
WHERE id_product = NEW.id_product;
END;