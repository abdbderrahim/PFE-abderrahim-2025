-- ===========================
-- Category Procedures
-- ===========================
-- Update Category
DELIMITER $$ CREATE PROCEDURE UpdateCategory(
    IN p_id_categorie INT,
    IN p_name VARCHAR(100),
    IN p_description VARCHAR(255)
) BEGIN IF EXISTS (
    SELECT 1
    FROM Categories
    WHERE name = p_name
        AND id_categorie != p_id_categorie
) THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Category already exists';
ELSE
UPDATE Categories
SET name = p_name,
    description = p_description
WHERE id_categorie = p_id_categorie;
END IF;
END $$ DELIMITER;
-- Delete Category
DELIMITER $$ CREATE PROCEDURE DeleteCategory(IN p_id_categorie INT) BEGIN
DELETE FROM Categories
WHERE id_categorie = p_id_categorie;
END $$ DELIMITER;
-- Get All Categories
DELIMITER $$ CREATE PROCEDURE GetAllCategories() BEGIN
SELECT *
FROM Categories;
END $$ DELIMITER;
-- Get Category By ID
DELIMITER $$ CREATE PROCEDURE GetCategoryById(IN p_id_categorie INT) BEGIN
SELECT *
FROM Categories
WHERE id_categorie = p_id_categorie;
END $$ DELIMITER;
-- After Category Update Trigger
CREATE TRIGGER after_category_update
AFTER
UPDATE ON Categories FOR EACH ROW BEGIN
UPDATE Products
SET updated_date = CURRENT_TIMESTAMP
WHERE id_categorie = NEW.id_categorie;
END;