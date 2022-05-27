import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';

class CommentCard extends StatelessWidget {
  final String profImage;
  final String username;
  final bool liked;
  final String comment;
  final String commentId;
  final String postId;
  final String userId;
  const CommentCard({
    Key? key,
    required this.comment,
    required this.liked,
    required this.profImage,
    required this.username,
    required this.commentId,
    required this.postId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              profImage,
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "   " + comment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            // TODO add functionality
            onTap: () async {
              await FirestoreMethods()
                  .likeComment(commentId, postId, userId, liked);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                liked ? Icons.favorite : Icons.favorite_outline_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
