import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../app_widgets.dart';
import '../../details_screen.dart';
import '../../home/home_screen.dart';

googleAuth(BuildContext ctx) async {
  GoogleSignInAccount? googleSignIn = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? auth = await googleSignIn?.authentication;
  OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: auth?.accessToken, idToken: auth?.idToken);
  FirebaseAuth.instance.signInWithCredential(credential).then(
    (value) async {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .get();

        if (userSnapshot.exists) {
          print('User document exists');
          Navigator.of(ctx).pushReplacement(AppWidgets.createRoute(pageName: HomeScreen()));
        } else {
          print('User document does not exist');
          Navigator.of(ctx).pushReplacement(AppWidgets.createRoute(pageName: DetailsScreen()));
        }
      } catch (e) {}
    },
  );
}
