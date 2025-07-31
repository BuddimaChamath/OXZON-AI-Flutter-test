import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../providers/employee_provider.dart';
import 'widgets/employee_list.dart';
import 'widgets/search_bar.dart';
import 'widgets/filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    provider.searchEmployees(_searchController.text);
  }

  void _clearFilters() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    provider.clearFilters();
    _searchController.clear();
    setState(() {
      _showFilters = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          Consumer<EmployeeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  color: provider.hasActiveFilters && !_showFilters
                      ? AppColors.primary
                      : AppColors.onPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
            onSelected: (value) {
              switch (value) {
                case 'sort_name':
                  _sortEmployees('name');
                  break;
                case 'sort_date':
                  _sortEmployees('joiningDate');
                  break;
                case 'sort_department':
                  _sortEmployees('department');
                  break;
                case 'clear_filters':
                  _clearFilters();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 12),
                    Text('Sort by Name'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort_date',
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 12),
                    Text('Sort by Joining Date'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort_department',
                child: Row(
                  children: [
                    Icon(Icons.business),
                    SizedBox(width: 12),
                    Text('Sort by Department'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_filters',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 12),
                    Text('Clear Filters'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.employees.isEmpty) {
            return const LoadingWidget(message: 'Loading employees...');
          }

          if (provider.errorMessage.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SnackBarHelper.showError(context, provider.errorMessage);
              provider.clearError();
            });
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  controller: _searchController,
                  onChanged: (value) => provider.searchEmployees(value),
                  onClear: () {
                    _searchController.clear();
                    provider.searchEmployees('');
                  },
                ),
              ),

              // Filter Widget - ADDED THIS SECTION
              if (_showFilters) ...[
                const FilterWidget(),
                const SizedBox(height: 16),
              ],

              // Active Filters Indicator (when filters hidden but active)
              if (!_showFilters && provider.hasActiveFilters)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filters active (${provider.employees.length} results)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _clearFilters,
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              if (!_showFilters && provider.hasActiveFilters)
                const SizedBox(height: 16),

              // Employee List
              Expanded(
                child: provider.employees.isEmpty
                    ? _buildEmptyState()
                    : EmployeeList(
                        employees: provider.employees,
                        onEmployeeTap: (employee) {
                          context.pushNamed(
                            'employee-details',
                            extra: employee,
                          );
                        },
                        onEditTap: (employee) {
                          context.pushNamed(
                            'edit-employee',
                            extra: employee,
                          );
                        },
                        onDeleteTap: (employee) {
                          _showDeleteConfirmation(
                              context, employee.id, employee.name);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add-employee'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
      ),
    );
  }

  Widget _buildEmptyState() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    final hasFilters = provider.searchQuery.isNotEmpty ||
        provider.selectedDepartment.isNotEmpty ||
        provider.selectedRole.isNotEmpty ||
        provider.dateRangeStart != null ||
        provider.dateRangeEnd != null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.people_outline,
            size: 64,
            color: AppColors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? 'No employees match your filters'
                : AppStrings.noEmployeesFound,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your search or filter criteria'
                : 'Add your first employee to get started',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (hasFilters)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => context.pushNamed('add-employee'),
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
            ),
        ],
      ),
    );
  }

  // Store sort order in state to toggle correctly
  String _lastSortBy = '';
  bool _ascending = true;

  void _sortEmployees(String sortBy) {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    if (_lastSortBy == sortBy) {
      _ascending = !_ascending;
    } else {
      _ascending = true;
      _lastSortBy = sortBy;
    }
    provider.sortEmployees(sortBy, _ascending);

    SnackBarHelper.showInfo(
      context,
      'Sorted by ${sortBy.replaceAll('_', ' ')} (${_ascending ? 'A-Z' : 'Z-A'})',
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String employeeId, String employeeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete "$employeeName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final provider =
                  Provider.of<EmployeeProvider>(context, listen: false);
              final success = await provider.deleteEmployee(employeeId);
              if (success && context.mounted) {
                SnackBarHelper.showSuccess(
                    context, AppStrings.employeeDeletedSuccess);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
