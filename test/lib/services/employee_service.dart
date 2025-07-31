import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/employee.dart';
import '../core/constants/firebase_constants.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Get reference to employees collection
  CollectionReference get _employeesRef =>
      _firestore.collection(FirebaseConstants.employeesCollection);

  // Add new employee
  Future<String> addEmployee({
    required String name,
    required String email,
    required String phone,
    required String department,
    required String role,
    required DateTime joiningDate,
  }) async {
    try {
      final String employeeId = _uuid.v4();
      final DateTime now = DateTime.now();

      final Employee employee = Employee(
        id: employeeId,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        department: department,
        role: role,
        joiningDate: joiningDate,
        createdAt: now,
        updatedAt: now,
      );

      await _employeesRef.doc(employeeId).set(employee.toMap());
      return employeeId;
    } catch (e) {
      throw Exception('Failed to add employee: ${e.toString()}');
    }
  }

  // Get all employees
  Stream<List<Employee>> getAllEmployees() {
    try {
      return _employeesRef
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Employee.fromSnapshot(doc)).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch employees: ${e.toString()}');
    }
  }

  // Get employee by ID
  Future<Employee?> getEmployeeById(String id) async {
    try {
      final DocumentSnapshot doc = await _employeesRef.doc(id).get();
      if (doc.exists) {
        return Employee.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch employee: ${e.toString()}');
    }
  }

  // Update employee
  Future<void> updateEmployee({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String department,
    required String role,
    required DateTime joiningDate,
  }) async {
    try {
      final DateTime now = DateTime.now();

      final Map<String, dynamic> updateData = {
        FirebaseConstants.nameField: name.trim(),
        FirebaseConstants.emailField: email.trim().toLowerCase(),
        FirebaseConstants.phoneField: phone.trim(),
        FirebaseConstants.departmentField: department,
        FirebaseConstants.roleField: role,
        FirebaseConstants.joiningDateField: Timestamp.fromDate(joiningDate),
        FirebaseConstants.updatedAtField: Timestamp.fromDate(now),
      };

      await _employeesRef.doc(id).update(updateData);
    } catch (e) {
      throw Exception('Failed to update employee: ${e.toString()}');
    }
  }

  // Delete employee
  Future<void> deleteEmployee(String id) async {
    try {
      await _employeesRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete employee: ${e.toString()}');
    }
  }

  // Search employees by name, email, or department
  Stream<List<Employee>> searchEmployees(String query) {
    try {
      if (query.trim().isEmpty) {
        return getAllEmployees();
      }

      final String searchQuery = query.trim().toLowerCase();

      return _employeesRef
          .orderBy(FirebaseConstants.nameField)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Employee.fromSnapshot(doc))
            .where((employee) {
          return employee.name.toLowerCase().contains(searchQuery) ||
              employee.email.toLowerCase().contains(searchQuery) ||
              employee.department.toLowerCase().contains(searchQuery) ||
              employee.role.toLowerCase().contains(searchQuery);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to search employees: ${e.toString()}');
    }
  }

  // Get employees by department
  Stream<List<Employee>> getEmployeesByDepartment(String department) {
    try {
      return _employeesRef
          .where(FirebaseConstants.departmentField, isEqualTo: department)
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Employee.fromSnapshot(doc)).toList();
      });
    } catch (e) {
      throw Exception(
          'Failed to fetch employees by department: ${e.toString()}');
    }
  }

  // Get employees by role
  Stream<List<Employee>> getEmployeesByRole(String role) {
    try {
      return _employeesRef
          .where(FirebaseConstants.roleField, isEqualTo: role)
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Employee.fromSnapshot(doc)).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch employees by role: ${e.toString()}');
    }
  }

  // Get employee count
  Future<int> getEmployeeCount() async {
    try {
      final QuerySnapshot snapshot = await _employeesRef.get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get employee count: ${e.toString()}');
    }
  }

  // Check if email already exists
  Future<bool> isEmailExists(String email, {String? excludeId}) async {
    try {
      final QuerySnapshot snapshot = await _employeesRef
          .where(FirebaseConstants.emailField,
              isEqualTo: email.trim().toLowerCase())
          .get();

      if (excludeId != null) {
        // When updating, exclude the current employee's email
        return snapshot.docs.any((doc) => doc.id != excludeId);
      }

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check email existence: ${e.toString()}');
    }
  }

  // Batch delete employees (for admin purposes)
  Future<void> deleteMultipleEmployees(List<String> employeeIds) async {
    try {
      final WriteBatch batch = _firestore.batch();

      for (String id in employeeIds) {
        batch.delete(_employeesRef.doc(id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete multiple employees: ${e.toString()}');
    }
  }
}
