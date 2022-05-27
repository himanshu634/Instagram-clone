import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/global_vars.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! testing function
    _comments() async {
      AuthMethods().signOutUser();
    }

    _navigationTapped(int page) {
      _controller.jumpToPage(page);
      setState(() {
        _page = page;
      });
    }

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: _navigationTapped,
        backgroundColor: mobileBackgroundColor,
        activeColor: primaryColor,
        inactiveColor: secondaryColor,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
            backgroundColor: primaryColor,
          ),
        ],
      ),
      //! testing button
      floatingActionButton: FloatingActionButton(
        onPressed: _comments,
      ),
    );
  }
}
