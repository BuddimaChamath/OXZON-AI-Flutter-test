import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../providers/employee_provider.dart';
import 'widgets/employee_form.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedDepartment = '';
  String _selectedRole = '';
  DateTime? _joiningDate;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addListeners() {
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _onDepartmentChanged(String department) {
    setState(() {
      _selectedDepartment = department;
      _hasUnsavedChanges = true;
    });
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
      _hasUnsavedChanges = true;
    });
  }

  void _onJoiningDateChanged(DateTime date) {
    setState(() {
      _joiningDate = date;
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartment.isEmpty) {
      SnackBarHelper.showError(context, AppStrings.departmentRequired);
      return;
    }

    if (_selectedRole.isEmpty) {
      SnackBarHelper.showError(context, AppStrings.roleRequired);
      return;
    }

    if (_joiningDate == null) {
      SnackBarHelper.showError(context, AppStrings.joiningDateRequired);
      return;
    }

    final provider = Provider.of<EmployeeProvider>(context, listen: false);

    final success = await provider.addEmployee(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      department: _selectedDepartment,
      role: _selectedRole,
      joiningDate: _joiningDate!,
    );

    if (success && mounted) {
      SnackBarHelper.showSuccess(context, AppStrings.employeeAddedSuccess);
      _hasUnsavedChanges = false;
      context.pop();
    } else {
      // Error message is handled by the provider
      if (provider.errorMessage.isNotEmpty) {
        SnackBarHelper.showError(context, provider.errorMessage);
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() {
      _selectedDepartment = '';
      _selectedRole = '';
      _joiningDate = null;
      _hasUnsavedChanges = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final result = await UnsavedChangesDialog.show(context);

    if (result == 'save') {
      await _saveEmployee();
      return !_hasUnsavedChanges; // Only pop if save was successful
    } else if (result == 'discard') {
      return true;
    }

    return false; // Cancel
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addEmployee),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _clearForm,
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              ),
          ],
        ),
        body: Consumer<EmployeeProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: EmployeeForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  selectedDepartment: _selectedDepartment,
                  selectedRole: _selectedRole,
                  joiningDate: _joiningDate,
                  onDepartmentChanged: _onDepartmentChanged,
                  onRoleChanged: _onRoleChanged,
                  onJoiningDateChanged: _onJoiningDateChanged,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
          ),
          child: Consumer<EmployeeProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: AppStrings.cancel,
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final shouldPop = await _onWillPop();
                              if (shouldPop && mounted) {
                                context.pop();
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: AppStrings.save,
                      isLoading: provider.isLoading,
                      onPressed: provider.isLoading ? null : _saveEmployee,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
