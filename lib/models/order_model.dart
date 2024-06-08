import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? orderId;
  String? userId;
  String? productId;
  String? sellerId;
  String? address;
  double? lat;
  double? lng;
  String? time;
  ProductDetails? productDetails;

  OrderModel({
    this.orderId,
    this.userId,
    this.productId,
    this.sellerId,
    this.address,
    this.lat,
    this.lng,
    this.time,
    this.productDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      productId: json['productId'],
      sellerId: json['sellerId'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      time: json['time'],
      productDetails: ProductDetails.fromJson(json['productDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'productId': productId,
      'sellerId': sellerId,
      'address': address,
      'lat': lat,
      'lng': lng,
      'time': time,
      'productDetails': productDetails?.toJson(),
    };
  }
}

class ProductDetails {
  String? productName;
  String? productPrice;
  String? productQty;
  String? productImg;
  String? productCategory;
  String? productDescription;

  ProductDetails({
    this.productName,
    this.productPrice,
    this.productQty,
    this.productImg,
    this.productCategory,
    this.productDescription,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productName: json['productName'],
      productPrice: json['productPrice'],
      productQty: json['productQty'],
      productImg: json['productImg'],
      productCategory: json['productCategory'],
      productDescription: json['productDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productQty': productQty,
      'productImg': productImg,
      'productCategory': productCategory,
      'productDescription': productDescription,
    };
  }
}
