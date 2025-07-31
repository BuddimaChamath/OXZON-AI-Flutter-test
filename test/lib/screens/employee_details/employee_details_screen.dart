import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        final currentEmployee = provider.employees.firstWhere(
          (emp) => emp.id == employee.id,
          orElse: () => employee,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.employeeDetails),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.onPrimary),
                onPressed: () {
                  context.pushNamed(
                    'edit-employee',
                    extra: currentEmployee,
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
                onSelected: (value) {
                  switch (value) {
                    case 'copy_email':
                      _copyToClipboard(context, currentEmployee.email, 'Email');
                      break;
                    case 'copy_phone':
                      _copyToClipboard(context, currentEmployee.phone, 'Phone');
                      break;
                    case 'copy_id':
                      _copyToClipboard(
                          context, currentEmployee.id, 'Employee ID');
                      break;
                    case 'delete':
                      _deleteEmployee(context, currentEmployee);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_email',
                    child: Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 12),
                        Text('Copy Email'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'copy_phone',
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 12),
                        Text('Copy Phone'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'copy_id',
                    child: Row(
                      children: [
                        Icon(Icons.badge),
                        SizedBox(width: 12),
                        Text('Copy ID'),
                      ],
                    ),
                  ),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Card with Avatar
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.onPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(currentEmployee.name),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Name
                          Text(
                            currentEmployee.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Role & Department
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${currentEmployee.role} • ${currentEmployee.department}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Quick Actions
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.email,
                              label: 'Email',
                              onTap: () => _copyToClipboard(
                                  context, currentEmployee.email, 'Email'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.phone,
                              label: 'Call',
                              onTap: () => _copyToClipboard(
                                  context, currentEmployee.phone, 'Phone'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              onTap: () => context.pushNamed('edit-employee',
                                  extra: currentEmployee),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Information Cards
                      _buildInfoCard(
                        title: 'Contact Information',
                        children: [
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: currentEmployee.email,
                            onTap: () => _copyToClipboard(
                                context, currentEmployee.email, 'Email'),
                          ),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: currentEmployee.phone,
                            onTap: () => _copyToClipboard(
                                context, currentEmployee.phone, 'Phone'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInfoCard(
                        title: 'Work Information',
                        children: [
                          _buildInfoRow(
                            icon: Icons.business_outlined,
                            label: 'Department',
                            value: currentEmployee.department,
                          ),
                          _buildInfoRow(
                            icon: Icons.work_outline,
                            label: 'Role',
                            value: currentEmployee.role,
                          ),
                          _buildInfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Joining Date',
                            value: DateHelper.formatDisplayDate(
                                currentEmployee.joiningDate),
                          ),
                          _buildInfoRow(
                            icon: Icons.timeline_outlined,
                            label: 'Experience',
                            value: DateHelper.getWorkExperience(
                                currentEmployee.joiningDate),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInfoCard(
                        title: 'System Information',
                        children: [
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: 'Employee ID',
                            value: currentEmployee.id,
                            onTap: () => _copyToClipboard(
                                context, currentEmployee.id, 'Employee ID'),
                          ),
                          _buildInfoRow(
                            icon: Icons.access_time_outlined,
                            label: 'Created',
                            value: DateHelper.formatDateTime(
                                currentEmployee.createdAt),
                          ),
                          _buildInfoRow(
                            icon: Icons.update_outlined,
                            label: 'Last Updated',
                            value: DateHelper.formatDateTime(
                                currentEmployee.updatedAt),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Delete Button
                      SizedBox(
                        width: double.infinity,
                        child: DangerButton(
                          text: 'Delete Employee',
                          icon: Icons.delete,
                          onPressed: () =>
                              _deleteEmployee(context, currentEmployee),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.copy,
                  size: 16,
                  color: AppColors.grey.withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return 'E';
  }

  void _copyToClipboard(BuildContext context, String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.showInfo(context, '$type copied to clipboard');
  }

  Future<void> _deleteEmployee(
      BuildContext context, Employee currentEmployee) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      itemName: currentEmployee.name,
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<EmployeeProvider>(context, listen: false);
      final success = await provider.deleteEmployee(currentEmployee.id);

      if (success && context.mounted) {
        SnackBarHelper.showSuccess(context, AppStrings.employeeDeletedSuccess);
        context.pop();
      } else if (provider.errorMessage.isNotEmpty && context.mounted) {
        SnackBarHelper.showError(context, provider.errorMessage);
      }
    }
  }
}
