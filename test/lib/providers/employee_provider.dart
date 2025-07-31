import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();

  List<Employee> _employees = [];
  List<Employee> _filteredEmployees = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedDepartment = '';
  String _selectedRole = '';
  DateTime? _dateRangeStart;
  DateTime? _dateRangeEnd;

  // Getters
  List<Employee> get employees => _filteredEmployees;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedDepartment => _selectedDepartment;
  String get selectedRole => _selectedRole;
  DateTime? get dateRangeStart => _dateRangeStart;
  DateTime? get dateRangeEnd => _dateRangeEnd;
  int get employeeCount => _employees.length;

  // NEW: Check if any filters are active
  bool get hasActiveFilters {
    return _selectedDepartment.isNotEmpty ||
        _selectedRole.isNotEmpty ||
        _dateRangeStart != null ||
        _dateRangeEnd != null ||
        _searchQuery.isNotEmpty;
  }

  // Initialize and load employees
  void initialize() {
    loadEmployees();
  }

  // Load all employees
  void loadEmployees() {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _employeeService.getAllEmployees().listen(
      (employees) {
        _employees = employees;
        _applyFilters();
        _isLoading = false;
        _errorMessage = '';
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Add new employee
  Future<bool> addEmployee({
    required String name,
    required String email,
    required String phone,
    required String department,
    required String role,
    required DateTime joiningDate,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Check if email already exists
      final bool emailExists = await _employeeService.isEmailExists(email);
      if (emailExists) {
        _errorMessage = 'An employee with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _employeeService.addEmployee(
        name: name,
        email: email,
        phone: phone,
        department: department,
        role: role,
        joiningDate: joiningDate,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update employee
  Future<bool> updateEmployee({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String department,
    required String role,
    required DateTime joiningDate,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Check if email already exists (excluding current employee)
      final bool emailExists =
          await _employeeService.isEmailExists(email, excludeId: id);
      if (emailExists) {
        _errorMessage = 'An employee with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _employeeService.updateEmployee(
        id: id,
        name: name,
        email: email,
        phone: phone,
        department: department,
        role: role,
        joiningDate: joiningDate,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete employee
  Future<bool> deleteEmployee(String id) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _employeeService.deleteEmployee(id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get employee by ID
  Future<Employee?> getEmployeeById(String id) async {
    try {
      return await _employeeService.getEmployeeById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Search employees
  void searchEmployees(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by department
  void filterByDepartment(String department) {
    _selectedDepartment = department;
    _applyFilters();
    notifyListeners();
  }

  // Filter by role
  void filterByRole(String role) {
    _selectedRole = role;
    _applyFilters();
    notifyListeners();
  }

  // Date range filtering methods
  void setDateRangeStart(DateTime? date) {
    _dateRangeStart = date;
    _applyFilters();
    notifyListeners();
  }

  void setDateRangeEnd(DateTime? date) {
    _dateRangeEnd = date;
    _applyFilters();
    notifyListeners();
  }

  void clearDateRange() {
    _dateRangeStart = null;
    _dateRangeEnd = null;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters including date range
  void clearFilters() {
    _searchQuery = '';
    _selectedDepartment = '';
    _selectedRole = '';
    _dateRangeStart = null;
    _dateRangeEnd = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters to employee list (now includes date range)
  void _applyFilters() {
    List<Employee> filtered = List.from(_employees);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final String query = _searchQuery.toLowerCase();
      filtered = filtered.where((employee) {
        return employee.name.toLowerCase().contains(query) ||
            employee.email.toLowerCase().contains(query) ||
            employee.department.toLowerCase().contains(query) ||
            employee.role.toLowerCase().contains(query) ||
            employee.phone.contains(query);
      }).toList();
    }

    // Apply department filter
    if (_selectedDepartment.isNotEmpty) {
      filtered = filtered
          .where((employee) => employee.department == _selectedDepartment)
          .toList();
    }

    // Apply role filter
    if (_selectedRole.isNotEmpty) {
      filtered =
          filtered.where((employee) => employee.role == _selectedRole).toList();
    }

    // Apply date range filter
    if (_dateRangeStart != null || _dateRangeEnd != null) {
      filtered = filtered.where((employee) {
        final joiningDate = employee.joiningDate;

        if (_dateRangeStart != null && joiningDate.isBefore(_dateRangeStart!)) {
          return false;
        }

        if (_dateRangeEnd != null && joiningDate.isAfter(_dateRangeEnd!)) {
          return false;
        }

        return true;
      }).toList();
    }

    _filteredEmployees = filtered;
  }

  // Sort employees
  void sortEmployees(String sortBy, bool ascending) {
    switch (sortBy) {
      case 'name':
        _filteredEmployees.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 'email':
        _filteredEmployees.sort((a, b) => ascending
            ? a.email.compareTo(b.email)
            : b.email.compareTo(a.email));
        break;
      case 'department':
        _filteredEmployees.sort((a, b) => ascending
            ? a.department.compareTo(b.department)
            : b.department.compareTo(a.department));
        break;
      case 'role':
        _filteredEmployees.sort((a, b) =>
            ascending ? a.role.compareTo(b.role) : b.role.compareTo(a.role));
        break;
      case 'joiningDate':
        _filteredEmployees.sort((a, b) => ascending
            ? a.joiningDate.compareTo(b.joiningDate)
            : b.joiningDate.compareTo(a.joiningDate));
        break;
      default:
        _filteredEmployees.sort((a, b) => ascending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
    }
    notifyListeners();
  }

  // Get departments list (unique)
  List<String> getDepartments() {
    return _employees.map((e) => e.department).toSet().toList()..sort();
  }

  // Get roles list (unique)
  List<String> getRoles() {
    return _employees.map((e) => e.role).toSet().toList()..sort();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
