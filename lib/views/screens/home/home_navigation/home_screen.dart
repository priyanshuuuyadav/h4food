import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider/product_provider.dart';
import '../../../../controllers/serviecs/firebase_api.dart';
import '../../../../models/product_model.dart';
import 'package:h4food/views/screens/home/home_navigation/product_screen.dart';

import '../../../app_widgets.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Center(
          child: Wrap(
            children: List.generate(categoryController.length, (index) {
              return categoryItem(categoryController[index]);
            }),
          ),
        ),
        Consumer<ProductProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: value.productModelList.length,
              itemBuilder: (context, index) {
                ProductModel productModel = value.productModelList[index];
                return buildProductItem(context, productModel);
              },
            );
          },
        )
      ],
    );
  }

  categoryItem(List data) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 115,
            height: 115,
            // padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: Colors.black12),
            ),
            child: Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    data[1],
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black26,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          4.height,
          Text(
            data[0],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

Widget buildProductItem(BuildContext context, ProductModel productModel) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductScreen(productModel: productModel),
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0x9bcfeae4),
        ),
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
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.black26,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
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
                                AppWidgets.progressDialog(
                                    context: context,
                                    title: 'wait...',
                                    seconds: 3);
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
            ),
          ],
        ),
      ),
    ),
  );
}

final List<List<String>> categoryController = [
  [
    "Sandwich",
    'https://somethingaboutsandwiches.com/wp-content/uploads/2022/04/ham-sandwich.jpg'
  ],
  [
    "Chicken",
    'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    "Burger",
    'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    "Pizza",
    'https://plus.unsplash.com/premium_photo-1690056321739-2663df5958b6?q=80&w=1916&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    'Chaum-in',
    'https://content.jdmagicbox.com/comp/gorakhpur/t6/9999px551.x551.140516113536.r7t6/catalogue/chaumin-and-burger-centre-chauri-chaura-gorakhpur-fast-food-9kion.jpg'
  ],
  [
    'Idly',
    'https://images.unsplash.com/photo-1630383249896-424e482df921?q=80&w=1960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    'Dosa',
    'https://images.unsplash.com/photo-1644289450169-bc58aa16bacb?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    'Samosa',
    'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ],
  [
    'Poori',
    'https://images.unsplash.com/photo-1605719161691-5d9771fc144f?q=80&w=2042&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
];
