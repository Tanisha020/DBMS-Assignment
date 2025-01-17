-- Create and Use Database
DROP DATABASE IF EXISTS redBus;
CREATE DATABASE redBus;
USE redBus;

-- 1. Agency Table
CREATE TABLE Agency (
    AgencyID INT NOT NULL AUTO_INCREMENT,
    AgencyName VARCHAR(255) NOT NULL,
    ContactPerson VARCHAR(100),
    ContactNumber VARCHAR(15),
    Email VARCHAR(255),
    Address VARCHAR(500),
    Rating FLOAT DEFAULT 0.0,
    PRIMARY KEY (AgencyID)
);

-- 2. Bus Table
CREATE TABLE Bus (
    BusNumber VARCHAR(20) NOT NULL,
    Capacity INT,
    Model VARCHAR(50),
    RegistrationNumber VARCHAR(20) UNIQUE,
    BusType ENUM('AC', 'Non-AC', 'Sleeper'),
    AgencyID INT,
    PRIMARY KEY (BusNumber),
    FOREIGN KEY (AgencyID) REFERENCES Agency(AgencyID)
);

-- 3. Passenger Table
CREATE TABLE Passenger (
    PassengerID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    DOB DATE,
    Gender ENUM('M', 'F', 'O'),
    PhoneNumber BIGINT UNIQUE,
    Email VARCHAR(255),
    PRIMARY KEY (PassengerID),
    CHECK (PhoneNumber BETWEEN 1000000000 AND 9999999999)
);

-- 4. Reservation Table
CREATE TABLE Reservation (
    ReservationID INT NOT NULL AUTO_INCREMENT,
    PassengerID INT,
    BusNumber VARCHAR(20),
    ReservationDate DATE,
    AmountPaid DECIMAL(10, 2),
    Status ENUM('Confirmed', 'Pending', 'Cancelled'),
    StartingPoint VARCHAR(255),
    Destination VARCHAR(255),
    PRIMARY KEY (ReservationID),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID),
    FOREIGN KEY (BusNumber) REFERENCES Bus(BusNumber)
);

-- 5. Conductor Table
CREATE TABLE Conductor (
    ConductorID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    ContactNumber VARCHAR(15),
    DOB DATE,
    PRIMARY KEY (ConductorID)
);

-- 6. Driver Table
CREATE TABLE Driver (
    DriverID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    ContactNumber VARCHAR(15),
    LicenseNumber VARCHAR(20) UNIQUE,
    JoiningDate DATE,
    DOB DATE,
    Status ENUM('Active', 'Inactive'),
    PRIMARY KEY (DriverID)
);

-- 7. Feedback Table
CREATE TABLE Feedbacks (
    FeedbackID INT NOT NULL AUTO_INCREMENT,
    ReservationID INT,
    PassengerID INT NOT NULL,
    AgencyID INT,
    Rating INT DEFAULT 1,
    Comment TEXT,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (FeedbackID),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    FOREIGN KEY (AgencyID) REFERENCES Agency(AgencyID)
);

-- 8. Payment Table
CREATE TABLE Payment (
    PaymentID INT NOT NULL AUTO_INCREMENT,
    ReservationID INT,
    PaymentDate DATE,
    AmountPaid DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    TransactionID VARCHAR(255),
    Status ENUM('Success', 'Pending', 'Failed'),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
);

-- 9. Seat Table
CREATE TABLE Seat (
    SeatID INT NOT NULL AUTO_INCREMENT,
    BusNumber VARCHAR(20),
    SeatNumber INT,
    Status ENUM('Available', 'Booked'),
    Type ENUM('Window', 'Aisle', 'Middle'),
    Price DECIMAL(10, 2),
    PRIMARY KEY (SeatID),
    FOREIGN KEY (BusNumber) REFERENCES Bus(BusNumber)
);

