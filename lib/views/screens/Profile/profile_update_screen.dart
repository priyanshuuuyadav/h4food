import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:h4food/views/app_extension.dart';
import '../../../controllers/serviecs/firebase_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../models/user_model.dart';
import '../../app_widgets.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final UserModel userModel;

  const ProfileUpdateScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late UserModel userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserModel userModel = widget.userModel;
    addressController.text = userModel.users!.address!;
    nameController.text = userModel.users!.name!;
    return Scaffold(
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
          title: const Text("Profile update",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.pink),
      body: ListView(
        children: [
          20.height,
          AppWidgets.input(controller: nameController, title: "Name"),
          10.height,
          AppWidgets.input(controller: addressController, title: "Address"),
          10.height,
          AppWidgets.input(
              controller: descriptionController, title: "Description"),
          20.height,
          Container(
            height: 65,
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                userModel = UserModel(
                    id: user?.uid,
                    token: await FirebaseMessaging.instance.getToken(),
                    type: Type(
                        email: user?.email,
                        phone: user?.phoneNumber,
                        google: user?.email),
                    users: Users(
                        name: nameController.text,
                        address: addressController.text,
                        image: userModel.users?.image));
                if (descriptionController.text.length >= 10) {
                  FirebaseApi.updateUser(userModel, context);
                  AppWidgets.progressDialog(
                      context: context, title: 'Saving...', seconds: 1);
                  const ScaffoldMessenger(
                    child: SnackBar(content: Text('Profile is updated')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
