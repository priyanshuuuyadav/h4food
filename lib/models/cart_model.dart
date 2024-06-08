import 'package:h4food/models/product_model.dart';

class CartModel {
  final String cartId;
  final ProductModel productModel;
  final String deliveryTime;
  final int productQuantity;

  CartModel({
    required this.cartId,
    required this.productModel,
    required this.deliveryTime,
    required this.productQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'productModel': productModel.toJson(),
      'deliveryTime': deliveryTime,
      'productQuantity': productQuantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'],
      productModel: json['productModel'] == null ? ProductModel() : ProductModel.fromJson(json['productModel']),
      deliveryTime: json['deliveryTime'],
      productQuantity: json['productQuantity'],
    );
  }
}