-- 10. ReservationSeat Table
CREATE TABLE ReservationSeat (
    ReservationID INT NOT NULL,
    SeatID INT NOT NULL,
    PRIMARY KEY (ReservationID, SeatID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);

-- 11. Route Table
CREATE TABLE Route (
    RouteID INT NOT NULL AUTO_INCREMENT,
    SourceLocation VARCHAR(255),
    Destination VARCHAR(255),
    BusNumber VARCHAR(20),
    DriverID INT,
    ConductorID INT,
    PRIMARY KEY (RouteID),
    FOREIGN KEY (BusNumber) REFERENCES Bus(BusNumber),
    FOREIGN KEY (DriverID) REFERENCES Driver(DriverID),
    FOREIGN KEY (ConductorID) REFERENCES Conductor(ConductorID)
);

-- 12. Schedule Table
CREATE TABLE Schedule (
    ScheduleID INT NOT NULL AUTO_INCREMENT,
    ScheduleName VARCHAR(255) NOT NULL,
    AgencyID INT,
    PRIMARY KEY (ScheduleID),
    FOREIGN KEY (AgencyID) REFERENCES Agency(AgencyID)
);

-- 13. RouteSchedule Table
CREATE TABLE RouteSchedule (
    RouteScheduleID INT NOT NULL AUTO_INCREMENT,
    RouteID INT,
    ScheduleID INT,
    DepartureTime TIME,
    ReachingTime TIME,
    DayOfOperation ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    PRIMARY KEY (RouteScheduleID),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID),
    FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID)
);

-- 14. Stop Table
CREATE TABLE Stop (
    StopID INT NOT NULL AUTO_INCREMENT,
    StopName VARCHAR(255) NOT NULL,
    PRIMARY KEY (StopID)
);

-- 15. RouteStop Table
CREATE TABLE RouteStop (
    RouteID INT NOT NULL,
    StopID INT NOT NULL,
    Ord INT NOT NULL,
    PRIMARY KEY (RouteID, StopID),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID),
    FOREIGN KEY (StopID) REFERENCES Stop(StopID)
);

-- Mock Data for Agency Table
-- Insert mock data into Agency Table
INSERT INTO Agency (AgencyName, ContactPerson, ContactNumber, Email, Address, Rating)
VALUES 
('Kochi Travels', 'Rajesh Nair', '9876543210', 'rajesh@kochitravels.com', 'Kochi, Kerala, India', 4.5),
('Bangalore Bus Services', 'Sunita Rao', '9887654321', 'sunita@bangalorebus.com', 'Bangalore, Karnataka, India', 4.2),
('Delhi Roadways', 'Amit Sharma', '9912345678', 'amit@delhird.com', 'Delhi, India', 3.9),
('Mumbai Express', 'Priya Desai', '9834567890', 'priya@mumbaiexpress.com', 'Mumbai, Maharashtra, India', 4.7),
('Chennai Travels', 'Ravi Kumar', '9445678901', 'ravi@chennaitravels.com', 'Chennai, Tamil Nadu, India', 4.3),
('Hyderabad Bus Co.', 'Snehal Reddy', '9998776655', 'snehal@hydbus.com', 'Hyderabad, Telangana, India', 4.0),
('Pune Travels', 'Vikram Singh', '9812345678', 'vikram@punetravels.com', 'Pune, Maharashtra, India', 4.6),
('Jaipur Express', 'Kavita Jain', '9001122334', 'kavita@jaipurexpress.com', 'Jaipur, Rajasthan, India', 4.4);

-- Insert mock data into Bus Table
INSERT INTO Bus (BusNumber, Capacity, Model, RegistrationNumber, BusType, AgencyID)
VALUES 
('KL07AB1234', 45, 'Volvo B9R', 'MH12AB1234', 'AC', 1),
('KA10BC2345', 50, 'Mercedes Benz', 'KA09BC2345', 'Non-AC', 2),
('DL01X1234', 40, 'Ashok Leyland', 'DL01X2345', 'Sleeper', 3),
('MH03AB5678', 60, 'Scania', 'MH02AB5678', 'AC', 4),
('TN08X4567', 50, 'Tata Motors', 'TN08X5678', 'Non-AC', 5),
('TS09Z6789', 45, 'Volvo B11R', 'TS09Z6789', 'Sleeper', 6),
('MH14AA1111', 48, 'Ashok Leyland', 'MH14AA1111', 'AC', 7),
('RJ02X9876', 45, 'Mercedes Benz', 'RJ02X9876', 'Non-AC', 8);

