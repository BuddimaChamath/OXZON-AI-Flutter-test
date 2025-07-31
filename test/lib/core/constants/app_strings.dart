class AppStrings {
  // App
  static const String appName = 'Employee Management';
  static const String appVersion = '1.0.0';

  // Navigation
  static const String home = 'Home';
  static const String addEmployee = 'Add Employee';
  static const String editEmployee = 'Edit Employee';
  static const String employeeDetails = 'Employee Details';

  // Labels
  static const String name = 'Name';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String department = 'Department';
  static const String role = 'Role';
  static const String joiningDate = 'Joining Date';
  static const String search = 'Search';
  static const String noEmployeesFound = 'No employees found';
  static const String loading = 'Loading...';

  // Buttons
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';

  // Messages
  static const String employeeAddedSuccess = 'Employee added successfully';
  static const String employeeUpdatedSuccess = 'Employee updated successfully';
  static const String employeeDeletedSuccess = 'Employee deleted successfully';
  static const String deleteConfirmation =
      'Are you sure you want to delete this employee?';
  static const String errorOccurred = 'An error occurred. Please try again.';

  // Validation
  static const String nameRequired = 'Name is required';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String phoneRequired = 'Phone is required';
  static const String phoneInvalid = 'Please enter a valid phone number';
  static const String departmentRequired = 'Department is required';
  static const String roleRequired = 'Role is required';
  static const String joiningDateRequired = 'Joining date is required';

  // Departments
  static const List<String> departments = [
    'Human Resources',
    'Engineering',
    'Marketing',
    'Sales',
    'Finance',
    'Operations',
    'IT Support',
    'Customer Service',
  ];

  // Roles
  static const List<String> roles = [
    'Manager',
    'Senior Developer',
    'Junior Developer',
    'Team Lead',
    'Analyst',
    'Specialist',
    'Coordinator',
    'Executive',
    'Intern',
  ];
}
