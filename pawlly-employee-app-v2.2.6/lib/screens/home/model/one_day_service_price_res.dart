class OneDayServicePriceRes {
  bool status;
  OneDayServicePriceData data;

  OneDayServicePriceRes({
    this.status = false,
    required this.data,
  });

  factory OneDayServicePriceRes.fromJson(Map<String, dynamic> json) {
    return OneDayServicePriceRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? OneDayServicePriceData.fromJson(json['data']) : OneDayServicePriceData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class OneDayServicePriceData {
  int userId;
  num amount;
  String type;

  OneDayServicePriceData({
    this.userId = -1,
    this.amount = -1,
    this.type = "",
  });

  factory OneDayServicePriceData.fromJson(Map<String, dynamic> json) {
    return OneDayServicePriceData(
      userId: json['user_id'] is int ? json['user_id'] : -1,
      amount: json['amount'] is num ? json['amount'] : -1,
      type: json['type'] is String ? json['type'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'type': type,
    };
  }
}
