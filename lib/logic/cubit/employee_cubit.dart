import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/employee.dart';
import '../../data/repository/employee_repository.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository repository = EmployeeRepository();

  EmployeeCubit() : super(const EmployeeState([]));

  Future<void> loadEmployees() async {
    final employees = await repository.getAllEmployees();
    print("List of employees: $employees");
    emit(EmployeeState(employees));
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await repository.addEmployee(employee);
      emit(state.copyWith(employees: [...state.employees, employee]));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> insertEmployee(Employee employee, int index) async {
    try {
      await repository.addEmployee(employee);
      final updatedEmployees = [...state.employees];
      updatedEmployees.insert(index, employee);
      emit(state.copyWith(employees: updatedEmployees));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateEmployee(Employee updatedEmployee) async {
    try {
      await repository.updateEmployee(updatedEmployee);
      final updatedEmployees = state.employees
          .map((employee) =>
              employee.id == updatedEmployee.id ? updatedEmployee : employee)
          .toList();
      emit(state.copyWith(employees: updatedEmployees));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await repository.deleteEmployee(id);
      final updatedEmployees =
          state.employees.where((employee) => employee.id != id).toList();
      emit(state.copyWith(employees: updatedEmployees));
    } catch (e) {
      print(e.toString());
    }
  }
}
