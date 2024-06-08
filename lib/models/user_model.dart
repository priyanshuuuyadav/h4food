import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? token;
  Type? type;
  Users? users;
  String? description;

  UserModel({
    this.id,
    this.token,
    this.type,
    this.users,
    this.description,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    token: json["token"],
    type: json["type"] == null ? null : Type.fromJson(json["type"]),
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    description: json["description"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "type": type?.toJson(),
    "users": users?.toJson(),
    "description": description
  };
}

class Users {
  String? name;
  String? address;
  String? image;

  Users({
    this.name,
    this.address,
    this.image,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    name: json["name"],
    address: json["address"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "image": image,
  };
}

class Type {
  String? email;
  String? phone;
  String? google;

  Type({
    this.email,
    this.phone,
    this.google,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    email: json["email"],
    phone: json["phone"],
    google: json["google"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "phone": phone,
    "google": google,
  };
}
