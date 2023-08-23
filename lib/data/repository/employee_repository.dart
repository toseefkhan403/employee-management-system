import 'package:employee_management_system/data/models/employee.dart';
import 'package:localstore/localstore.dart';

class EmployeeRepository {
  final store = Localstore.instance;

  Future<List<Employee>> getAllEmployees() async {
    final data = await store.collection('employees').get();

    List<Employee> employeeList = [];

    if (data != null) {
      data.forEach((key, value) {
        employeeList.add(Employee.fromMap(value));
      });
    }

    return employeeList;
  }

  Future<void> addEmployee(Employee employee) async {
    await store
        .collection('employees')
        .doc(employee.id)
        .set(employee.toMap());
  }

  Future<void> updateEmployee(Employee employee) async {
    await store
        .collection('employees')
        .doc(employee.id)
        .set(employee.toMap());
  }

  Future<void> deleteEmployee(String id) async {
    await store.collection('employees').doc(id).delete();
  }
}
