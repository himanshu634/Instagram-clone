import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String description;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({
    required this.username,
    required this.datePublished,
    required this.description,
    required this.likes,
    required this.postId,
    required this.postUrl,
    required this.uid,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'description': description,
        'dataPublished': datePublished,
        'likes': likes,
        'postId': postId,
        'postUrl': postUrl,
        'uid': uid,
        'profImage': profImage,
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = (snapshot.data()! as Map<String, dynamic>);
    return Post(
      postId: data['postId'],
      description: data['description'],
      likes: data['likes'],
      profImage: data['profImage'],
      postUrl: data["postUrl"],
      uid: data['uid'],
      username: data['username'],
      datePublished: data['dataPublished'],
    );
  }
}
