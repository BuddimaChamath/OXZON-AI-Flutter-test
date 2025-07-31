import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/custom_text_field.dart';

class EmployeeForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String selectedDepartment;
  final String selectedRole;
  final DateTime? joiningDate;
  final Function(String) onDepartmentChanged;
  final Function(String) onRoleChanged;
  final Function(DateTime) onJoiningDateChanged;
  final bool isEditing;

  const EmployeeForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.selectedDepartment,
    required this.selectedRole,
    required this.joiningDate,
    required this.onDepartmentChanged,
    required this.onRoleChanged,
    required this.onJoiningDateChanged,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Section
        _buildSectionHeader('Personal Information'),
        const SizedBox(height: 16),

        CustomTextField(
          label: AppStrings.name,
          controller: nameController,
          validator: Validators.validateName,
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.grey),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 20),

        EmailTextField(
          controller: emailController,
          validator: Validators.validateEmail,
        ),
        const SizedBox(height: 20),

        PhoneTextField(
          controller: phoneController,
          validator: Validators.validatePhone,
        ),
        const SizedBox(height: 32),

        // Work Information Section
        _buildSectionHeader('Work Information'),
        const SizedBox(height: 16),

        _buildDropdownField(
          label: AppStrings.department,
          value: selectedDepartment,
          items: AppStrings.departments,
          onChanged: onDepartmentChanged,
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 20),

        _buildDropdownField(
          label: AppStrings.role,
          value: selectedRole,
          items: AppStrings.roles,
          onChanged: onRoleChanged,
          icon: Icons.work_outline,
        ),
        const SizedBox(height: 20),

        _buildDateField(
          context: context,
          label: AppStrings.joiningDate,
          selectedDate: joiningDate,
          onDateChanged: onJoiningDateChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: 'Select $label',
            hintStyle: const TextStyle(color: AppColors.grey),
            prefixIcon: Icon(icon, color: AppColors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
          dropdownColor: AppColors.surface,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.onSurface,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, selectedDate, onDateChanged),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    color: AppColors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateHelper.formatDisplayDate(selectedDate)
                        : 'Select $label',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null
                          ? AppColors.onSurface
                          : AppColors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? currentDate,
    Function(DateTime) onDateChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      onDateChanged(picked);
    }
  }
}
