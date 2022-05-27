import 'package:flutter/material.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text("favorite")),
  //todo update
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
