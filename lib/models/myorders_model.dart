class MyOrdersModel {
  num? id;
  Customer? customer;
  Store1? store;
  List<Items>? items;
  num? totalPrice;
  num? originalPrice;
  num? discountAmount;
  dynamic discountPercentage;
  num? orderCount;
  bool? discountApplied;
  num? ordersUntilNextDiscount;
  String? status;
  String? address;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;
  num? cgstRate;
  num? sgstRate;
  num? cgstAmount;
  num? sgstAmount;
  num? totalTax;
  num? priceAfterTax;

  MyOrdersModel({
    this.id,
    this.customer,
    this.store,
    this.items,
    this.totalPrice,
    this.originalPrice,
    this.discountAmount,
    this.discountPercentage,
    this.orderCount,
    this.discountApplied,
    this.ordersUntilNextDiscount,
    this.status,
    this.address,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.cgstRate,
    this.sgstRate,
    this.cgstAmount,
    this.sgstAmount,
    this.totalTax,
    this.priceAfterTax,
  });

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    customer =
        json["customer"] == null ? null : Customer.fromJson(json["customer"]);
    store = json["store"] == null ? null : Store1.fromJson(json["store"]);
    items =
        json["items"] == null
            ? null
            : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    totalPrice = json["totalPrice"];
    originalPrice = json["originalPrice"];
    discountAmount = json["discountAmount"];
    discountPercentage = json["discountPercentage"];
    orderCount = json["orderCount"];
    discountApplied = json["discountApplied"];
    ordersUntilNextDiscount = json["ordersUntilNextDiscount"];
    status = json["status"];
    address = json["address"];
    paymentMethod = json["paymentMethod"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    cgstRate = json["cgstRate"];
    sgstRate = json["sgstRate"];
    cgstAmount = json["cgstAmount"];
    sgstAmount = json["sgstAmount"];
    totalTax = json["totalTax"];
    priceAfterTax = json["priceAfterTax"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (customer != null) {
      _data["customer"] = customer?.toJson();
    }
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    if (items != null) {
      _data["items"] = items?.map((e) => e.toJson()).toList();
    }
    _data["totalPrice"] = totalPrice;
    _data["originalPrice"] = originalPrice;
    _data["discountAmount"] = discountAmount;
    _data["discountPercentage"] = discountPercentage;
    _data["orderCount"] = orderCount;
    _data["discountApplied"] = discountApplied;
    _data["ordersUntilNextDiscount"] = ordersUntilNextDiscount;
    _data["status"] = status;
    _data["address"] = address;
    _data["paymentMethod"] = paymentMethod;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["cgstRate"] = cgstRate;
    _data["sgstRate"] = sgstRate;
    _data["cgstAmount"] = cgstAmount;
    _data["sgstAmount"] = sgstAmount;
    _data["totalTax"] = totalTax;
    _data["priceAfterTax"] = priceAfterTax;
    return _data;
  }
}

class Items {
  num? id;
  num? productId;
  num? subProductId;
  num? quantity;
  num? price;

  Items({
    this.id,
    this.productId,
    this.subProductId,
    this.quantity,
    this.price,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    productId = json["productId"];
    subProductId = json["subProductId"];
    quantity = json["quantity"];
    price = json["price"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["productId"] = productId;
    _data["subProductId"] = subProductId;
    _data["quantity"] = quantity;
    _data["price"] = price;
    return _data;
  }
}

class Store1 {
  num? id;
  String? name;
  String? photoUrl;
  String? location;
  dynamic user;
  List<Inventories1>? inventories;
  Admin? admin;
  String? status;
  String? createdAt;
  String? updatedAt;

  Store1({
    this.id,
    this.name,
    this.photoUrl,
    this.location,
    this.user,
    this.inventories,
    this.admin,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Store1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    location = json["location"];
    user = json["user"];
    inventories =
        json["inventories"] == null
            ? null
            : (json["inventories"] as List)
                .map((e) => Inventories1.fromJson(e))
                .toList();
    admin = json["admin"] == null ? null : Admin.fromJson(json["admin"]);
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["location"] = location;
    _data["user"] = user;
    if (inventories != null) {
      _data["inventories"] = inventories?.map((e) => e.toJson()).toList();
    }
    if (admin != null) {
      _data["admin"] = admin?.toJson();
    }
    _data["status"] = status;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class Admin {
  num? id;
  String? name;
  String? email;
  String? mobile;
  dynamic address;
  List<String>? roles;
  String? status;
  dynamic otp;
  dynamic otpExpiryTime;
  String? photoUrl;
  String? aadharFrontUrl;
  String? aadharBackUrl;
  String? referralCode;
  dynamic referredBy;
  bool? referralCodeActive;
  num? walletBalance;
  String? createdAt;
  String? updatedAt;
  String? lastLogin;
  Store2? store;
  dynamic referredByDeliveryBoy;
  dynamic referredByDeliveryBoyId;
  num? customersOnboarded;

  Admin({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.roles,
    this.status,
    this.otp,
    this.otpExpiryTime,
    this.photoUrl,
    this.aadharFrontUrl,
    this.aadharBackUrl,
    this.referralCode,
    this.referredBy,
    this.referralCodeActive,
    this.walletBalance,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.store,
    this.referredByDeliveryBoy,
    this.referredByDeliveryBoyId,
    this.customersOnboarded,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    mobile = json["mobile"];
    address = json["address"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    status = json["status"];
    otp = json["otp"];
    otpExpiryTime = json["otpExpiryTime"];
    photoUrl = json["photoUrl"];
    aadharFrontUrl = json["aadharFrontUrl"];
    aadharBackUrl = json["aadharBackUrl"];
    referralCode = json["referralCode"];
    referredBy = json["referredBy"];
    referralCodeActive = json["referralCodeActive"];
    walletBalance = json["walletBalance"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    lastLogin = json["lastLogin"];
    store = json["store"] == null ? null : Store2.fromJson(json["store"]);
    referredByDeliveryBoy = json["referredByDeliveryBoy"];
    referredByDeliveryBoyId = json["referredByDeliveryBoyId"];
    customersOnboarded = json["customersOnboarded"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["mobile"] = mobile;
    _data["address"] = address;
    if (roles != null) {
      _data["roles"] = roles;
    }
    _data["status"] = status;
    _data["otp"] = otp;
    _data["otpExpiryTime"] = otpExpiryTime;
    _data["photoUrl"] = photoUrl;
    _data["aadharFrontUrl"] = aadharFrontUrl;
    _data["aadharBackUrl"] = aadharBackUrl;
    _data["referralCode"] = referralCode;
    _data["referredBy"] = referredBy;
    _data["referralCodeActive"] = referralCodeActive;
    _data["walletBalance"] = walletBalance;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["lastLogin"] = lastLogin;
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    _data["referredByDeliveryBoy"] = referredByDeliveryBoy;
    _data["referredByDeliveryBoyId"] = referredByDeliveryBoyId;
    _data["customersOnboarded"] = customersOnboarded;
    return _data;
  }
}

class Store2 {
  num? id;
  String? name;
  String? photoUrl;
  String? location;
  dynamic user;
  List<Inventories2>? inventories;
  String? status;
  String? createdAt;
  String? updatedAt;

  Store2({
    this.id,
    this.name,
    this.photoUrl,
    this.location,
    this.user,
    this.inventories,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Store2.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    location = json["location"];
    user = json["user"];
    inventories =
        json["inventories"] == null
            ? null
            : (json["inventories"] as List)
                .map((e) => Inventories2.fromJson(e))
                .toList();
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["location"] = location;
    _data["user"] = user;
    if (inventories != null) {
      _data["inventories"] = inventories?.map((e) => e.toJson()).toList();
    }
    _data["status"] = status;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class Inventories2 {
  num? id;
  String? name;
  num? quantity;
  dynamic photoUrl;
  List<SubProducts2>? subProducts;
  String? createdAt;
  String? updatedAt;

  Inventories2({
    this.id,
    this.name,
    this.quantity,
    this.photoUrl,
    this.subProducts,
    this.createdAt,
    this.updatedAt,
  });

  Inventories2.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    quantity = json["quantity"];
    photoUrl = json["photoUrl"];
    subProducts =
        json["subProducts"] == null
            ? null
            : (json["subProducts"] as List)
                .map((e) => SubProducts2.fromJson(e))
                .toList();
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["quantity"] = quantity;
    _data["photoUrl"] = photoUrl;
    if (subProducts != null) {
      _data["subProducts"] = subProducts?.map((e) => e.toJson()).toList();
    }
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class SubProducts2 {
  num? id;
  String? name;
  String? photoUrl;
  String? description;
  num? price;
  num? quantity;

  SubProducts2({
    this.id,
    this.name,
    this.photoUrl,
    this.description,
    this.price,
    this.quantity,
  });

  SubProducts2.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    description = json["description"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["description"] = description;
    _data["price"] = price;
    _data["quantity"] = quantity;
    return _data;
  }
}

class Inventories1 {
  num? id;
  String? name;
  num? quantity;
  dynamic photoUrl;
  List<SubProducts1>? subProducts;
  String? createdAt;
  String? updatedAt;

  Inventories1({
    this.id,
    this.name,
    this.quantity,
    this.photoUrl,
    this.subProducts,
    this.createdAt,
    this.updatedAt,
  });

  Inventories1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    quantity = json["quantity"];
    photoUrl = json["photoUrl"];
    subProducts =
        json["subProducts"] == null
            ? null
            : (json["subProducts"] as List)
                .map((e) => SubProducts1.fromJson(e))
                .toList();
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["quantity"] = quantity;
    _data["photoUrl"] = photoUrl;
    if (subProducts != null) {
      _data["subProducts"] = subProducts?.map((e) => e.toJson()).toList();
    }
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class SubProducts1 {
  num? id;
  String? name;
  String? photoUrl;
  String? description;
  num? price;
  num? quantity;

  SubProducts1({
    this.id,
    this.name,
    this.photoUrl,
    this.description,
    this.price,
    this.quantity,
  });

  SubProducts1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    description = json["description"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["description"] = description;
    _data["price"] = price;
    _data["quantity"] = quantity;
    return _data;
  }
}

class Customer {
  num? id;
  String? name;
  String? email;
  String? mobile;
  String? address;
  List<String>? roles;
  String? status;
  dynamic otp;
  dynamic otpExpiryTime;
  dynamic photoUrl;
  dynamic aadharFrontUrl;
  dynamic aadharBackUrl;
  String? referralCode;
  dynamic referredBy;
  bool? referralCodeActive;
  num? walletBalance;
  String? createdAt;
  String? updatedAt;
  String? lastLogin;
  Store? store;
  List<dynamic>? stores;
  dynamic referredByDeliveryBoy;
  dynamic referredByDeliveryBoyId;
  num? customersOnboarded;

  Customer({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.roles,
    this.status,
    this.otp,
    this.otpExpiryTime,
    this.photoUrl,
    this.aadharFrontUrl,
    this.aadharBackUrl,
    this.referralCode,
    this.referredBy,
    this.referralCodeActive,
    this.walletBalance,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.store,
    this.stores,
    this.referredByDeliveryBoy,
    this.referredByDeliveryBoyId,
    this.customersOnboarded,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    mobile = json["mobile"];
    address = json["address"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    status = json["status"];
    otp = json["otp"];
    otpExpiryTime = json["otpExpiryTime"];
    photoUrl = json["photoUrl"];
    aadharFrontUrl = json["aadharFrontUrl"];
    aadharBackUrl = json["aadharBackUrl"];
    referralCode = json["referralCode"];
    referredBy = json["referredBy"];
    referralCodeActive = json["referralCodeActive"];
    walletBalance = json["walletBalance"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    lastLogin = json["lastLogin"];
    store = json["store"] == null ? null : Store.fromJson(json["store"]);
    stores = json["stores"] ?? [];
    referredByDeliveryBoy = json["referredByDeliveryBoy"];
    referredByDeliveryBoyId = json["referredByDeliveryBoyId"];
    customersOnboarded = json["customersOnboarded"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["mobile"] = mobile;
    _data["address"] = address;
    if (roles != null) {
      _data["roles"] = roles;
    }
    _data["status"] = status;
    _data["otp"] = otp;
    _data["otpExpiryTime"] = otpExpiryTime;
    _data["photoUrl"] = photoUrl;
    _data["aadharFrontUrl"] = aadharFrontUrl;
    _data["aadharBackUrl"] = aadharBackUrl;
    _data["referralCode"] = referralCode;
    _data["referredBy"] = referredBy;
    _data["referralCodeActive"] = referralCodeActive;
    _data["walletBalance"] = walletBalance;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["lastLogin"] = lastLogin;
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    if (stores != null) {
      _data["stores"] = stores;
    }
    _data["referredByDeliveryBoy"] = referredByDeliveryBoy;
    _data["referredByDeliveryBoyId"] = referredByDeliveryBoyId;
    _data["customersOnboarded"] = customersOnboarded;
    return _data;
  }
}

class Store {
  num? id;
  String? name;
  String? photoUrl;
  String? location;
  dynamic user;
  List<Inventories>? inventories;
  String? status;
  String? createdAt;
  String? updatedAt;

  Store({
    this.id,
    this.name,
    this.photoUrl,
    this.location,
    this.user,
    this.inventories,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    location = json["location"];
    user = json["user"];
    inventories =
        json["inventories"] == null
            ? null
            : (json["inventories"] as List)
                .map((e) => Inventories.fromJson(e))
                .toList();
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["location"] = location;
    _data["user"] = user;
    if (inventories != null) {
      _data["inventories"] = inventories?.map((e) => e.toJson()).toList();
    }
    _data["status"] = status;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class Inventories {
  num? id;
  String? name;
  num? quantity;
  dynamic photoUrl;
  List<SubProducts>? subProducts;
  String? createdAt;
  String? updatedAt;

  Inventories({
    this.id,
    this.name,
    this.quantity,
    this.photoUrl,
    this.subProducts,
    this.createdAt,
    this.updatedAt,
  });

  Inventories.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    quantity = json["quantity"];
    photoUrl = json["photoUrl"];
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
    _data["name"] = name;
    _data["quantity"] = quantity;
    _data["photoUrl"] = photoUrl;
    if (subProducts != null) {
      _data["subProducts"] = subProducts?.map((e) => e.toJson()).toList();
    }
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class SubProducts {
  num? id;
  String? name;
  String? photoUrl;
  String? description;
  num? price;
  num? quantity;

  SubProducts({
    this.id,
    this.name,
    this.photoUrl,
    this.description,
    this.price,
    this.quantity,
  });

  SubProducts.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    description = json["description"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photoUrl"] = photoUrl;
    _data["description"] = description;
    _data["price"] = price;
    _data["quantity"] = quantity;
    return _data;
  }
}
