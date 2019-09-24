class ExpositionModel {
  int id;
  String name;
  String creationDate;
  String description;

  ExpositionModel({this.id, this.name, this.creationDate, this.description});

  ExpositionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creationDate = json['creation_date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['creation_date'] = this.creationDate;
    data['description'] = this.description;
    return data;
  }
}
