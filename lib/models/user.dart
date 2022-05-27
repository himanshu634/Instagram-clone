import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String bio;
  final String email;
  final String photoUrl;
  final List followers;
  final List following;

  const User({
    required this.username,
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'bio': bio,
        'email': email,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
        'uid': uid,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = (snapshot.data()! as Map<String, dynamic>);
    return User(
      bio: data['bio'],
      email: data['email'],
      followers: data['followers'],
      following: data['following'],
      photoUrl: data["photoUrl"],
      uid: data['uid'],
      username: data['username'],
    );
  }
}
