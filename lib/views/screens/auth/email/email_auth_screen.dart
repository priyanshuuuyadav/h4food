import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:h4food/views/screens/auth/phone/phone_auth_screen.dart';
import '../../../app_widgets.dart';
import '../../details_screen.dart';
import '../../home/home_screen.dart';
import '../google/google_auth.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({Key? key}) : super(key: key);

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

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
            child: Container(
              height: 500,
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
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an email";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Enter email",
                          alignLabelWithHint: true,
                          fillColor: Color(0xffefefef),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    23.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        // Toggle visibility based on the boolean
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          } else if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value)) {
                            return '8 characters, uppercase, lowercase, number, special character';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          labelText: "Enter password",
                          fillColor: Color(0xffefefef),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    30.height,
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text.contains('@gmail.com')) {
                              AppWidgets.progressDialog(
                                  context: context,
                                  title: 'wait...',
                                  seconds: 2);
                              _emailAuth(context);
                            } else {
                              emailController.clear();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(AppWidgets.createRoute(pageName: PhoneAuthScreen()));
                          },
                          icon: Image.asset(
                            'assets/images/phone.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                        20.width,
                        IconButton(
                          onPressed: () {
                            googleAuth(context);
                          },
                          icon: Image.asset(
                            'assets/images/google.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _emailAuth(BuildContext ctx) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) async {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .get();

        if (userSnapshot.exists) {
          print('User document exists');
          Navigator.of(ctx)
              .pushReplacement(AppWidgets.createRoute(pageName: HomeScreen()));
        } else {
          print('User document does not exist');
          Navigator.of(ctx).pushReplacement(
              AppWidgets.createRoute(pageName: DetailsScreen()));
        }
      } catch (e) {}
    });
  }
}
