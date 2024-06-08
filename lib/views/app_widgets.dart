import 'package:flutter/material.dart';
import 'package:h4food/views/screens/auth/email/email_auth_screen.dart';

class AppWidgets {
  static progressDialog(
      {required BuildContext context,
      required String title,
      required int seconds}) async {
    showDialog(
        barrierDismissible: false, //Don't close dialog when click outside
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  //Loading Indicator you can use any graphic
                  SizedBox(
                    height: 20,
                  ),
                  Text('$title'),
                ],
              ),
            ),
          );
        });

    //Perform your async operation here
    await Future.delayed(Duration(seconds: seconds));

    Navigator.of(context).pop(); //Close the dialog
  }

  static AppBar appBar(
      {required String title,
      required Icon icon,
      required void Function()? onPressed}) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
      backgroundColor: Colors.pink,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(7),
        ),
      ),
    );
  }

  static Padding input(
      {String Function(String?)? validator,
      required TextEditingController controller,
      required String title, Icon? icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: icon,
          filled: true,
          labelText: title,
          fillColor: Color(0xffefefef),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  static showCameraAndImageOption(
      {required BuildContext context,
      required void Function() onGallery,
      required Function() onCamera}) {
    showModalBottomSheet(
        barrierColor: Color(0x45000000),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("clicked")));
                        onGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      onCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

 static Route createRoute({required Widget pageName}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => pageName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.5, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInBack;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
