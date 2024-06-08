import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:h4food/models/order_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';

class FirebaseApi {
  static createUser(UserModel userModel) async  {
    FirebaseStorage.instance
        .ref('user_image')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(File(userModel.users?.image ?? ""))
        .then((p0) {
      p0.ref.getDownloadURL().then((userImage) {
        userModel.users?.image = userImage;
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set(userModel.toJson())
            .then((value) {});
      });
    });
  }

  static Future<UserModel> getUser() async {
    UserModel? res;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      res = UserModel.fromJson(value.data()!);
    });
    return res ?? UserModel(users: Users(name: "Not found"));
  }

  static updateImage({required String collection, required File photo}) async {
    FirebaseStorage.instance
        .ref(collection)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(photo);
  }

  static updateUser(UserModel userModel, BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(userModel.toJson());
  }

  static addCartInFirebase({required CartModel cartModel}) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_cart')
        .doc(cartModel.productModel.productId)
        .set(cartModel.toMap());
  }

  static removeCartInFirebase({required String? id}) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_cart')
        .doc(id)
        .delete();
  }

  static Future<List<ProductModel>> getProductsInFirebase() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("product").get();
    return (querySnapshot.docs)
        .map((e) => ProductModel.fromJson(e.data()))
        .toList();
  }

  static Future<List<CartModel>> getCartInFirebase() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_cart')
        .get();

    return (querySnapshot.docs)
        .map((e) => CartModel.fromMap(e.data()))
        .toList();
  }

  static addFabInFirebase({required ProductModel productModel}) {
    FirebaseFirestore.instance
        .collection("fab")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_fab')
        .doc(productModel.productId)
        .set(productModel.toJson());
  }

  static removeFabInFirebase({required String? id}) {
    FirebaseFirestore.instance
        .collection("fab")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_fab')
        .doc(id)
        .delete();
  }

  static Future<List<ProductModel>> getFabInFirebase() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('fab')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('user_fab')
        .get();

    return (querySnapshot.docs)
        .map((e) => ProductModel.fromJson(e.data()))
        .toList();
  }

  static createOrderToFirebase({required OrderModel orderModel}) async {
    FirebaseFirestore.instance
        .collection("order")
        .doc(orderModel.orderId)
        .set(orderModel.toJson());
  }

  static Future<List<OrderModel>> getOrderToFirebase() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('order')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    return (querySnapshot.docs)
        .map((e) => OrderModel.fromJson(e.data()))
        .toList();
  }

  static Future<void> updateUserData({required String path, required String value}) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(FirebaseAuth.instance.currentUser?.uid).update({path: value,});
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  static shareProduct({required ProductModel productModel}) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://h4food.page.link/product"),
      uriPrefix: "https://h4food.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.deeplink.deeplink"),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "${productModel.productName}, ${productModel.categoryName}",
        description: "${productModel.productDescription}",
        imageUrl: Uri.parse("${productModel.productImages}"),
      ),
    );
    var url =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    Share.share(url.shortUrl.toString());
  }
}
