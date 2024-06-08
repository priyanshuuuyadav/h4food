import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:h4food/models/order_model.dart';
import 'package:h4food/views/app_widgets.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../controllers/provider/product_provider.dart';
import '../../../models/product_model.dart';

class OrderPage extends StatefulWidget {
  OrderPage(this.productModel, {super.key});

  ProductModel productModel;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _quantity = 1;
  late double _price; // Price per item
  late double _newPrice; // Price per item
  late Razorpay razorpay;
  late OrderModel orderModel;
  String? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _price = double.parse(widget.productModel.salePrice!);
    _newPrice = _price;
    _getCurrentPosition();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'heroTag${widget.productModel.productId}',
              child: Stack(
                children: [
                  Image.network(
                    widget.productModel.productImages.toString(),
                  ),
                  Positioned(
                    top: 5.0,
                    right: 5.0,
                    child: Consumer<ProductProvider>(
                      builder: (context, value, child) {
                        return value.fabIdList
                                .contains(widget.productModel.productId)
                            ? IconButton(
                                onPressed: () async {
                                  try {
                                    await value.removeToFab(
                                        id: widget.productModel.productId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('remove to fab')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $error')),
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
                                        productModel: widget.productModel);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Added to fab')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $error')),
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
                    '${widget.productModel.productName}, ${widget.productModel.categoryName}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                  ),
                  Text(
                    '${widget.productModel.productDescription}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text("₹${widget.productModel.salePrice}",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Quantity: $_quantity',
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decreaseQuantity,
                    ),
                    SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _increaseQuantity,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Expanded(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              AppWidgets.progressDialog(
                  context: context, title: 'processing...', seconds: 2);
              openCheckout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    topRight: Radius.circular(5)),
              ),
            ),
            child: Text(
              "₹ $_newPrice Pay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Provider.of<ProductProvider>(context, listen: false)
        .createOrder(orderModel: orderModel);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Order successful")));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Something went wrong")));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("order can't placed")));
  }

  void openCheckout() async {
    orderModel = OrderModel(
        productId: widget.productModel.productId,
        address: _currentAddress,
        sellerId: widget.productModel.sellerId,
        lat: _currentPosition?.latitude,
        lng: _currentPosition?.longitude,
        orderId: "${Random().nextInt(72993658)}",
        productDetails: ProductDetails(
          productName: widget.productModel.productName,
          productDescription: widget.productModel.productDescription,
          productCategory: widget.productModel.categoryName,
          productImg: widget.productModel.productImages,
          productPrice: _newPrice.toString(),
          productQty: _quantity.toString(),
        ),
        time: DateTime.now().toString(),
        userId: FirebaseAuth.instance.currentUser?.uid);
    var options = {
      'key': 'rzp_test_4tk0DW8hyUgMcT',
      'amount': _newPrice * 100, // amount in the smallest currency unit
      'name':
          '${FirebaseAuth.instance.currentUser?.email ?? FirebaseAuth.instance.currentUser?.phoneNumber}',
      'description': 'Food is ordered',
      'prefill': {
        'contact': '9060911045',
        'email': 'priyanshuuuyadav@gmail.com.com'
      },
      'external': {
        'wallets': ['paytm', 'phone']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
      _updatePrice();
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _updatePrice();
      });
    }
  }

  void _updatePrice() {
    setState(() {
      _newPrice = _price * _quantity; // Assuming price per item is 100
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() async {
        _currentPosition = position;
        await _getAddressFromLatLng(position);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placeMarks) {
      Placemark place = placeMarks[0];
      setState(() {
        _currentAddress =
            '${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
