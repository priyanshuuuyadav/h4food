import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:h4food/views/screens/auth/email/email_auth_screen.dart';
import '../../../app_widgets.dart';
import '../google/google_auth.dart';
import 'otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
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
              child: Container(
                height: 300,
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(21.0),
                        child: Text(
                          "Let's start !",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            controller: phoneController,
                            onChanged: (value) {
                              _formKey.currentState?.validate();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please inter a phone number";
                              } else if (!RegExp(
                                      r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                                  .hasMatch(value)) {
                                return 'please enter a valid phone number';
                              } else {
                                return '';
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon:
                                  Icon(Icons.phone_android, color: Colors.teal),
                              prefixText: '+91 | ',
                              filled: true,
                              labelText: "Phone number",
                              fillColor: Color(0xffefefef),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )),
                      23.height,
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 30, right: 30),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (phoneController.text.length == 10) {
                              _phoneAuth(phoneController.text);
                              AppWidgets.progressDialog(
                                  context: context,
                                  title: 'Sending otp...',
                                  seconds: 10);
                            }
                          },
                          child: Text(
                            "Send otp",
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 10,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded),
            color: Colors.white,
            iconSize: 30,
          ),
        )
      ],
    ));
  }

  _phoneAuth(String number) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$number",
      verificationCompleted: (c) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('otp sending')));
      },
      verificationFailed: (f) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('otp sending Failed')));
      },
      codeSent: (verificationId, forceResendingToken) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('otp sent')));
        Navigator.of(context).pushReplacement(AppWidgets.createRoute(
            pageName: OtpVerificationScreen(otp: verificationId)));
      },
      codeAutoRetrievalTimeout: (v) {},
    );
  }
}
