class SubGroup {
  int? id;
  int groupId;
  final String title;

  SubGroup(this.id, this.groupId, this.title);

  factory SubGroup.fromMap(json) {
    return SubGroup(
        json['id'],
        json['groupId'],
        json['title']
    );
  }

  Map<String, dynamic> toJSon() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['id'] = this.id;
    json['groupId'] = this.id;
    json['title'] = this.title;
    return json;
  }

}