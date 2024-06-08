import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/screens/auth/email/email_auth_screen.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider/product_provider.dart';
import 'details_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getProducts();
    Provider.of<ProductProvider>(context, listen: false).getToCart();
    Provider.of<ProductProvider>(context, listen: false).getToFab();
    Provider.of<ProductProvider>(context, listen: false).getOrder();
    Timer(const Duration(seconds: 2), () async {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .get();

        if (userSnapshot.exists) {
          print('User document exists');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          print('User document does not exist');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(),
            ),
          );
        }
      } catch (e) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => EmailAuthScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Image.asset("assets/images/splashscreen.png"),
        ),
      ),
    );
  }
}
