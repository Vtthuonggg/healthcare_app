// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: json['role'] == null
      ? null
      : Role.fromJson(json['role'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : Status.fromJson(json['status'] as Map<String, dynamic>),
  photo: json['photo'] == null
      ? null
      : Photo.fromJson(json['photo'] as Map<String, dynamic>),
  idDepartment: (json['id_department'] as num?)?.toInt(),
  department: json['department'] == null
      ? null
      : Department.fromJson(json['department'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
  'status': instance.status,
  'photo': instance.photo,
  'id_department': instance.idDepartment,
  'department': instance.department,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_Role _$RoleFromJson(Map<String, dynamic> json) => _Role(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  roleName: json['role_name'] as String,
);

Map<String, dynamic> _$RoleToJson(_Role instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role_name': instance.roleName,
};

_Status _$StatusFromJson(Map<String, dynamic> json) =>
    _Status(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$StatusToJson(_Status instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_Photo _$PhotoFromJson(Map<String, dynamic> json) =>
    _Photo(id: (json['id'] as num).toInt(), path: json['path'] as String);

Map<String, dynamic> _$PhotoToJson(_Photo instance) => <String, dynamic>{
  'id': instance.id,
  'path': instance.path,
};

_Department _$DepartmentFromJson(Map<String, dynamic> json) => _Department(
  idDepartment: (json['id_department'] as num).toInt(),
  name: json['name'] as String,
  departmentCode: json['department_code'] as String,
  branchId: (json['branch_id'] as num).toInt(),
);

Map<String, dynamic> _$DepartmentToJson(_Department instance) =>
    <String, dynamic>{
      'id_department': instance.idDepartment,
      'name': instance.name,
      'department_code': instance.departmentCode,
      'branch_id': instance.branchId,
    };
