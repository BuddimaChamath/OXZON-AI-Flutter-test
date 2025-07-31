import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = AppStrings.confirm,
    this.cancelText = AppStrings.cancel,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isDangerous ? AppColors.error : AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDangerous ? AppColors.error : AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.onSurface,
          height: 1.4,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SecondaryButton(
          text: cancelText,
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
        ),
        const SizedBox(width: 12),
        CustomButton(
          text: confirmText,
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          backgroundColor: confirmColor ??
              (isDangerous ? AppColors.error : AppColors.primary),
          textColor: AppColors.onPrimary,
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppStrings.confirm,
    String cancelText = AppStrings.cancel,
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final String itemType;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    this.itemType = 'employee',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Delete $itemType',
      message:
          'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.delete_outline,
      isDangerous: true,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String itemName,
    String itemType = 'employee',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteConfirmationDialog(
        itemName: itemName,
        itemType: itemType,
      ),
    );
  }
}

class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onDiscard;
  final VoidCallback? onCancel;

  const UnsavedChangesDialog({
    super.key,
    this.onSave,
    this.onDiscard,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: AppColors.warning,
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Unsaved Changes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
      content: const Text(
        'You have unsaved changes. What would you like to do?',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.onSurface,
          height: 1.4,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('cancel');
            onCancel?.call();
          },
          child: const Text(AppStrings.cancel),
        ),
        SecondaryButton(
          text: 'Discard',
          onPressed: () {
            Navigator.of(context).pop('discard');
            onDiscard?.call();
          },
        ),
        const SizedBox(width: 8),
        PrimaryButton(
          text: AppStrings.save,
          onPressed: () {
            Navigator.of(context).pop('save');
            onSave?.call();
          },
        ),
      ],
    );
  }

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UnsavedChangesDialog(),
    );
  }
}
