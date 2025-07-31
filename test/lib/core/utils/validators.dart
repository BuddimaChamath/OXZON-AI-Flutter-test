import 'package:email_validator/email_validator.dart';
import '../constants/app_strings.dart';

class Validators {
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!EmailValidator.validate(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }

    // Remove any spaces, dashes, or parentheses
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains only digits and optional + at the start
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(cleanPhone)) {
      return AppStrings.phoneInvalid;
    }

    // Check length (international format: 7-15 digits)
    String digits = cleanPhone.replaceAll('+', '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Phone number must be 7-15 digits';
    }

    return null;
  }

  // Department validation
  static String? validateDepartment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.departmentRequired;
    }
    return null;
  }

  // Role validation
  static String? validateRole(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.roleRequired;
    }
    return null;
  }

  // Joining date validation
  static String? validateJoiningDate(DateTime? value) {
    if (value == null) {
      return AppStrings.joiningDateRequired;
    }

    // Check if joining date is not in the future
    if (value.isAfter(DateTime.now())) {
      return 'Joining date cannot be in the future';
    }

    // Check if joining date is not too far in the past (e.g., 50 years)
    DateTime fiftyYearsAgo =
        DateTime.now().subtract(const Duration(days: 365 * 50));
    if (value.isBefore(fiftyYearsAgo)) {
      return 'Joining date seems too far in the past';
    }

    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Search query validation
  static bool isValidSearchQuery(String? query) {
    if (query == null || query.trim().isEmpty) {
      return false;
    }
    return query.trim().length >= 2;
  }
}
