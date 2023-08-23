// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:employee_management_system/data/models/role.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final Role role;
  final DateTime startDate;
  final DateTime? endDate;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'role': role.index,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as String,
      name: map['name'] as String,
      role: Role.values[map['role']],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      role,
      startDate,
      endDate,
    ];
  }

  @override
  bool get stringify => true;
}
