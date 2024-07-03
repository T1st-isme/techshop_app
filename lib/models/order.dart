class Order {
  bool? success;
  List<Data>? data;

  Order({this.success, this.data});

  Order.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? user;
  TotalPrice? totalPrice;
  List<Items>? items;
  String? paymentType;
  String? orderStatus;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
      this.user,
      this.totalPrice,
      this.items,
      this.paymentType,
      this.orderStatus,
      this.createdAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    totalPrice = json['totalPrice'] != null
        ? TotalPrice.fromJson(json['totalPrice'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    paymentType = json['paymentType'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    if (totalPrice != null) {
      data['totalPrice'] = totalPrice!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['paymentType'] = paymentType;
    data['orderStatus'] = orderStatus;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class TotalPrice {
  String? numberDecimal;

  TotalPrice({this.numberDecimal});

  TotalPrice.fromJson(Map<String, dynamic> json) {
    numberDecimal = json['$numberDecimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['$numberDecimal'] = numberDecimal;
    return data;
  }
}

class Items {
  ProductId? productId;
  double? payablePrice;
  int? purchasedQty;
  String? sId;

  Items({this.productId, this.payablePrice, this.purchasedQty, this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] != null
        ? ProductId.fromJson(json['productId'])
        : null;
    payablePrice = json['payablePrice'];
    purchasedQty = json['purchasedQty'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) {
      data['productId'] = productId!.toJson();
    }
    data['payablePrice'] = payablePrice;
    data['purchasedQty'] = purchasedQty;
    data['_id'] = sId;
    return data;
  }
}

class ProductId {
  Richdescription? richdescription;
  String? sId;
  List<ProImg>? proImg;
  int? stock;
  int? sold;
  int? numReviews;
  String? brand;
  String? name;
  TotalPrice? price;
  String? description;
  String? category;
  String? slug;
  int? iV;
  int? totalRating;
  String? updatedAt;

  ProductId(
      {this.richdescription,
      this.sId,
      this.proImg,
      this.stock,
      this.sold,
      this.numReviews,
      this.brand,
      this.name,
      this.price,
      this.description,
      this.category,
      this.slug,
      this.iV,
      this.totalRating,
      this.updatedAt});

  ProductId.fromJson(Map<String, dynamic> json) {
    richdescription = json['richdescription'] != null
        ? Richdescription.fromJson(json['richdescription'])
        : null;
    sId = json['_id'];
    if (json['proImg'] != null) {
      proImg = <ProImg>[];
      json['proImg'].forEach((v) {
        proImg!.add(ProImg.fromJson(v));
      });
    }
    stock = json['stock'];
    sold = json['sold'];
    numReviews = json['numReviews'];
    brand = json['brand'];
    name = json['name'];
    price = json['price'] != null ? TotalPrice.fromJson(json['price']) : null;
    description = json['description'];
    category = json['category'];
    slug = json['slug'];
    iV = json['__v'];
    totalRating = json['totalRating'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (richdescription != null) {
      data['richdescription'] = richdescription!.toJson();
    }
    data['_id'] = sId;
    if (proImg != null) {
      data['proImg'] = proImg!.map((v) => v.toJson()).toList();
    }
    data['stock'] = stock;
    data['sold'] = sold;
    data['numReviews'] = numReviews;
    data['brand'] = brand;
    data['name'] = name;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['description'] = description;
    data['category'] = category;
    data['slug'] = slug;
    data['__v'] = iV;
    data['totalRating'] = totalRating;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Richdescription {
  String? cpu;
  String? vga;
  String? display;
  String? ram;
  String? ssd;

  Richdescription({this.cpu, this.vga, this.display, this.ram, this.ssd});

  Richdescription.fromJson(Map<String, dynamic> json) {
    cpu = json['cpu'];
    vga = json['vga'];
    display = json['display'];
    ram = json['ram'];
    ssd = json['ssd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cpu'] = cpu;
    data['vga'] = vga;
    data['display'] = display;
    data['ram'] = ram;
    data['ssd'] = ssd;
    return data;
  }
}

class ProImg {
  String? sId;
  String? img;

  ProImg({this.sId, this.img});

  ProImg.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['img'] = img;
    return data;
  }
}
