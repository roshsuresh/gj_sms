
class GroupSync {
  GroupSync({
    required this.orgid,
    required this.groupdetails,
  });

  int orgid;
  List<Groupdetail> groupdetails;

  factory GroupSync.fromJson(Map<String, dynamic> json) => GroupSync(
    orgid: 0,
    groupdetails: List<Groupdetail>.from(json["groupdetails"].map((x) => Groupdetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orgid": orgid,
    "groupdetails": List<dynamic>.from(groupdetails.map((x) => x.toJson())),
  };
}

class Groupdetail {
  Groupdetail({
    required this.group,
    required this.subGroup,
    required this.contacts,
    required this.subGrpContacts,
  });

  List<GroupSyncModel> group;
  List<SubGroupSync> subGroup;
  List<ContactSync> contacts;
  List<SubGrpContactSync> subGrpContacts;

  factory Groupdetail.fromJson(Map<String, dynamic> json) => Groupdetail(
    group: List<GroupSyncModel>.from(json["group"].map((x) => GroupSyncModel.fromJson(x))),
    subGroup: List<SubGroupSync>.from(json["subGroup"].map((x) => SubGroupSync.fromJson(x))),
    contacts: List<ContactSync>.from(json["contacts"].map((x) => ContactSync.fromJson(x))),
    subGrpContacts: List<SubGrpContactSync>.from(json["subGrpContacts"].map((x) => SubGrpContactSync.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": List<dynamic>.from(group.map((x) => x.toJson())),
    "subGroup": List<dynamic>.from(subGroup.map((x) => x.toJson())),
    "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
    "subGrpContacts": List<dynamic>.from(subGrpContacts.map((x) => x.toJson())),
  };
}

class ContactSync {
  ContactSync({
    required this.id,
    required this.name,
    required this.phone,
    required this.course,
  });

  int id;
  String name;
  int phone;
  String course;

  factory ContactSync.fromJson(Map<String, dynamic> json) => ContactSync(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    course: json["course"] == null ? null : json["course"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "course": course == null ? null : course,
  };
}

class GroupSyncModel {
  GroupSyncModel({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory GroupSyncModel.fromJson(Map<String, dynamic> json) => GroupSyncModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class SubGroupSync {
  SubGroupSync({
    required this.id,
    required this.groupId,
    required this.title,
  });

  int id;
  int groupId;
  String title;

  factory SubGroupSync.fromJson(Map<String, dynamic> json) => SubGroupSync(
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

class SubGrpContactSync {
  SubGrpContactSync({
    required this.id,
    required this.subId,
    required this.contactId,
  });

  int id;
  String subId;
  String contactId;

  factory SubGrpContactSync.fromJson(Map<String, dynamic> json) => SubGrpContactSync(
    id: json["id"],
    subId: json["subId"],
    contactId: json["contactId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subId": subId,
    "contactId": contactId,
  };
}
