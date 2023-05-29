class Citymodel {
  String name = '';
  Citymodel({required this.name});
  Citymodel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
