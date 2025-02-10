CREATE TABLE Users (
    id_user INT AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_user)
);
CREATE TABLE Categories (
    id_categorie INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    PRIMARY KEY(id_categorie)
);
CREATE TABLE Orders (
    id_order INT AUTO_INCREMENT,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    id_user INT NOT NULL,
    PRIMARY KEY(id_order),
    FOREIGN KEY(id_user) REFERENCES Users(id_user)
);
CREATE TABLE Products (
    id_product INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    img_product VARCHAR(255) NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_categorie INT NOT NULL,
    PRIMARY KEY(id_product),
    FOREIGN KEY(id_categorie) REFERENCES Categories(id_categorie)
);
CREATE TABLE Payments (
    id_payment INT AUTO_INCREMENT,
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    id_order INT NOT NULL UNIQUE,
    PRIMARY KEY(id_payment),
    FOREIGN KEY(id_order) REFERENCES Orders(id_order)
);
CREATE TABLE Cart_items (
    id_item INT AUTO_INCREMENT,
    quantity INT NOT NULL,
    id_product INT NOT NULL,
    id_order INT NOT NULL,
    PRIMARY KEY(id_item),
    FOREIGN KEY(id_product) REFERENCES Products(id_product),
    FOREIGN KEY(id_order) REFERENCES Orders(id_order)
);
CREATE TABLE Factures (
    id_facture INT AUTO_INCREMENT,
    facture_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    id_user INT NOT NULL,
    id_order INT NOT NULL UNIQUE,
    PRIMARY KEY(id_facture),
    FOREIGN KEY(id_user) REFERENCES Users(id_user),
    FOREIGN KEY(id_order) REFERENCES Orders(id_order)
);
CREATE TABLE Facture_items (
    id_facture_items INT AUTO_INCREMENT,
    id_product INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    id_facture INT NOT NULL,
    PRIMARY KEY(id_facture_items),
    FOREIGN KEY(id_facture) REFERENCES Factures(id_facture),
    FOREIGN KEY(id_product) REFERENCES Products(id_product)
);