import 'package:get/get.dart';

class FacilityListResponse {
  bool status;
  List<FacilityListData> data;
  String message;

  FacilityListResponse({
    this.status = false,
    this.data = const <FacilityListData>[],
    this.message = "",
  });

  factory FacilityListResponse.fromJson(Map<String, dynamic> json) {
    return FacilityListResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<FacilityListData>.from(json['data'].map((x) => FacilityListData.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class FacilityListData {
  RxInt id;
  String name;
  String description;
  RxBool status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  FacilityListData({
    required this.id,
    this.name = "",
    this.description = "",
    required this.status,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory FacilityListData.fromJson(Map<String, dynamic> json) {
    return FacilityListData(
      id: json['id'] is int ? (json['id'] as int).obs : (-1).obs,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int ? (json['status'] == 1).obs : false.obs,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
