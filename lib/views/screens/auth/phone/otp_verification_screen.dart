import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:h4food/views/app_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import '../../details_screen.dart';
import '../../home/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  String otp;

  OtpVerificationScreen({Key? key, required this.otp}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/allfood.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 100,
                  //   height: 120,
                  //   child: Lottie.network(
                  //     'https://example.com/animation.json', // Replace with your animation URL
                  //     width: 200,
                  //     height: 200,
                  //     fit: BoxFit.cover,
                  //     animate: true, // Set to false if you want to stop the animation
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(21.0),
                    child: Text(
                      "Enter otp",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  35.height,
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Pinput(
                      controller: otpController,
                      focusNode: FocusNode(),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      showCursor: true,
                      length: 6,
                    ),
                  ),
                  20.height,
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (otpController.text.length == 6) {
                          AppWidgets.progressDialog(context: context, title: 'verify...', seconds: 2);
                          _otpVerification(context);
                        }
                      },
                      child: Text(
                        "Verification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  _otpVerification(BuildContext ctx) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.otp, smsCode: otpController.text.toString());
    FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .get();

        if (userSnapshot.exists) {
          print('User document exists');
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          print('User document does not exist');
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(),
            ),
          );
        }
      } catch (e) {}
    });
  }
}
