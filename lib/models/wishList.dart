class FavoriteList {
  bool? success;
  WishList? wishList;

  FavoriteList({this.success, this.wishList});

  FavoriteList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    wishList =
        json['wishList'] != null ? WishList.fromJson(json['wishList']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (wishList != null) {
      data['wishList'] = wishList!.toJson();
    }
    return data;
  }
}

class WishList {
  String? sId;
  String? user;
  List<WishListItems>? wishListItems;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WishList(
      {this.sId,
      this.user,
      this.wishListItems,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WishList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    if (json['wishListItems'] != null) {
      wishListItems = <WishListItems>[];
      json['wishListItems'].forEach((v) {
        wishListItems!.add(WishListItems.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    if (wishListItems != null) {
      data['wishListItems'] = wishListItems!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class WishListItems {
  Product? product;
  String? sId;
  String? addedAt;

  WishListItems(
      {required this.product, required this.sId, required this.addedAt});

  WishListItems.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    sId = json['_id'];
    addedAt = json['addedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['_id'] = sId;
    data['addedAt'] = addedAt;
    return data;
  }
}

class Product {
  String? sId;
  List<ProImg>? proImg;
  String? name;
  Price? price;
  String? slug;

  Product({this.sId, this.proImg, this.name, this.price, this.slug});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['proImg'] != null) {
      proImg = <ProImg>[];
      json['proImg'].forEach((v) {
        proImg!.add(ProImg.fromJson(v));
      });
    }
    name = json['name'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (proImg != null) {
      data['proImg'] = proImg!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['slug'] = slug;
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

class Price {
  String? $numberDecimal;

  Price({this.$numberDecimal});

  Price.fromJson(Map<String, dynamic> json) {
    $numberDecimal = json['\$numberDecimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$numberDecimal'] = $numberDecimal;
    return data;
  }
}
