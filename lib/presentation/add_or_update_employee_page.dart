import 'package:employee_management_system/data/models/employee.dart';
import 'package:employee_management_system/data/models/role.dart';
import 'package:employee_management_system/logic/cubit/employee_cubit.dart';
import 'package:employee_management_system/presentation/date_picker_dialog.dart'
    as date_picker;
import 'package:employee_management_system/presentation/select_role_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:uuid/uuid.dart';

import 'helper_widgets.dart';

class AddOrUpdateEmployeePage extends StatefulWidget {
  final String title;
  final Employee? employee;

  const AddOrUpdateEmployeePage(
      {required this.title, this.employee, super.key});

  @override
  State<AddOrUpdateEmployeePage> createState() =>
      _AddOrUpdateEmployeePageState();
}

class _AddOrUpdateEmployeePageState extends State<AddOrUpdateEmployeePage> {
  final TextEditingController nameController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime? selectedEndDate;
  Role? selectedRole;

  @override
  void initState() {
    initEmployeeDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: widget.employee != null ? deleteButton() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  textFieldName(),
                  roleSelector(),
                  // Date picking row
                  Row(
                    children: [
                      Expanded(
                        child: startingDateSelector(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          MaterialIcons.arrow_right_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: endDateSelector(),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            const Divider(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton(context),
                // Save Button
                saveButton(
                  context,
                  () {
                    if (!verifyInputs(
                        nameController.text.trim(), selectedRole)) {
                      return;
                    }
                    widget.employee == null ? save() : update();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  textFieldName() => decoratedContainer(
        MaterialIcons.person_outline,
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Employee name'),
        ),
      );

  roleSelector() => GestureDetector(
        onTap: () async {
          final result = await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              builder: (c) => const SelectRoleBottomSheet());
          if (result != null) {
            setState(() {
              selectedRole = result;
            });
          }
        },
        child: decoratedContainer(
          MaterialIcons.work_outline,
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedRole == null
                      ? "Select Role"
                      : selectedRole!.getRoleName(),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      );

  startingDateSelector() => GestureDetector(
        onTap: () async {
          final selectedDate = await showDialog(
              context: context,
              builder: (c) => const date_picker.DatePickerDialog(
                    isSelectingEndDate: false,
                  ));
          if (selectedDate != null) {
            selectedStartDate = selectedDate;
            setState(() {});
          }
        },
        child: decoratedContainer(
          MaterialIcons.event,
          Text(
            isToday(selectedStartDate)
                ? "Today"
                : formatDateTime(selectedStartDate),
          ),
        ),
      );

  endDateSelector() => GestureDetector(
        onTap: () async {
          final selectedDate = await showDialog(
              context: context,
              builder: (c) => date_picker.DatePickerDialog(
                    isSelectingEndDate: true,
                    startDate: selectedStartDate,
                  ));

          selectedEndDate = selectedDate;
          setState(() {});
        },
        child: decoratedContainer(
          MaterialIcons.event,
          Text(
            selectedEndDate == null
                ? "No date"
                : (isToday(selectedEndDate!)
                    ? "Today"
                    : formatDateTime(selectedEndDate!)),
          ),
        ),
      );

  decoratedContainer(IconData iconData, Widget child) => Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                width: 1,
                color: Colors.grey.withOpacity(0.5),
                style: BorderStyle.solid)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                iconData,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      );

  bool verifyInputs(String name, Role? selectedRole) {
    if (name.length < 4) {
      showSnackBar(context, 'Employee name can\'t be less than 4 characters');
      return false;
    }

    if (name.length > 40) {
      showSnackBar(context, 'Employee name can\'t be more than 40 characters');
      return false;
    }

    final namePattern = RegExp(r"^[A-Za-z\s]+$");
    if (!namePattern.hasMatch(name)) {
      showSnackBar(context, 'Employee name can only contain English alphabets');
      return false;
    }

    if (selectedRole == null) {
      showSnackBar(context, 'Please select a role');
      return false;
    }

    return true;
  }

  save() {
    final name = nameController.text.trim();
    const uuid = Uuid();
    final id = uuid.v4();

    final Employee dbEmployee = Employee(
        id: id,
        name: name,
        role: selectedRole!,
        startDate: selectedStartDate,
        endDate: selectedEndDate);

    context.read<EmployeeCubit>().addEmployee(dbEmployee);
    showSnackBar(context, 'Employee added successfully');
  }

  update() {
    final name = nameController.text.trim();

    final Employee dbEmployee = Employee(
        id: widget.employee!.id,
        name: name,
        role: selectedRole!,
        startDate: selectedStartDate,
        endDate: selectedEndDate);

    context.read<EmployeeCubit>().updateEmployee(dbEmployee);
    showSnackBar(context, "Employee details updated successfully");
  }

  initEmployeeDetails() {
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      selectedRole = widget.employee!.role;
      selectedStartDate = widget.employee!.startDate;
      selectedEndDate = widget.employee!.endDate;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  deleteButton() {
    final employeeBloc = context.read<EmployeeCubit>();

    return [
      IconButton(
        onPressed: () {
          final employee = widget.employee!;
          employeeBloc.deleteEmployee(employee.id);
          showSnackBar(context, 'Employee ${employee.name} deleted');
          Navigator.pop(context);
        },
        icon: const Icon(
          FontAwesome.trash_o,
          color: Colors.white,
        ),
      )
    ];
  }

  bool isToday(DateTime selectedDate) {
    DateTime date1 = DateTime.now();
    DateTime date2 = selectedDate;

    DateTime date1DateOnly = DateTime(date1.year, date1.month, date1.day);
    DateTime date2DateOnly = DateTime(date2.year, date2.month, date2.day);

    return date1DateOnly.compareTo(date2DateOnly) == 0;
  }
}
