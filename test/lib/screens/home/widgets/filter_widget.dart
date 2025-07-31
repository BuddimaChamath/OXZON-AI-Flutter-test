import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/employee_provider.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Header
              Row(
                children: [
                  const Icon(
                    Icons.tune,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  // Clear filters button
                  if (provider.hasActiveFilters)
                    TextButton.icon(
                      onPressed: () => provider.clearFilters(),
                      icon: const Icon(
                        Icons.clear_all,
                        size: 16,
                      ),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Department Filter
              _buildFilterSection(
                title: 'Department',
                icon: Icons.business,
                child: provider.getDepartments().isEmpty
                    ? const Text(
                        'No departments available',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: provider.getDepartments().map((department) {
                          final isSelected =
                              provider.selectedDepartment == department;
                          return FilterChip(
                            label: Text(department),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                provider.filterByDepartment(department);
                              } else {
                                provider.filterByDepartment('');
                              }
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
              ),

              const SizedBox(height: 16),

              // Role Filter
              _buildFilterSection(
                title: 'Role',
                icon: Icons.work,
                child: provider.getRoles().isEmpty
                    ? const Text(
                        'No roles available',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: provider.getRoles().map((role) {
                          final isSelected = provider.selectedRole == role;
                          return FilterChip(
                            label: Text(role),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                provider.filterByRole(role);
                              } else {
                                provider.filterByRole('');
                              }
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
              ),

              const SizedBox(height: 16),

              // Date Range Filter
              _buildFilterSection(
                title: 'Joining Date Range',
                icon: Icons.date_range,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            context: context,
                            label: 'From Date',
                            selectedDate: provider.dateRangeStart,
                            onDateSelected: (date) =>
                                provider.setDateRangeStart(date),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateField(
                            context: context,
                            label: 'To Date',
                            selectedDate: provider.dateRangeEnd,
                            onDateSelected: (date) =>
                                provider.setDateRangeEnd(date),
                          ),
                        ),
                      ],
                    ),
                    if (provider.dateRangeStart != null ||
                        provider.dateRangeEnd != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => provider.clearDateRange(),
                              icon: const Icon(Icons.clear, size: 16),
                              label: const Text('Clear Dates'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Filter Results Summary
              if (provider.hasActiveFilters) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing ${provider.employees.length} employee(s) matching your filters',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.grey),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: AppColors.primary,
                    ),
              ),
              child: child!,
            );
          },
        );
        onDateSelected(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate != null
                          ? AppColors.onSurface
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
