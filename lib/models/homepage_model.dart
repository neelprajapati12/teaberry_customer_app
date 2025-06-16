class HomePageData {
  int? id;
  int? storeId;
  String? storeName;
  String? productName;
  int? quantity;
  List<SubProducts>? subProducts;
  String? createdAt;
  String? updatedAt;

  HomePageData({
    this.id,
    this.storeId,
    this.storeName,
    this.productName,
    this.quantity,
    this.subProducts,
    this.createdAt,
    this.updatedAt,
  });

  HomePageData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    storeId = json["storeId"];
    storeName = json["storeName"];
    productName = json["productName"];
    quantity = json["quantity"];
    subProducts =
        json["subProducts"] == null
            ? null
            : (json["subProducts"] as List)
                .map((e) => SubProducts.fromJson(e))
                .toList();
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["storeId"] = storeId;
    _data["storeName"] = storeName;
    _data["productName"] = productName;
    _data["quantity"] = quantity;
    if (subProducts != null) {
      _data["subProducts"] = subProducts?.map((e) => e.toJson()).toList();
    }
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class SubProducts {
  int? id;
  String? name;
  dynamic photoUrl;
  double? price;
  int? quantity;

  SubProducts({this.id, this.name, this.photoUrl, this.price, this.quantity});

  SubProducts.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["price"] = price;
    _data["quantity"] = quantity;
    return _data;
  }
}