-- Insert mock data into Passenger Table
INSERT INTO Passenger (Name, DOB, Gender, PhoneNumber, Email)
VALUES 
('Rahul Sharma', '1990-05-15', 'M', 9876543210, 'rahul.sharma@example.com'),
('Anita Iyer', '1985-08-23', 'F', 9912345678, 'anita.iyer@example.com'),
('Rajesh Verma', '1992-02-10', 'M', 9933445566, 'rajesh.verma@example.com'),
('Meera Gupta', '1988-07-19', 'F', 9966332211, 'meera.gupta@example.com'),
('Karan Patel', '1995-03-12', 'M', 9955667788, 'karan.patel@example.com'),
('Rita Singh', '1993-11-05', 'F', 9888776655, 'rita.singh@example.com'),
('Vikram Joshi', '1987-09-18', 'M', 9999888777, 'vikram.joshi@example.com'),
('Priya Shah', '1994-01-25', 'F', 9977665544, 'priya.shah@example.com');

-- Insert mock data into Reservation Table
INSERT INTO Reservation (PassengerID, BusNumber, ReservationDate, AmountPaid, Status, StartingPoint, Destination)
VALUES 
(1, 'KL07AB1234', '2025-01-10', 500.00, 'Confirmed', 'Kochi', 'Bangalore'),
(2, 'KA10BC2345', '2025-01-11', 600.00, 'Confirmed', 'Bangalore', 'Delhi'),
(3, 'DL01X1234', '2025-01-12', 700.00, 'Pending', 'Delhi', 'Mumbai'),
(4, 'MH03AB5678', '2025-01-13', 800.00, 'Confirmed', 'Mumbai', 'Chennai'),
(5, 'TN08X4567', '2025-01-14', 900.00, 'Cancelled', 'Chennai', 'Hyderabad'),
(6, 'TS09Z6789', '2025-01-15', 1000.00, 'Confirmed', 'Hyderabad', 'Pune'),
(7, 'MH14AA1111', '2025-01-16', 1100.00, 'Confirmed', 'Pune', 'Jaipur'),
(8, 'RJ02X9876', '2025-01-17', 1200.00, 'Pending', 'Jaipur', 'Kochi');

-- Insert mock data into Conductor Table
INSERT INTO Conductor (FirstName, LastName, ContactNumber, DOB)
VALUES 
('Anil', 'Patel', '9823456789', '1980-05-10'),
('Bina', 'Sharma', '9901234567', '1985-07-21'),
('Ravi', 'Reddy', '9876543210', '1990-09-11'),
('Priya', 'Verma', '9812345678', '1992-01-30'),
('Kumar', 'Singh', '9801122334', '1988-03-22'),
('Suman', 'Chawla', '9966445577', '1994-11-09'),
('Arvind', 'Jain', '9933556777', '1987-02-14'),
('Rekha', 'Iyer', '9900112233', '1983-12-01');

