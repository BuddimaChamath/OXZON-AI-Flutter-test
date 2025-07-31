# Employee Management System (CRUD App)

A full-stack Employee Management System built with Flutter and Firebase Firestore for OXZON AI internship assessment.

##  Features Implemented

### Core Features
-  **Add Employee**: Create new employee records with name, email, phone, department, role, and joining date
-  **View Employees**: Display all employees in a clean table/list view
-  **Edit Employee**: Update existing employee details
-  **Delete Employee**: Remove employee records with confirmation dialog

### Bonus Features (Implemented)
-  **Search**: Real-time search employees by name with live filtering
-  **Advanced Filters**: Filter by department, role, and joining date range
-  **Sort Options**: Sort by name, joining date, and department
-  **Professional UI**: Clean, modern interface with avatar initials and experience calculation
-  **Employee Details**: Comprehensive employee profile with contact, work, and system information
-  **Smart Data Display**: Shows experience years, creation/update timestamps
-  **Visual Elements**: Color-coded avatar circles and intuitive icons
-  **Empty State**: Helpful empty state when no employees exist
-  **Success Feedback**: Toast notifications for successful operations

##  Technology Stack

- **Frontend & Backend**: Flutter (Dart)
- **Database**: Firebase Firestore
- **State Management**: Provider

##  Project Structure

```
employee_management_system/
├── lib/
│   ├── models/
│   │   └── employee_model.dart
│   ├── screens/
│   │   ├── employee_list_screen.dart
│   │   ├── add_employee_screen.dart
│   │   └── edit_employee_screen.dart
│   ├── services/
│   │   └── firestore_service.dart
│   ├── widgets/
│   │   ├── employee_card.dart
│   │   └── custom_text_field.dart
│   └── main.dart
├── android/
├── ios/
├── web/
├── screenshots/
├── pubspec.yaml
└── README.md
```

##  Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Firebase Setup

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project"
   - Follow the setup wizard

2. **Enable Firestore Database**
   - Navigate to Firestore Database
   - Click "Create database"
   - Choose "Start in test mode" for development

3. **Add Flutter App to Firebase**
   - Click "Add app" and select Flutter
   - Register your app with package name
   - Download `google-services.json` (Android)

4. **Configure Firebase for Flutter**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your Flutter project
   flutterfire configure
   ```

### Local Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/employee-management-system.git
   cd employee-management-system
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration Files**
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`

4. **Run the Application**
   ```bash
   # For development
   flutter run
   
   # For release build
   flutter run --release
   ```


##  Key Features Walkthrough

### Adding an Employee
1. Tap the "Add Employee" floating action button
2. Fill in personal information (name, email, phone)
3. Select department and role from dropdown menus
4. Choose joining date using date picker
5. Form validation ensures all required fields are completed
6. Employee is saved to Firestore with auto-generated UUID

### Viewing Employees
1. Main screen displays all employees in scrollable card format
2. Each card shows avatar with initials, name, role, department, contact info
3. Experience calculation shows years/days since joining
4. Search bar provides real-time filtering
5. Filter and sort options available via toolbar icons
6. Empty state guides users when no employees exist

### Employee Details
1. Tap on any employee card to view detailed profile
2. Comprehensive view with contact information, work details, and system data
3. Shows employee ID, creation/update timestamps
4. Quick action buttons for email, call, and edit
5. Professional layout with organized information sections

### Editing an Employee
1. From employee details, tap the edit icon or "Edit" button
2. Pre-populated form with current employee data
3. Employee ID displayed for reference (non-editable)
4. Update any field using dropdowns and text inputs
5. Changes saved immediately to Firestore with updated timestamp

### Deleting an Employee
1. From employee details screen, tap "Delete Employee" button
2. Confirmation dialog prevents accidental deletion with employee name
3. Employee record permanently removed from Firestore
4. Success toast notification confirms deletion
5. Automatic navigation back to employee list

### Search and Filter Features
1. **Real-time Search**: Type in search bar to filter by name instantly
2. **Department Filter**: Select one or multiple departments (Engineering, Finance, IT Support)
3. **Role Filter**: Filter by roles (Analyst, Junior Developer, Manager)
4. **Date Range Filter**: Set joining date range with from/to date pickers
5. **Active Filter Indicator**: Shows count of matching results
6. **Sort Options**: Sort by name, joining date, or department
7. **Clear Filters**: Quick reset of all applied filters

##  Contributing

This project is part of an internship assessment. Please refer to the confidentiality notice in the task requirements.

##  License

This project is created for OXZON AI internship assessment purposes.

##  Developer

**S.H. BUDDIMA CHAMATH KUMARA**
- Email: buddimachamathlive@gmail.com

---

**OXZON AI Internship Task**: Employee Management System (CRUD)