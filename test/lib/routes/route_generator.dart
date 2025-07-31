import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/add_employee/add_employee_screen.dart';
import '../screens/edit_employee/edit_employee_screen.dart';
import '../screens/employee_details/employee_details_screen.dart';
import '../models/employee.dart';

class AppRoutes {
  static const String home = '/';
  static const String addEmployee = '/add-employee';
  static const String editEmployee = '/edit-employee';
  static const String employeeDetails = '/employee-details';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: addEmployee,
        name: 'add-employee',
        builder: (context, state) => const AddEmployeeScreen(),
      ),
      GoRoute(
        path: editEmployee,
        name: 'edit-employee',
        builder: (context, state) {
          final employee = state.extra as Employee;
          return EditEmployeeScreen(employee: employee);
        },
      ),
      GoRoute(
        path: employeeDetails,
        name: 'employee-details',
        builder: (context, state) {
          final employee = state.extra as Employee;
          return EmployeeDetailsScreen(employee: employee);
        },
      ),
    ],
  );
}
