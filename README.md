# INFS4102

This repository consists of 2 seperate projects:
- Main Deskptop project Eshop:
  -   Ecommerce Desktop Application built with Flutter
  -   Group Project
  
- Mobile App project Daily flow: mobile_app/
  -   Mobile Routine App built with React-Native
  -   Individual Project
  
PLEASE EXTRACT THE MOBILE APP FOLDER OUT OF THE MAIN DESKTOP APP PROJECT BEFORE RUNNING
  

## Eshop Desktop Application
### Project Structure
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

## Mobile App: DailyFlow
DailyFlow is a Routine App built to track and modify your daily routines

### Project Structure
```
mobile_app
├── components/
│   ├──tasks.js
│   └──taskContext.js
│
├── context
│   ├──progressContext.js
│   └──taskContext.js
│
└──screens/
│   ├──edit.js
│   ├──home.js
│   ├──profile.js
│   ├──progress.js
│   └──Registration.js
│
├── App.js
├── context
├── config.js
└── index.js
```
### Screens
- Home: Main Screen
  - List of routine tasks
  - Streak: Tracks number of consecutive days
  
- Edit:
  -  Add, Modify, Delete Tasks

- Progress: Tracking
  -  Max Streak
  -  Current Streak
  -  Previous tasks missed
  
- profile:
  - User information
  - Logout Button
  - Routine Modes: Leisure (Non-time restrictive), Sequential (time restrictive)
  
- Registration: Login Screen

### Scenarios:
- User completes all tasks of the day and continues streak.
- User fails to complete tasks within that day and loses streak:
  - If streak > max streak: Max streak is updated
  - Missed tasks recorded in progress
- User adds new tasks before completing all existing tasks: task is included for that day.
- User adds new tasks after completing all existing tasks: task is not included for that day and will be activated the next day.
- User activates leisure mode (default): tasks can be completed non-sequentially and not restricted to time.
- User activates sequential mode: tasks are time-restricted and must be done sequentially.
  - User loses streak after missing one tasks within the assigned time.
