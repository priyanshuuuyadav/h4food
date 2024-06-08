import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? productId;
  String? sellerId;
  String? productName;
  String? categoryName;
  String? salePrice;
  String? productImages;
  String? productDescription;
  String? createdAt;
  String? updatedAt;
  String? qty;

  ProductModel({
    this.productId,
    this.sellerId,
    this.productName,
    this.categoryName,
    this.salePrice,
    this.productImages,
    this.productDescription,
    this.createdAt,
    this.updatedAt,
    this.qty,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["productId"],
    sellerId: json["sellerId"],
    productName: json["productName"],
    categoryName: json["categoryName"],
    salePrice: json["salePrice"],
    productImages: json["productImages"],
    productDescription: json["productDescription"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "sellerId": sellerId,
    "productName": productName,
    "categoryName": categoryName,
    "salePrice": salePrice,
    "productImages": productImages,
    "productDescription": productDescription,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "qty": qty,
  };
}
