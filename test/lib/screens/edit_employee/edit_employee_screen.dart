import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee.dart';
import '../add_employee/widgets/employee_form.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const EditEmployeeScreen({
    super.key,
    required this.employee,
  });

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late String _selectedDepartment;
  late String _selectedRole;
  late DateTime _joiningDate;
  bool _hasUnsavedChanges = false;

  // Original values for comparison
  late final String _originalName;
  late final String _originalEmail;
  late final String _originalPhone;
  late final String _originalDepartment;
  late final String _originalRole;
  late final DateTime _originalJoiningDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _addListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.employee.name);
    _emailController = TextEditingController(text: widget.employee.email);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _selectedDepartment = widget.employee.department;
    _selectedRole = widget.employee.role;
    _joiningDate = widget.employee.joiningDate;

    // Store original values
    _originalName = widget.employee.name;
    _originalEmail = widget.employee.email;
    _originalPhone = widget.employee.phone;
    _originalDepartment = widget.employee.department;
    _originalRole = widget.employee.role;
    _originalJoiningDate = widget.employee.joiningDate;
  }

  void _addListeners() {
    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasChanges = _nameController.text.trim() != _originalName ||
        _emailController.text.trim() != _originalEmail ||
        _phoneController.text.trim() != _originalPhone ||
        _selectedDepartment != _originalDepartment ||
        _selectedRole != _originalRole ||
        _joiningDate != _originalJoiningDate;

    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  void _onDepartmentChanged(String department) {
    setState(() {
      _selectedDepartment = department;
    });
    _checkForChanges();
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
    });
    _checkForChanges();
  }

  void _onJoiningDateChanged(DateTime date) {
    setState(() {
      _joiningDate = date;
    });
    _checkForChanges();
  }

  Future<void> _updateEmployee() async {
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

    final provider = Provider.of<EmployeeProvider>(context, listen: false);

    final success = await provider.updateEmployee(
      id: widget.employee.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      department: _selectedDepartment,
      role: _selectedRole,
      joiningDate: _joiningDate,
    );

    if (success && mounted) {
      SnackBarHelper.showSuccess(context, AppStrings.employeeUpdatedSuccess);
      _hasUnsavedChanges = false;
      context.pop();
    } else {
      // Error message is handled by the provider
      if (provider.errorMessage.isNotEmpty) {
        SnackBarHelper.showError(context, provider.errorMessage);
      }
    }
  }

  void _resetForm() {
    _nameController.text = _originalName;
    _emailController.text = _originalEmail;
    _phoneController.text = _originalPhone;
    setState(() {
      _selectedDepartment = _originalDepartment;
      _selectedRole = _originalRole;
      _joiningDate = _originalJoiningDate;
      _hasUnsavedChanges = false;
    });
  }

  Future<void> _deleteEmployee() async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      itemName: widget.employee.name,
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<EmployeeProvider>(context, listen: false);
      final success = await provider.deleteEmployee(widget.employee.id);

      if (success && context.mounted) {
        SnackBarHelper.showSuccess(context, AppStrings.employeeDeletedSuccess);
        context.pop();
      } else if (provider.errorMessage.isNotEmpty && context.mounted) {
        SnackBarHelper.showError(context, provider.errorMessage);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final result = await UnsavedChangesDialog.show(context);

    if (result == 'save') {
      await _updateEmployee();
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
          title: const Text(AppStrings.editEmployee),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _resetForm,
                child: const Text(
                  'Reset',
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    _deleteEmployee();
                    break;
                  case 'view':
                    context.pushNamed(
                      'employee-details',
                      extra: widget.employee,
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.error),
                      SizedBox(width: 12),
                      Text(
                        'Delete Employee',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Consumer<EmployeeProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee ID info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Employee ID: ${widget.employee.id}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Employee Form
                    EmployeeForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      selectedDepartment: _selectedDepartment,
                      selectedRole: _selectedRole,
                      joiningDate: _joiningDate,
                      onDepartmentChanged: _onDepartmentChanged,
                      onRoleChanged: _onRoleChanged,
                      onJoiningDateChanged: _onJoiningDateChanged,
                      isEditing: true,
                    ),
                  ],
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
                      text: 'Update',
                      isLoading: provider.isLoading,
                      onPressed: provider.isLoading || !_hasUnsavedChanges
                          ? null
                          : _updateEmployee,
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
