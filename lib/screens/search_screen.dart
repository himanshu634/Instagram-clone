import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Search for a user",
          ),
          onChanged: (String __) {
            if (__.isNotEmpty) {
              setState(() {
                _isShowUser = true;
              });
            } else {
              setState(() {
                _isShowUser = false;
              });
            }
          },
          onEditingComplete: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                _isShowUser = false;
              });
            }
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isShowUser
            ? FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Do not find any users!!"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]["username"],
                        ),
                      );
                    },
                    itemCount: (snapshot.data! as dynamic).docs.length,
                  );
                },
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where(
                      "username",
                      isGreaterThanOrEqualTo: _searchController.text,
                    )
                    .get(),
              )
            : FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Center(
                        child: Text("No post found."),
                      ),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl']);
                    },
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 4,
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1,
                      (index % 7 == 0) ? 2 : 1,
                    ),
                  );
                },
                future: FirebaseFirestore.instance.collection("posts").get(),
              ),
      ),
    );
  }
}
