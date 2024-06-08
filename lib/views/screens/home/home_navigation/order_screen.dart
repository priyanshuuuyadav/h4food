import 'package:flutter/material.dart';
import 'package:h4food/models/order_model.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider/product_provider.dart';
import '../order_track.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          return value.orderList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        "Sorry,\nYou have not placed an order yet",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      20.height,
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("in join food"),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.orderList.length,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = value.orderList[index];
                    return buildProductItemForOrderScreen(context, orderModel);
                  },
                );
        },
      ),
    );
  }

  buildProductItemForOrderScreen(BuildContext context, OrderModel orderModel) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0x61c36acb),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'heroTag${orderModel.productId}',
              child: Image.network(
                orderModel.productDetails!.productImg.toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 11, left: 11, right: 11, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${orderModel.productDetails?.productName}, ${orderModel.productDetails?.productCategory}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                  ),
                  Text(
                    '${orderModel.productDetails?.productDescription}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text("₹${orderModel.productDetails?.productPrice}",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty:- ${orderModel.productDetails?.productQty}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderTrackScreen(),
                          ));
                    },
                    child:
                        Text("Order Track", style: TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
