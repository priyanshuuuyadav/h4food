import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h4food/controllers/serviecs/firebase_api.dart';
import 'package:h4food/models/cart_model.dart';
import 'package:h4food/models/product_model.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:h4food/views/app_widgets.dart';
import 'package:h4food/views/screens/home/order_page.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider/product_provider.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key, required this.productModel}) : super(key: key);

  final ProductModel productModel;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product")),
      body: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          buildProductDetails(widget.productModel),
          Consumer<ProductProvider>(builder: (context, value, child) {
            return SizedBox(
              height: 320,
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: value.productModelList.length,
                itemBuilder: (context, index) {
                  return productViewInSmallCard(
                      context, value.productModelList[index]);
                },
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 55,
            child: Consumer<ProductProvider>(
              builder:
                  (BuildContext context, ProductProvider value, Widget? child) {
                return value.cartIdList.contains(widget.productModel.productId)
                    ? buildRemoveButton(context, value)
                    : buildAddToCartButton(context, value);
              },
            ),
          ),
        ),
        1.width,
        Expanded(child: SizedBox(height: 55, child: buildBuyNowButton(widget.productModel))),
      ],
    );
  }

  Widget buildRemoveButton(BuildContext context, ProductProvider value) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await value.removeToCart(id: widget.productModel.productId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from cart')),
            );
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
          ),
        ),
        child: const Text(
          "Remove to cart",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildAddToCartButton(BuildContext context, ProductProvider value) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: () async {
          CartModel cartModel = CartModel(
            cartId: widget.productModel.productId ??
                "${Random().nextInt(651276412)}",
            deliveryTime: "Delivery time",
            productModel: widget.productModel,
            productQuantity: 1,
          );

          try {
            await value.addToCart(cartModel: cartModel);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart')),
            );
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
          ),
        ),
        child: const Text(
          "Add to cart",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildBuyNowButton(ProductModel productModel) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrderPage(productModel)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
          ),
        ),
        child: const Text(
          "Buy now",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

Widget buildProductDetails(ProductModel productModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Hero(
          tag: 'heroTag${productModel.productId}',
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  productModel.productImages.toString(),
                ),
              ),
              Positioned(
                  top: 5.0,
                  right: 5.0,
                  child: Consumer<ProductProvider>(
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              FirebaseApi.shareProduct(
                                  productModel: productModel);
                              AppWidgets.progressDialog(context: context, title: 'wait...', seconds: 3);
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          value.fabIdList.contains(productModel.productId)
                              ? IconButton(
                                  onPressed: () async {
                                    try {
                                      await value.removeToFab(
                                          id: productModel.productId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('remove to fab')),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Error: $error')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    try {
                                      await value.addToFab(
                                          productModel: productModel);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Added to fab')),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Error: $error')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                        ],
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${productModel.productName}, ${productModel.categoryName}',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
            ),
            Text(
              '${productModel.productDescription}',
              style: TextStyle(fontSize: 14),
            ),
            Text("₹${productModel.salePrice}",
                style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      )
    ],
  );
}

Widget productViewInSmallCard(BuildContext context, ProductModel productModel) {
  return SizedBox(
    width: 250,
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductScreen(productModel: productModel),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0x2c7ba456)),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Hero(
              tag: 'heroTag${productModel.productId}',
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: Image.network(
                      productModel.productImages.toString(),
                    ),
                  ),
                  Positioned(
                    top: 5.0,
                    right: 5.0,
                    child: Consumer<ProductProvider>(
                      builder: (context, value, child) {
                        return value.fabIdList.contains(productModel.productId)
                            ? IconButton(
                          onPressed: () async {
                            try {
                              await value.removeToFab(
                                  id: productModel.productId);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text('remove to fab')),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                    content: Text('Error: $error')),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                        )
                            : IconButton(
                          onPressed: () async {
                            try {
                              await value.addToFab(
                                  productModel: productModel);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text('Added to fab')),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                    content: Text('Error: $error')),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 11, left: 11, right: 11, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${productModel.productName}, ${productModel.categoryName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${productModel.productDescription}'),
                  Text(
                    '₹ ${productModel.salePrice}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
