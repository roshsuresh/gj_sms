
class GroupGettingModel {
  GroupGettingModel({
    required this.clientid,
    required this.groupdetails,
  });

  String clientid;
  GroupdetailsGetingModel groupdetails;

  factory GroupGettingModel.fromJson(Map<String, dynamic> json) => GroupGettingModel(
    clientid: json["clientid"],
    groupdetails: GroupdetailsGetingModel.fromJson(json["groupdetails"]),
  );

  Map<String, dynamic> toJson() => {
    "clientid": clientid,
    "groupdetails": groupdetails.toJson(),
  };
}

class GroupdetailsGetingModel {
  GroupdetailsGetingModel({
    required this.group,
    required this.subGroup,
    required this.contacts,
    required this.subGrpContacts,
  });

  List<GroupGetting> group;
  List<SubGrpGet> subGroup;
  List<ContactGettingModel> contacts;
  List<SubgroupGetting> subGrpContacts;

  factory GroupdetailsGetingModel.fromJson(Map<String, dynamic> json) => GroupdetailsGetingModel(
    group: List<GroupGetting>.from(json["group"].map((x) => GroupGetting.fromJson(x))),
    subGroup: List<SubGrpGet>.from(json["subGroup"].map((x) => SubGrpGet.fromJson(x))),
    contacts: List<ContactGettingModel>.from(json["contacts"].map((x) => ContactGettingModel.fromJson(x))),
    subGrpContacts: List<SubgroupGetting>.from(json["subGrpContacts"].map((x) => SubgroupGetting.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": List<dynamic>.from(group.map((x) => x.toJson())),
    "subGroup": List<dynamic>.from(subGroup.map((x) => x.toJson())),

    "subGrpContacts": List<dynamic>.from(subGrpContacts.map((x) => x.toJson())),
  };
}

class ContactGettingModel {
  ContactGettingModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.course,
  });

  String id;
  String name;
  String phone;
  String course;

  factory ContactGettingModel.fromJson(Map<String, dynamic> json) => ContactGettingModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    course: json["course"] == null ? null : json["course"],
  );


}

class GroupGetting {
  GroupGetting({
    required this.id,
    required this.title,
  });

  String id;
  String title;

  factory GroupGetting.fromJson(Map<String, dynamic> json) => GroupGetting(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
class SubGrpGet {
  SubGrpGet({
    required this.id,
    required this.groupId,
    required this.title,
  });

  String id;
  String groupId;
  String title;

  factory SubGrpGet.fromJson(Map<String, dynamic> json) => SubGrpGet(
    id: json["id"],
    groupId: json["groupId"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupId": groupId,
    "title": title,
  };
}

class SubgroupGetting {
  SubgroupGetting({
   required this.subcid,
   required this.subgrpid,
   required this.cid,
  });

  String subcid;
  String subgrpid;
  String cid;

  factory SubgroupGetting.fromJson(Map<String, dynamic> json) => SubgroupGetting(
    subcid: json["subcid"],
    subgrpid: json["subgrpid"],
    cid: json["cid"],
  );

  Map<String, dynamic> toJson() => {
    "subcid": subcid,
    "subgrpid": subgrpid,
    "cid": cid,
  };
}
