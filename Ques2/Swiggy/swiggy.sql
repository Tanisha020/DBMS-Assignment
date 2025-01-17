-- Drop database if it exists
DROP DATABASE IF EXISTS Swiggy;
CREATE DATABASE Swiggy;
USE Swiggy;

-- Table: Customer
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    WalletBalance DECIMAL(10, 2) DEFAULT 0.00,
    IsPremium BOOLEAN DEFAULT FALSE,
    ReferralCode VARCHAR(20) UNIQUE
);

-- Table: Restaurant_Owner
CREATE TABLE Restaurant_Owner (
    OwnerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);

-- Table: Restaurant
CREATE TABLE Restaurant (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    OwnerID INT NOT NULL,
    Address TEXT NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(255) UNIQUE,
    FOREIGN KEY (OwnerID) REFERENCES Restaurant_Owner(OwnerID)
);

-- Table: Staff
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Role ENUM('Chef', 'Waiter', 'Manager') NOT NULL,
    ContactNumber VARCHAR(15),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Table: Delivery_Partner
CREATE TABLE Delivery_Partner (
    PartnerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    VehicleType ENUM('Bike', 'Scooter', 'Car') NOT NULL,
    Rating DECIMAL(3, 2) DEFAULT 5.00
);

-- Table: Menu
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Category VARCHAR(50) NOT NULL,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Table: Menu_Item
CREATE TABLE Menu_Item (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    MenuID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

-- Table: Order
CREATE TABLE `Order` (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    DeliveryPartnerID INT DEFAULT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Placed', 'Cancelled', 'Delivered') DEFAULT 'Placed',
    IsReorder BOOLEAN DEFAULT FALSE,
    DeliveryAddress TEXT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (DeliveryPartnerID) REFERENCES Delivery_Partner(PartnerID)
);

-- Table: Payment
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentMode ENUM('Card', 'UPI', 'Cash') NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);

