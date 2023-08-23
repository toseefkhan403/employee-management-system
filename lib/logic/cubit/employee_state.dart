part of 'employee_cubit.dart';

class EmployeeState extends Equatable {
  final List<Employee> employees;

  const EmployeeState(this.employees);

  EmployeeState copyWith({List<Employee>? employees}) {
    return EmployeeState(employees ?? this.employees);
  }

  @override
  List<Object> get props => [employees];
}
