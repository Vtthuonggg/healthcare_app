import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required int id,
    required String firstName,
    required String lastName,
    Role? role,
    Status? status,
    Photo? photo,
    @JsonKey(name: 'id_department') int? idDepartment,
    Department? department,
    String? createdAt,
    String? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get fullName => '$firstName $lastName';
}

@freezed
abstract class Role with _$Role {
  const factory Role({
    required int id,
    required String name,
    @JsonKey(name: 'role_name') required String roleName,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

@freezed
abstract class Status with _$Status {
  const factory Status({required int id, required String name}) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}

@freezed
abstract class Photo with _$Photo {
  const factory Photo({required int id, required String path}) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@freezed
abstract class Department with _$Department {
  const factory Department({
    @JsonKey(name: 'id_department') required int idDepartment,
    required String name,
    @JsonKey(name: 'department_code') required String departmentCode,
    @JsonKey(name: 'branch_id') required int branchId,
  }) = _Department;

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);
}