-- Insert mock data into Driver Table
INSERT INTO Driver (FirstName, LastName, ContactNumber, LicenseNumber, JoiningDate, DOB, Status)
VALUES 
('Vijay', 'Patel', '9845678901', 'DL1234567', '2010-06-15', '1980-03-23', 'Active'),
('Harish', 'Rao', '9999888777', 'DL2345678', '2015-04-10', '1985-11-30', 'Active'),
('Suresh', 'Singh', '9776655443', 'DL3456789', '2012-02-18', '1982-07-17', 'Inactive'),
('Rakesh', 'Sharma', '9812345670', 'DL4567890', '2017-08-21', '1988-01-09', 'Active'),
('Karan', 'Joshi', '9701011122', 'DL5678901', '2020-09-30', '1990-05-25', 'Active'),
('Raj', 'Nair', '9666887777', 'DL6789012', '2018-03-15', '1987-06-19', 'Inactive'),
('Pawan', 'Gupta', '9888998777', 'DL7890123', '2016-07-12', '1984-02-10', 'Active'),
('Anand', 'Reddy', '9799888777', 'DL8901234', '2014-11-09', '1983-12-30', 'Inactive');

-- Insert mock data into Feedbacks Table
INSERT INTO Feedbacks (ReservationID, PassengerID, AgencyID, Rating, Comment)
VALUES 
(1, 1, 1, 5, 'Excellent service, very comfortable bus and punctual.'),
(2, 2, 2, 4, 'Good experience, but bus was a bit late.'),
(3, 3, 3, 3, 'Sleeper bus was not up to the mark.'),
(4, 4, 4, 5, 'Great journey, will definitely travel again.'),
(5, 5, 5, 4, 'Decent trip, but the bus was slightly crowded.'),
(6, 6, 6, 5, 'Amazing comfort and great service throughout.'),
(7, 7, 7, 2, 'The bus was cancelled, causing inconvenience.'),
(8, 8, 8, 4, 'Overall good, but the cleanliness could be improved.');

-- Insert mock data into Payment Table
INSERT INTO Payment (ReservationID, PaymentDate, AmountPaid, PaymentMethod, TransactionID, Status)
VALUES 
(1, '2025-01-10', 1500.00, 'Credit Card', 'TXN123456', 'Success'),
(2, '2025-01-12', 1200.00, 'Debit Card', 'TXN789012', 'Success'),
(3, '2025-01-13', 1800.00, 'Net Banking', 'TXN345678', 'Pending'),
(4, '2025-01-14', 2000.00, 'UPI', 'TXN901234', 'Success'),
(5, '2025-01-15', 1100.00, 'Credit Card', 'TXN567890', 'Success'),
(6, '2025-01-16', 1600.00, 'Debit Card', 'TXN112233', 'Success'),
(7, '2025-01-17', 1300.00, 'UPI', 'TXN445566', 'Failed'),
(8, '2025-01-18', 1400.00, 'Net Banking', 'TXN778899', 'Success');

-- Insert mock data into Seat Table
INSERT INTO Seat (BusNumber, SeatNumber, Status, Type, Price)
VALUES 
('KL07AB1234', 1, 'Available', 'Window', 100.00),
('KL07AB1234', 2, 'Available', 'Aisle', 100.00),
('KA10BC2345', 3, 'Available', 'Middle', 120.00),
('KA10BC2345', 4, 'Available', 'Window', 120.00),
('DL01X1234', 5, 'Booked', 'Aisle', 140.00),
('DL01X1234', 6, 'Available', 'Middle', 140.00),
('MH03AB5678', 7, 'Booked', 'Window', 160.00),
('MH03AB5678', 8, 'Available', 'Aisle', 160.00),
('TN08X4567', 9, 'Available', 'Middle', 180.00),
('TN08X4567', 10, 'Booked', 'Window', 180.00),
('TS09Z6789', 11, 'Available', 'Aisle', 200.00),
('TS09Z6789', 12, 'Available', 'Middle', 200.00),
('MH14AA1111', 13, 'Booked', 'Window', 220.00),
('MH14AA1111', 14, 'Available', 'Aisle', 220.00),
('RJ02X9876', 15, 'Available', 'Middle', 240.00),
('RJ02X9876', 16, 'Available', 'Window', 240.00);


