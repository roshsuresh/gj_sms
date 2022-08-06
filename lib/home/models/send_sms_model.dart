import 'package:flutter_contacts/contact.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';

class SendSmsModel {
  SendSmsModel({
   required this.message,
    required this.id,
    required this.pwd,
    required this.provider,
    required this.senderid,
    required this.orgid,
    required this.clientId,
    required this.contacts,
  });

  String message;
  String id;
  String pwd;
  String provider;
  String senderid;
  int clientId;
  int orgid;
  List<ContactModel> contacts;
  factory SendSmsModel.fromJson(Map<String, dynamic> json) => SendSmsModel(
    message: json["message"],
    id: json["id"],
    pwd: json["pwd"],
    provider: json["provider"],
    senderid: json["senderid"],
    orgid: json["orgid"],

    contacts: List<ContactModel>.from(json["contacts"].map((x) => ContactModel.fromMap(x))), clientId: json['clientid'],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id,
    "pwd": pwd,
    "provider": provider,
    "senderid": senderid,
    "orgid": orgid,
    "clientid":clientId,
    "contacts": List<dynamic>.from(contacts.map((x) => x.toMap())),
  };
}


