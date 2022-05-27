import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../resources/auth_methods.dart';
import '../provider/user_provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  //todo do web layout
  @override
  Widget build(BuildContext context) {
    model.User _user = Provider.of<UserProvider>(context).getUser;
    _signOut() async {
      await AuthMethods().signOutUser();
    }

    return Scaffold(
      body:  Center(
        child: Text(_user.username),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
      ),
    );
  }
}
