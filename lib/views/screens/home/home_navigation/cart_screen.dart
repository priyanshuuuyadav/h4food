import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider/product_provider.dart';
import '../../../../models/cart_model.dart';
import 'product_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  int qty = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, value, child) {
        return value.cartList.isEmpty
            ? const Center(child: const Text("Not Found"))
            : ListView.builder(
                itemCount: value.cartList.length,
                itemBuilder: (context, index) {
                  return _items(index, cartModel: value.cartList[index]);
                },
              );
      },
    );
  }

  Widget _items(int index, {required CartModel cartModel}) {
    qty = cartModel.productQuantity;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductScreen(
                  productModel: cartModel.productModel,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'heroTag${cartModel.productModel.productId}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      cartModel.productModel.productImages.toString(),
                      width: 220,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 18.0),
                            iconSize: 25.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (qty >= 2) {
                                  qty--;
                                }
                              });
                            },
                          ),
                          Text(
                            '$qty',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 18.0),
                            iconSize: 25.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                if (qty <= 110) {
                                  qty++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cartModel.productModel.productName}, ${cartModel.productModel.categoryName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${cartModel.productModel.productDescription}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
