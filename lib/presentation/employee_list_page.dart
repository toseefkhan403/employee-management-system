import 'package:employee_management_system/data/models/role.dart';
import 'package:employee_management_system/logic/cubit/employee_cubit.dart';
import 'package:employee_management_system/presentation/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../data/models/employee.dart';
import 'add_or_update_employee_page.dart';

class EmployeeListPage extends StatefulWidget {
  final String title;

  const EmployeeListPage({required this.title, super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  @override
  void initState() {
    context.read<EmployeeCubit>().loadEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employeeBloc = context.read<EmployeeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state.employees.isNotEmpty) {
            final employees = state.employees;
            List<Employee> currentEmployees = employees
                .where((employee) => employee.endDate == null)
                .toList();
            List<Employee> previousEmployees = employees
                .where((employee) => employee.endDate != null)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      currentEmployees.isNotEmpty
                          ? listHeading("Current employees")
                          : Container(),
                      employeeListWidget(
                          currentEmployees, employeeBloc, context),
                      previousEmployees.isNotEmpty
                          ? listHeading("Previous employees")
                          : Container(),
                      employeeListWidget(
                          previousEmployees, employeeBloc, context),
                    ],
                  ),
                ),

                // Swipe left to delete
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  color: Colors.grey.withOpacity(0.2),
                  child: const Text(
                    "Swipe left to delete",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Image.asset("assets/images/notFound.png"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => const AddOrUpdateEmployeePage(
                  title: "Add Employee Details")));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  employeeListWidget(
          List<Employee> employeeList, EmployeeCubit employeeBloc, context) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employeeList.length,
        itemBuilder: (context, index) {
          final employee = employeeList[index];
          return Dismissible(
            key: Key(employee.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                FontAwesome.trash_o,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              employeeBloc.deleteEmployee(employee.id);

              showSnackBar(context, 'Employee ${employee.name} deleted',
                  actions: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      employeeBloc.insertEmployee(employee, index);
                    },
                  ));
            },
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => AddOrUpdateEmployeePage(
                            title: "Edit Employee Details",
                            employee: employee)));
              },
              title: Text(
                employee.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(employee.role.getRoleName()),
                  ),
                  employee.endDate != null
                      ? Text(
                          "${formatDateTime(employee.startDate)} - ${formatDateTime(employee.endDate!)}",
                          style: const TextStyle(fontSize: 12),
                        )
                      : Text(
                          "From ${formatDateTime(employee.startDate)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
      );

  listHeading(String title) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        color: Colors.grey.withOpacity(0.2),
        child: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      );
}
