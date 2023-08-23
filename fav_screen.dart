import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fav.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteList = favoriteProvider.favoriteList;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Items"),
      ),
      body: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (_, index) {
          final itemTitle = favoriteList[index];
          return ListTile(
            title: Text(itemTitle),
          );
        },
      ),
    );
  }
}
