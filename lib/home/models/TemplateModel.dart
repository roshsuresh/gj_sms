class TemplateModel{
  String templatename;
  String templatecontent;
  String contentcount;
  String? editvariables;


  TemplateModel({required this.templatename, required this.templatecontent, required this.contentcount,
      required this.editvariables});

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
        templatename: json['templatename'],
        templatecontent:  json['templatecontent'],
        contentcount: json['contentcount'],
        editvariables: json['editvariables']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['templatename'] = this.templatename;
    data['templatecontent'] = this.templatecontent;
    data['contentcount'] = this.contentcount;
    data['editvariables'] = this.editvariables;
    return data;
  }

}