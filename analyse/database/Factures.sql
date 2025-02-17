-- calcluate  all users facture--
CREATE PROCEDURE CalculateUserFacture() BEGIN
SELECT U.id_user,
    U.username,
    COUNT(F.id_facture_items) AS total_products_purchased,
    SUM(F.quantity) AS total_quantity_purchased,
    SUM(F.total_price) AS total_facture
FROM Users U
    JOIN Orders O ON U.id_user = O.id_user
    JOIN Factures F ON O.id_order = F.id_order
    JOIN Facture_items FI ON F.id_facture = FI.id_facture
GROUP BY U.id_user,
    U.username;
END $$ DELIMITER;