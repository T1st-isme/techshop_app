class User {
  bool? success;
  String? token;
  UserPro? user;

  User({this.success, this.token, this.user});

  User.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    user = json['user'] != null ? UserPro.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserPro {
  String? sId;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? refreshToken;

  UserPro({
    this.sId,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.refreshToken,
  });

  UserPro.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    refreshToken = json['refreshToken'];
  }

  set value(User value) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['refreshToken'] = refreshToken;

    return data;
  }
}
