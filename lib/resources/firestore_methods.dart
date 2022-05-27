import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import './storage_methods.dart';
import '../models/post.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      final String postId = const Uuid().v1();
      // todo remove
      Post post = Post(
        datePublished: DateTime.now(),
        description: description,
        postId: postId,
        postUrl: postUrl,
        uid: uid,
        username: username,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(
      String commentId, String postId, String userId, bool liked) async {
    try {
      if (liked) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComment(
      {required String userId,
      required String comment,
      required String postId,
      required String username,
      required String profImage}) async {
    try {
      String commentId = const Uuid().v1();
      _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "username": username,
        'comment': comment,
        'uid': userId,
        'profImage': profImage,
        'commentId': commentId,
        'likes': [],
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }
}