-- Insert mock data into Route Table
INSERT INTO Route (SourceLocation, Destination, BusNumber, DriverID, ConductorID)
VALUES 
('Kochi', 'Bangalore', 'KL07AB1234', 1, 1),
('Bangalore', 'Delhi', 'KA10BC2345', 2, 2),
('Delhi', 'Mumbai', 'DL01X1234', 3, 3),
('Mumbai', 'Chennai', 'MH03AB5678', 4, 4),
('Chennai', 'Hyderabad', 'TN08X4567', 5, 5),
('Hyderabad', 'Pune', 'TS09Z6789', 6, 6),
('Pune', 'Jaipur', 'MH14AA1111', 7, 7),
('Jaipur', 'Kochi', 'RJ02X9876', 8, 8);


-- Insert mock data into Schedule Table
INSERT INTO Schedule (ScheduleName, AgencyID)
VALUES 
('Morning Express', 1),
('Evening Special', 2),
('Night Owl', 3),
('Morning Breeze', 4),
('Evening Deluxe', 5),
('Midnight Ride', 6),
('Express Journey', 7),
('Day Trip', 8);

-- Insert mock data into ReservationSeat Table
INSERT INTO ReservationSeat (ReservationID, SeatID)
VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16);

-- Insert mock data into RouteSchedule Table
INSERT INTO RouteSchedule (RouteID, ScheduleID, DepartureTime, ReachingTime, DayOfOperation)
VALUES 
(1, 1, '08:00:00', '12:00:00', 'Monday'),
(2, 2, '09:00:00', '13:00:00', 'Tuesday'),
(3, 3, '23:00:00', '06:00:00', 'Wednesday'),
(4, 4, '07:30:00', '11:30:00', 'Thursday'),
(5, 5, '08:15:00', '12:15:00', 'Friday'),
(6, 6, '22:00:00', '05:00:00', 'Saturday'),
(7, 7, '06:00:00', '10:00:00', 'Sunday'),
(8, 8, '11:00:00', '15:00:00', 'Monday');

-- Insert mock data into RouteStop Table
INSERT INTO RouteStop (RouteID, StopID, Ord)
VALUES 
(1, 1, 1),  -- Kochi -> Bangalore (Stop 1)
(1, 2, 2),  -- Kochi -> Bangalore (Stop 2)
(2, 3, 1),  -- Bangalore -> Delhi (Stop 1)
(2, 4, 2),  -- Bangalore -> Delhi (Stop 2)
(3, 5, 1),  -- Delhi -> Mumbai (Stop 1)
(3, 6, 2),  -- Delhi -> Mumbai (Stop 2)
(4, 7, 1),  -- Mumbai -> Chennai (Stop 1)
(4, 8, 2),  -- Mumbai -> Chennai (Stop 2)
(5, 9, 1),  -- Chennai -> Hyderabad (Stop 1)
(5, 10, 2), -- Chennai -> Hyderabad (Stop 2)
(6, 11, 1), -- Hyderabad -> Pune (Stop 1)
(6, 12, 2), -- Hyderabad -> Pune (Stop 2)
(7, 13, 1), -- Pune -> Jaipur (Stop 1)
(7, 14, 2), -- Pune -> Jaipur (Stop 2)
(8, 15, 1), -- Jaipur -> Kochi (Stop 1)
(8, 16, 2); -- Jaipur -> Kochi (Stop 2)

-- Insert mock data into Stop Table
INSERT INTO Stop (StopName)
VALUES 
('Kochi Bus Stand'),
('Cochin International Airport'),
('Bangalore KSRTC Bus Station'),
('Bangalore M.G. Road'),
('Delhi ISBT Kashmere Gate'),
('Delhi Anand Vihar Terminal'),
('Mumbai Dadar Bus Station'),
('Mumbai Bandra Terminus'),
('Chennai Central Railway Station'),
('Chennai Koyambedu Bus Stand'),
('Hyderabad Secunderabad Bus Station'),
('Hyderabad MG Road'),
('Pune Shivajinagar Bus Stand'),
('Pune Pune Station'),
('Jaipur Sindhi Camp Bus Stand'),
('Jaipur Railway Station');
