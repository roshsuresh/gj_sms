class SmsLogModel {
  SmsLogModel({
    required this.visible,
    required this.data,
    required this.details,
  });
  bool visible=false;
  Data? data;
  List<Detail> details;

  factory SmsLogModel.fromJson(Map<String, dynamic> json) => SmsLogModel(
    data: Data.fromJson(json["data"]),
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))), visible: false,
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    required this.msg,
    required this.datetime,
    required this.success,
    required this.fail,
  });

  String msg;
  String datetime;
  int success;
  int fail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    msg: json["msg"],
    datetime: json["datetime"],
    success: json["success"],
    fail: json["fail"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "datetime": datetime,
    "success": success,
    "fail": fail,
  };
}

class Detail {
  Detail({
    required this.name,
    this.course,
    required this.phone,
    required this.status,
  });

  String name;
  dynamic course;
  String phone;
  String status;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    name: json["name"],
    course: json["course"],
    phone: json["phone"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "course": course,
    "phone": phone,
    "status": status,
  };
}
