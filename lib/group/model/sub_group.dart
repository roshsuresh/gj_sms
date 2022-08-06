class SubGroup{
  int? id;
  int? groupId;
  final String title;
  String? groupTitle;

  SubGroup({this.id, this.groupId,required this.title,this.groupTitle});
  factory SubGroup.fromMap(Map<String,dynamic> json)=>SubGroup(
      id: json['id'],
      groupId: json['groupId'],
      title: json['title'],
      groupTitle: json['groupTitle']
  );
  Map<String,dynamic> toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=this.id;
    data['groupId']=this.groupId;
    data['title']=this.title;
    data['groupTitle']=this.groupTitle;
    return data;
  }
}