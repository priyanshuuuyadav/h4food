import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h4food/controllers/provider/product_provider.dart';
import 'package:h4food/views/screens/home/home_navigation/fav_screen.dart';
import 'package:h4food/views/screens/home/home_navigation/home_screen.dart';
import 'package:h4food/views/screens/Profile/profile_screen.dart';
import 'package:h4food/views/screens/home/home_navigation/order_screen.dart';
import 'package:h4food/views/screens/home/home_navigation/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? "Home"
              : _selectedIndex == 1
                  ? "Search"
                  : "Account",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Provider.of<ProductProvider>(context).orderList.length >= 1
              ? IconButton(
                  icon: Badge(
                    label: Text(Provider.of<ProductProvider>(context)
                        .orderList
                        .length
                        .toString()),
                    child: Image.asset(
                      'assets/images/order.png',
                      width: 24,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(),
                        ));
                  },
                )
              : Text(""),
          Provider.of<ProductProvider>(context).cartList.length >= 1
              ? IconButton(
                  icon: Badge(
                    label: Text(Provider.of<ProductProvider>(context)
                        .cartList
                        .length
                        .toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(),
                        ));
                  },
                )
              : Text(""),
          Provider.of<ProductProvider>(context).fabList.length >= 1
              ? IconButton(
                  icon: Badge(
                    label: Text(Provider.of<ProductProvider>(context)
                        .fabList
                        .length
                        .toString()),
                    child: Icon(Icons.favorite),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavScreen(),
                        ));
                  },
                )
              : Text(''),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        backgroundColor: _selectedIndex == 0
            ? Colors.teal
            : _selectedIndex == 1
                ? Colors.orange
                : Colors.teal,
      ),
      drawer: _drawer(),
      body: _selectedIndex == 0
          ? FrontScreen()
          : _selectedIndex == 1
              ? SearchScreen()
              : const ProfileScreen(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: Colors.teal,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.search),
    title: const Text("Search"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Account"),
    selectedColor: Colors.pinkAccent,
  ),
];

Widget _drawer() {
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
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
        return Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ), //BoxDecoration
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  accountName: Text(
                    userModel.users?.name??"",
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text(userModel.type?.email??userModel.type?.phone??""),
                  currentAccountPictureSize: Size.square(50),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ), //Text
                  ), //circleAvatar
                ), //UserAccountDrawerHeader
              ), //DrawerHeader
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(' My Profile '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text(' My Course '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text(' Go Premium '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_label),
                title: const Text(' Saved Videos '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(' Edit Profile '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}