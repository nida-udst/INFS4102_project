# INFS4102

## Vora Internship Application
This repository consists of 2 projects:
- Main Deskptop project Eshop:
  -   Ecommerce Desktop Application built with Flutter
  -   Group Project
  
- Mobile App project Daily flow:
  -   Mobile Routine App built with React-Native
  -   Individual Project
  
PLEASE EXTRACT THE MOBILE APP FOLDER OUT OF THE MAIN DESKTOP APP PROJECT BEFORE RUNNING
  

## Eshop Project Structure
```
INFS4102_Project
├── .vscode
├── Backend/
│   └──eshop/
│       ├──product_images/
│       └──src/main/
│           ├──java/qa/udst/eshop
│           │   ├──config/
│           │   │    └──WebConfig.java
│           │   ├──controllers/
│           │   │    ├──ProductController.java
│           │   │    ├──CartController.java
│           │   │    └──OrderController.java
│           │   ├──models/
│           │   │    ├──Product.java
│           │   │    ├──Accessory.java
│           │   │    ├──Clothing.java
│           │   │    ├──Equipment.java
│           │   │    ├──Nutrition.java
│           │   │    ├──ProductCategory.java
│           │   │    ├──ProductNotFoundException.java
│           │   │    ├──Order.java
│           │   │    ├──OrderItem.java
│           │   │    ├──Cart.java
│           │   │    └──CartItem.java
│           │   ├──repositories/
│           │   │    ├──ProductRepositoryMongo.java
│           │   │    ├──OrderRepository.java
│           │   │    └──CartRepository.java
│           │   ├──services/
│           │   │    ├──ProductService.java
│           │   │    ├──OrderService.java
│           │   │    └──CartService.java
│           │   ├──Ehop.http
│           │   └──EshopApplication.java
│           └──resources
├── Frontend
│   └──eshop-ui/
│       └──lib/
│           ├──models/
│           │   ├──Product.dart
│           │   ├──Accessory.dart
│           │   ├──Clothing.dart
│           │   ├──Equipment.dart
│           │   ├──Nutrition.dart
│           │   ├──Order.dart
│           │   └──OrderItem.dart
│           ├──screens/
│           │   ├──product_catalog.dart
│           │   └──Order_Screens.dart
│           ├──services/
│           │   ├──product_service.dart
│           │   └──Order_Service.dart
│           ├──widgets/
│           │   └──navigation_bar.dart
│           └──main.dart
└──README.md

```
## Running Application

### Clone the Repository
```bash
git clone <repository-url>
cd INFS4102_Project
```

### Run Mongodb
Run mongodb in your local computer
```bash
net start Mongodb
```
#### configure database:
create database: **eshop**
tables:
- products
- orders
- cart

### Run spring boot (backend)
keep this running in a terminal
```bash
cd backend
cd eshop
mvn clean install
mvn spring-boot:run
```
### Run flutter (frontend)
create a new terminal and run the frontend
```bash
cd frontend
cd eshop_ui
flutter run
```
