import 'dart:io';
import 'package:h4food/views/app_extension.dart';
import '../../controllers/external_device.dart';
import '../../controllers/serviecs/firebase_api.dart';
import '../../models/user_model.dart';
import '../app_widgets.dart';
import 'home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late UserModel userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late String sellerImagePath;
  File? _sellerPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Details", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.teal),
      body: ListView(
        children: [
          20.height,
          Stack(
            alignment: Alignment.center,
            children: [CircleAvatar(
              radius: 68,
              backgroundColor: Color(0xffFDCF09),
              child: _sellerPhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: Image.file(
                        _sellerPhoto!,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(65)),
                      width: 130,
                      height: 130,
                      child: Image.asset('assets/images/users.png'),
                    ),
            ),
              Positioned(
                left: 80,
                bottom: 1,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                    onPressed: () {
                      AppWidgets.showCameraAndImageOption(
                          context: context,
                          onGallery: () async {
                            String? galleryImage =
                            await ExternalDevice.imgFromGallery();
                            setState(() {
                              if (galleryImage != null) {
                                sellerImagePath = galleryImage;
                                _sellerPhoto = File(sellerImagePath);
                              } else {
                                print('No image selected.');
                              }
                            });
                          },
                          onCamera: () async {
                            String? cameraImage =
                            await ExternalDevice.imgFromCamera();
                            setState(() {
                              if (cameraImage != null) {
                                sellerImagePath = cameraImage;
                                _sellerPhoto = File(sellerImagePath);
                              } else {
                                print('No image selected.');
                              }
                            });
                          });
                    },
                  ),
                ),
              )],
          ),
          10.height,
          10.height,
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
                var currentUser = FirebaseAuth.instance.currentUser;
                userModel = UserModel(
                    id: currentUser?.uid,
                    token: await FirebaseMessaging.instance.getToken(),
                    description: descriptionController.text,
                    type: Type(
                        email: currentUser?.email,
                        phone: currentUser?.phoneNumber,
                        google: currentUser?.email),
                    users: Users(
                        name: nameController.text,
                        address: addressController.text,
                        image: sellerImagePath));
                if (_sellerPhoto != null) {
                  FirebaseApi.createUser(userModel);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please select a image")));
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}
