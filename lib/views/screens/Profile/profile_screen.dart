import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h4food/views/app_extension.dart';
import 'package:h4food/views/screens/auth/email/email_auth_screen.dart';
import '../../../controllers/external_device.dart';
import '../../../controllers/serviecs/firebase_api.dart';
import '../../../models/user_model.dart';
import '../../app_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _userPhoto;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            // .doc('gsGJUiQQPuO9hvLo1U6D04MiQwl1')
        .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
          } else if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
          }
          if (snapshot.data == null || !snapshot.data!.exists) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
          }
          var data = snapshot.data!.data();
          if (data == null) {
            return Text("Data is null");
          }
          UserModel userModel;
          try {
            userModel = UserModel.fromJson(data as Map<String, dynamic>);
          } catch (e) {
            print("Error parsing SellerModel: $e");
            return Text("Error parsing SellerModel");
          }
          addressController.text = userModel.users?.address ?? "";
          nameController.text = userModel.users?.name ?? "";
          descriptionController.text = userModel.description ?? "";
          emailController.text = userModel.type?.email ?? "";
          phoneController.text = userModel.type?.phone ?? "";
          bool phone = userModel.type!.phone!.isNotEmpty ?true:false;
          bool email = userModel.type!.email!.isNotEmpty ?true:false;
          return Column(
            children: [
              // First layout
              Expanded(
                  flex: 2,
                  child: profileImageItem(
                      context, userModel.users?.image ?? "not found")),
              // Second layout
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        userModel.users?.name ?? "Name not found",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.users?.name ?? "Add name"),
                          IconButton(
                              onPressed: () {
                                updateDialog(controller: nameController, title: "Name", context: context, path: 'users.name');
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.users?.address ?? "Add address"),
                          IconButton(
                              onPressed: () {
                                updateDialog(
                                    controller: addressController, title: "Address", context: context, path: 'users.address');
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      email
                      // userModel.type!.email!.isNotEmpty
                          ? Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.type?.email ?? "gmail"),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black45,
                              ))
                        ],
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.type?.email ?? "Add gmail"),
                          IconButton(
                              onPressed: () {
                                updateDialog(
                                    controller: emailController, title: "Email", context: context, path: 'type.email');
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      phone
                      // userModel.type!.phone!.isNotEmpty
                          ? Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.type?.phone ?? "Number"),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black45,
                              ))
                        ],
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userModel.type?.phone ?? "Add Number"),
                          IconButton(
                              onPressed: () {
                                updateDialog(
                                    controller: phoneController, title: "Number", context: context, path: 'type.phone');
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black45,
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(userModel.description ??
                                  "Add Description")),
                          IconButton(
                              onPressed: () {
                                updateDialog(controller: descriptionController, title: "Address",
                                   context: context,path: 'description');
                              },
                              icon: Icon(Icons.edit))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailAuthScreen(),
                          ));
                    },
                    heroTag: 'logout',
                    elevation: 0,
                    backgroundColor: Colors.red,
                    label: Text("Logout ${userModel.users?.name}"),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              30.height
            ],
          );
        });
  }

  Widget profileImageItem(BuildContext context, String image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 60),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.teal, Color(0xff28887a)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _userPhoto == null
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 3),
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(image)),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 3),
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Image.file(_userPhoto!),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        AppWidgets.showCameraAndImageOption(
                            context: context,
                            onGallery: () async {
                              String? galleryImage =
                                  await ExternalDevice.imgFromGallery();
                              setState(() {
                                if (galleryImage != null) {
                                  _userPhoto = File(galleryImage);
                                  confirmationDialog(context);
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
                                  _userPhoto = File(cameraImage);
                                  confirmationDialog(context);
                                } else {
                                  print('No image selected.');
                                }
                              });
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void confirmationDialog(context) {
    showDialog(
        barrierColor: Color(0x45000000),
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Do you really want to update your image"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _userPhoto = null;
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
              IconButton(
                  onPressed: () {
                    FirebaseApi.updateImage(
                        collection: 'user_image', photo: _userPhoto!);
                    Navigator.pop(context);
                    AppWidgets.progressDialog(
                        context: context, title: 'uploading...', seconds: 2);
                  },
                  icon: Icon(Icons.done)),
            ],
          );
        });
  }

  void updateDialog(
      {required TextEditingController controller, required String title, required BuildContext context, required String path}) {
    showDialog(
        barrierColor: Color(0x45000000),
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            title: Text("Update $title"),
            content: AppWidgets.input(controller: controller, title: ''),
            actions: [
              ElevatedButton(
                onPressed: () {
                  FirebaseApi.updateUserData(path: path, value: controller.text);
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ],
          );
        });
  }
}