-- Table: Complaint
CREATE TABLE Complaint (
    ComplaintID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    Description TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Table: Promotion
CREATE TABLE Promotion (
    PromotionID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    DiscountPercentage DECIMAL(5, 2),
    ValidUntil DATE NOT NULL
);

-- Table: Favorite_Restaurant
CREATE TABLE Favorite_Restaurant (
    FavoriteID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Table: Gift_Card
CREATE TABLE Gift_Card (
    CardID INT AUTO_INCREMENT PRIMARY KEY,
    Code VARCHAR(20) UNIQUE NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL,
    ExpiryDate DATE NOT NULL,
    IssuedToCustomerID INT DEFAULT NULL,
    FOREIGN KEY (IssuedToCustomerID) REFERENCES Customer(CustomerID)
);

-- Table: Advance_Order
CREATE TABLE Advance_Order (
    AdvanceOrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    ScheduledTime DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Scheduled', 'Cancelled', 'Delivered') DEFAULT 'Scheduled',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Table: Dining_Reservation
CREATE TABLE Dining_Reservation (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    GuestsCount INT NOT NULL,
    ReservationTime DATETIME NOT NULL,
    Status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Table: Friend_Recommendation
CREATE TABLE Friend_Recommendation (
    RecommendationID INT AUTO_INCREMENT PRIMARY KEY,
    ReferrerID INT NOT NULL,
    ReferredFriendID INT NOT NULL,
    RestaurantID INT NOT NULL,
    Comments TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ReferrerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ReferredFriendID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Insert mock data for Customer
INSERT INTO Customer (Name, Email, PhoneNumber, WalletBalance, IsPremium, ReferralCode) VALUES
('Ravi Kumar', 'ravi.kumar@example.com', '9876543210', 100.00, TRUE, 'RAVI123'),
('Priya Sharma', 'priya.sharma@example.com', '9123456789', 50.00, FALSE, 'PRIYA456'),
('Amit Singh', 'amit.singh@example.com', '9212345678', 200.00, TRUE, 'AMIT789'),
('Anjali Gupta', 'anjali.gupta@example.com', '9376543210', 0.00, FALSE, 'ANJALI321'),
('Vikram Reddy', 'vikram.reddy@example.com', '9432156789', 75.00, TRUE, 'VIKRAM654'),
('Sita Patel', 'sita.patel@example.com', '9512345678', 150.00, TRUE, 'SITA987'),
('Manoj Verma', 'manoj.verma@example.com', '9632145789', 30.00, FALSE, 'MANOJ432');

-- Insert mock data for Restaurant_Owner
INSERT INTO Restaurant_Owner (Name, Email, PhoneNumber) VALUES
('Asha Deshmukh', 'asha.deshmukh@example.com', '9901234567'),
('Rajesh Bansal', 'rajesh.bansal@example.com', '9912345678'),
('Suresh Nair', 'suresh.nair@example.com', '9923456789');

-- Insert mock data for Restaurant
INSERT INTO Restaurant (Name, OwnerID, Address, PhoneNumber, Email) VALUES
('Biryani Gully', 1, '123 MG Road, Bangalore, India', '9956781234', 'biryani.gully@example.com'),
('Dosa Delight', 2, '456 Jayanagar, Bangalore, India', '9967892345', 'dosa.delight@example.com'),
('Curry Tales', 3, '789 Whitefield, Bangalore, India', '9978903456', 'curry.tales@example.com');

-- Insert mock data for Staff
INSERT INTO Staff (RestaurantID, Name, Role, ContactNumber) VALUES
(1, 'Arjun Patel', 'Manager', '9988776655'),
(1, 'Karan Iyer', 'Chef', '9876543210'),
(2, 'Neha Kapoor', 'Waiter', '9865432109'),
(2, 'Ravi Rao', 'Chef', '9754321098'),
(3, 'Rajeev Kumar', 'Manager', '9543210987');

-- Insert mock data for Delivery_Partner
INSERT INTO Delivery_Partner (Name, PhoneNumber, VehicleType, Rating) VALUES
('Vijay Kumar', '9988771122', 'Bike', 4.5),
('Deepika Singh', '9876543210', 'Scooter', 4.8),
('Suresh Gupta', '9798987878', 'Car', 4.7);

-- Insert mock data for Menu
INSERT INTO Menu (RestaurantID, Category) VALUES
(1, 'Non-Veg'),
(1, 'Veg'),
(2, 'South Indian'),
(2, 'Beverages'),
(3, 'North Indian');

-- Insert mock data for Menu_Item
INSERT INTO Menu_Item (MenuID, Name, Price, Availability) VALUES
(1, 'Chicken Biryani', 200.00, TRUE),
(1, 'Mutton Biryani', 250.00, TRUE),
(2, 'Veg Biryani', 180.00, TRUE),
(3, 'Masala Dosa', 50.00, TRUE),
(3, 'Sambar Vada', 60.00, TRUE),
(4, 'Filter Coffee', 30.00, TRUE),
(5, 'Butter Chicken', 300.00, TRUE),
(5, 'Paneer Tikka', 220.00, TRUE);

-- Insert mock data for Order
INSERT INTO `Order` (CustomerID, RestaurantID, DeliveryPartnerID, TotalAmount, Status, IsReorder, DeliveryAddress) VALUES
(1, 1, 1, 350.00, 'Placed', FALSE, '123 MG Road, Bangalore, India'),
(2, 2, 2, 120.00, 'Delivered', TRUE, '456 Jayanagar, Bangalore, India'),
(3, 3, 3, 500.00, 'Placed', FALSE, '789 Whitefield, Bangalore, India');

-- Insert mock data for Payment
INSERT INTO Payment (OrderID, PaymentMode, Amount) VALUES
(1, 'Card', 350.00),
(2, 'Cash', 120.00),
(3, 'UPI', 500.00);

-- Insert mock data for Complaint
INSERT INTO Complaint (OrderID, CustomerID, Description) VALUES
(1, 1, 'The Biryani was too spicy for my taste'),
(3, 3, 'The curry was a bit too oily');

-- Insert mock data for Promotion
INSERT INTO Promotion (Title, Description, DiscountPercentage, ValidUntil) VALUES
('Diwali Special', 'Get 30% off on all orders this month', 30.00, '2025-01-31'),
('Weekend Deal', 'Get 15% off on South Indian food', 15.00, '2025-01-20');

-- Insert mock data for Favorite_Restaurant
INSERT INTO Favorite_Restaurant (CustomerID, RestaurantID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert mock data for Gift_Card
INSERT INTO Gift_Card (Code, Balance, ExpiryDate, IssuedToCustomerID) VALUES
('GIFT1234', 100.00, '2025-12-31', 1),
('GIFT5678', 50.00, '2025-06-30', 2);

-- Insert mock data for Advance_Order
INSERT INTO Advance_Order (CustomerID, RestaurantID, ScheduledTime, TotalAmount, Status) VALUES
(1, 1, '2025-01-20 18:00:00', 400.00, 'Scheduled'),
(2, 2, '2025-01-21 19:00:00', 200.00, 'Scheduled');

-- Insert mock data for Dining_Reservation
INSERT INTO Dining_Reservation (CustomerID, RestaurantID, GuestsCount, ReservationTime, Status) VALUES
(1, 1, 4, '2025-01-22 12:30:00', 'Pending'),
(2, 2, 2, '2025-01-23 13:00:00', 'Confirmed');

-- Insert mock data for Friend_Recommendation
INSERT INTO Friend_Recommendation (ReferrerID, ReferredFriendID, RestaurantID, Comments) VALUES
(1, 2, 1, 'I love their Biryani, you should try it!'),
(3, 4, 2, 'Best Dosas in town, don’t miss it!');
