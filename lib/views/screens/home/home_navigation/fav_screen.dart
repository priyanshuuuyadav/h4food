import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider/product_provider.dart';
import '../../../../models/product_model.dart';
import 'home_screen.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite"),),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.fabList.length,
            itemBuilder: (context, index) {
              ProductModel productModel = value.fabList[index];
              return buildProductItem(context, productModel);
            },
          );
        },
      ),
    );
  }
}
