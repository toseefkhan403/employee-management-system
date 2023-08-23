import 'package:employee_management_system/logic/cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/employee_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeCubit>(
      create: (context) => EmployeeCubit(),
      child: MaterialApp(
        title: 'Employee Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const EmployeeListPage(title: 'Employee List'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
