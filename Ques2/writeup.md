# Database Design Rationale: Swiggy and redBus

## 1. Normalization Approach
The databases for both Swiggy and RedBus were designed following **3rd Normal Form (3NF)** principles to eliminate data redundancy and maintain data integrity.

- **Swiggy**:
  - Key entities like `Customer`, `Restaurant`, and `Order` are separated into individual tables to avoid duplication and ensure data consistency.
  - Attributes such as `WalletBalance` (in `Customer`) and `Rating` (in `Restaurant`) are stored specific to their respective entities.

- **redBus**:
  - Entities such as `Bus`, `Agency`, and `Route` were normalized to ensure that related data is stored only in the appropriate tables. For example, `Driver` information is maintained in the `Driver` table and referenced using foreign keys in the `Route` table.

## 2. Key Normalization Decisions
- **Separation of Concerns**:
  - Both databases use distinct tables to handle different responsibilities. For example:
    - `Menu` and `Menu_Item` in Swiggy allow efficient management of restaurant menus without duplicating restaurant details.
    - `Route` and `RouteStop` in redBus manage routes and stops independently.

- **Avoiding Update Anomalies**:
  - Fields like `DriverID` and `ConductorID` in the `Route` table of redBus ensure updates to driver details are only required in the `Driver` table.

- **Composite Relationships**:
  - Many-to-many relationships are managed using junction tables:
    - Swiggy: `Favorite_Restaurant` for customer-favorite restaurants.
    - redBus: `ReservationSeat` for mapping reservations to seats.

## 3. Denormalization
Some tables were intentionally left slightly denormalized for better performance:
- **Swiggy `Order` Table**:
  - Includes `TotalAmount` and `DeliveryAddress` to reduce joins when fetching order details.
- **redBus `Route` Table**:
  - Includes `BusNumber` for easy reference to the bus on a route without multiple joins.

These design choices optimize frequently queried data while maintaining overall database integrity.

## 4. Phone Number: String vs. Number
- **Choice Made**: Phone numbers are stored as strings.
- **Benefits**:
  - Supports leading zeros (important for international numbers).
  - Allows storing formatted numbers (e.g., `+91-9876543210`).
- **Drawbacks**:
  - Slightly higher storage overhead.
  - Arithmetic operations (though rarely needed) cannot be performed.

## 5. Advantages of Normalization
- **Data Integrity**:
  - Foreign key constraints ensure consistency. For example, deleting a restaurant owner cascades to their restaurants (if configured).
- **Storage Efficiency**:
  - Avoids redundant data storage. For instance, no duplication of driver information across routes in redBus.
- **Query Optimization**:
  - Focused tables allow efficient indexing and querying.

## 6. Example Query Benefits
- **Swiggy**:
  - Querying all menu items for a specific restaurant is efficient using the `Menu` and `Menu_Item` tables.
- **redBus**:
  - Fetching all stops on a route is straightforward using the `RouteStop` table.
