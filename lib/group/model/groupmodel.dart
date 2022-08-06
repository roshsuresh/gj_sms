
class GroupModel{
    int? id;
    final String title;
    bool expand=false;
    GroupModel(this.id, this.title,{required this.expand});
    factory GroupModel.fromMap(Map<String,dynamic> json)=>GroupModel(
          json['id'],
        json['title'], expand: false
    );
    Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id']=this.id;
      data['title']=this.title;
      return data;
    }
}