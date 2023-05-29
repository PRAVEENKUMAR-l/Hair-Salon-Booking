class ServiceModel {
  String name = '', docId = '';
  double price = 0.0;
  ServiceModel({required this.name, required this.price, required this.docId});
  ServiceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'] == null ? 0 : double.parse(json['price'].toString());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
