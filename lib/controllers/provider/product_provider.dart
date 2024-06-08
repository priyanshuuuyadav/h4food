import 'package:flutter/material.dart';
import 'package:h4food/controllers/serviecs/firebase_api.dart';
import 'package:h4food/models/order_model.dart';
import 'package:h4food/models/product_model.dart';
import '../../models/cart_model.dart';

class ProductProvider with ChangeNotifier {
  late List<ProductModel> productModelList;
  List<CartModel> cartList = [];
  List<String?> cartIdList = [];
  List<ProductModel> fabList = [];
  List<OrderModel> orderList = [];
  List<String?> fabIdList = [];
  List<String?> orderIdList = [];

  getProducts() async {
    productModelList = await FirebaseApi.getProductsInFirebase();
    notifyListeners();
  }

  getToCart() async {
    cartList = await FirebaseApi.getCartInFirebase();
    for (var element in cartList) {
      cartIdList.add(element.productModel.productId);
    }
    notifyListeners();
  }

  removeToCart({required String? id}) async {
    cartList.removeWhere((cart) => cart.productModel.productId == id);
    cartIdList.remove(id);
    await FirebaseApi.removeCartInFirebase(id: id);
    notifyListeners();
  }

  addToCart({required CartModel cartModel}) async {
    cartList.insert(0, cartModel);
    cartIdList.add(cartModel.productModel.productId);
    await FirebaseApi.addCartInFirebase(cartModel: cartModel);
    notifyListeners();
  }

  addToFab({required ProductModel productModel}) async {
    fabList.insert(0, productModel);
    fabIdList.add(productModel.productId);
    await FirebaseApi.addFabInFirebase(productModel: productModel);
    notifyListeners();
  }

  removeToFab({required String? id}) async {
    fabList.removeWhere((cart) => cart.productId == id);
    fabIdList.remove(id);
    await FirebaseApi.removeCartInFirebase(id: id);
    notifyListeners();
  }

  getToFab() async {
    fabList = await FirebaseApi.getFabInFirebase();
    for (var element in fabList) {
      fabIdList.add(element.productId);
    }
    notifyListeners();
  }

  getOrder() async {
    orderList = await FirebaseApi.getOrderToFirebase();
    for (var element in orderList) {
      orderIdList.add(element.orderId);
    }
    notifyListeners();
  }

  createOrder({required OrderModel orderModel}) async {
    orderList.insert(0, orderModel);
    orderIdList.add(orderModel.orderId);
    await FirebaseApi.createOrderToFirebase(orderModel: orderModel);
    notifyListeners();
  }

  increasedCartItem(String productId){

  }
}
