class ProductionCountries{
  String code;
  String name;

  ProductionCountries({required this.code, required this.name});

  factory ProductionCountries.fromJson(Map<String, dynamic> json){
    return ProductionCountries(code: json['iso_3166_1'], name: json['name']);
  }
}