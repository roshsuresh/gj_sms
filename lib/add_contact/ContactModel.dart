class ContactModel {
  int? id;
  final String? name;
  final int? phoneNum;
  final String? course;
  bool? selected = false;

  ContactModel(
      {this.id,
      required this.name,
      required this.phoneNum,
      this.course,
      this.selected});
  factory ContactModel.fromMap(Map<String, dynamic> json) {
    return ContactModel(
        id: json['id'],
        name: json['name'],
        phoneNum: json['phone'],
        course: json['course']);
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phoneNum;
    data['course'] = this.course;
    return data;
  }
}
