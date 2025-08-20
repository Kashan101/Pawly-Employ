import 'package:get/get.dart';

import '../../../../utils/library.dart';

class DurationListResponse {
  bool status;
  List<DurationListData> data;
  String message;

  DurationListResponse({
    this.status = false,
    this.data = const <DurationListData>[],
    this.message = "",
  });

  factory DurationListResponse.fromJson(Map<String, dynamic> json) {
    return DurationListResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<DurationListData>.from(json['data'].map((x) => DurationListData.fromJson(x))) : [],
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

class DurationListData {
  RxInt id;
  String duration;
  num price;
  String type;
  RxBool durationStatus;
  int createdBy;
  int updatedBy;
  int deletedBy;

  // For Training Type Duration List
  int typeId;
  num amount;

  // For Multiple Duration List Widget
  int index;
  int addDurationCount;
  TextEditingController? durationHourCont;
  FocusNode? durationHourFocus;
  TextEditingController? durationMinuteCont;
  FocusNode? durationMinuteFocus;
  TextEditingController? durationPriceCont;
  FocusNode? durationPriceFocus;

  String get fullDuration => '${durationHourCont!.text}:${durationMinuteCont!.text}';

  DurationListData({
    required this.id,
    this.duration = "",
    this.price = -1,
    this.type = "",
    required this.durationStatus,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.typeId = -1,
    this.amount = -1,
    this.index = -1,
    this.addDurationCount = -1,
    this.durationHourCont,
    this.durationHourFocus,
    this.durationMinuteCont,
    this.durationMinuteFocus,
    this.durationPriceCont,
    this.durationPriceFocus,
  });

  factory DurationListData.fromJson(Map<String, dynamic> json) {
    return DurationListData(
      id: json['id'] is int ? (json['id'] as int).obs : (-1).obs,
      duration: json['duration'] is String ? json['duration'] : "",
      price: json['price'] is num ? json['price'] : -1,
      type: json['type'] is String ? json['type'] : "",
      durationStatus: json['status'] is int ? (json['status'] == 1).obs : false.obs,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      typeId: json['type_id'] is int ? json['type_id'] : -1,
      amount: json['amount'] is num ? json['amount'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'price': price,
      'type': type,
      'status': durationStatus,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'type_id': typeId,
      'amount': amount,
    };
  }

  Map<String, dynamic> toJsonRequest() {
    return {
      "hours": durationHourCont?.text.trim(),
      "minutes": durationMinuteCont?.text.trim(),
      "amount": durationPriceCont?.text.trim(),
      "status": durationStatus.value ? "1" : "0",
    };
  }
}
