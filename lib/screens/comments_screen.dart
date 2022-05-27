import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../utils/colors.dart';
import '../widgets/comment_card.dart';
import '../provider/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      //APP BAR AREA
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: false,
      ),
      //BODY AREA
      // todo make it stream so data is in sync
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection('comments')
            .snapshots(),
        builder: (ctx, snapshot) {
          final snap = (snapshot.data! as dynamic).docs;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: blueColor),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something goes wrong"));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No comments.."),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: snap[index]["comment"],
                  liked: snap[index]["likes"].contains(_user.uid),
                  profImage: snap[index]["profImage"],
                  username: snap[index]["username"],
                  commentId: snap[index]["commentId"],
                  postId: widget.snap['postId'],
                  userId: _user.uid,
                );
              },
              itemCount: (snapshot.data! as dynamic).docs.length,
            );
          }
        },
      ),

      //BOTTOM AREA
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 6),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  _user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comment as @${_user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (_commentController.text.isNotEmpty) {
                    FirestoreMethods().postComment(
                      comment: _commentController.text,
                      postId: widget.snap['postId'],
                      profImage: _user.photoUrl,
                      userId: _user.uid,
                      username: _user.username,
                    );
                    _commentController.clear();
                    setState(() {});
                  } else {
                    showSnackBar(context, "Please enter comment first...");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
