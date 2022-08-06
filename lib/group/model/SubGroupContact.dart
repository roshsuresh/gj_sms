
class SubGrpContacts{
  int? id;
  final int subId;
  final int contactId;

  SubGrpContacts({this.id,required this.subId,required this.contactId});

  factory SubGrpContacts.fromMap(Map<String,dynamic> json){
    return SubGrpContacts(
        id: json['id'],
        subId: json['subId'],
        contactId: json['contactId']
    );
  }
  Map<String,dynamic> toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subId'] = this.subId;
    data['contactId'] = this.contactId;
    return data;
  }
}