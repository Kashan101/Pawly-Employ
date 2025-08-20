import 'package:get/get.dart';
import '../../../../../../utils/library.dart';

class TrainingTypeListResponse {
  bool status;
  List<TrainingTypeListData> data;
  String message;

  TrainingTypeListResponse({
    this.status = false,
    this.data = const <TrainingTypeListData>[],
    this.message = "",
  });

  factory TrainingTypeListResponse.fromJson(Map<String, dynamic> json) {
    return TrainingTypeListResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<TrainingTypeListData>.from(json['data'].map((x) => TrainingTypeListData.fromJson(x))) : [],
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

class TrainingTypeListData {
  RxInt id;
  String name;
  String slug;
  String description;
  RxBool status;
  List<DurationListData> duration;
  int createdBy;
  int updatedBy;
  int deletedBy;

  TrainingTypeListData({
    required this.id,
    this.name = "",
    this.slug = "",
    this.description = "",
    required this.status,
    this.duration = const <DurationListData>[],
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
  });

  factory TrainingTypeListData.fromJson(Map<String, dynamic> json) {
    return TrainingTypeListData(
      id: json['id'] is int ? (json['id'] as int).obs : (-1).obs,
      name: json['name'] is String ? json['name'] : "",
      slug: json['slug'] is String ? json['slug'] : "",
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int ? (json['status'] == 1).obs : false.obs,
      duration: json['duration'] is List ? List<DurationListData>.from(json['duration'].map((x) => DurationListData.fromJson(x))) : [],
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['updated_by'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'status': status,
      'duration': duration.map((e) => e.toJson()).toList(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
    };
  }
}
