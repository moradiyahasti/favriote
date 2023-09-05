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
          final isFavorite = favoriteProvider.isItemFavorite(itemTitle);
          return ListTile(
            title: Text(itemTitle),
            trailing: IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite ? Colors.red : Colors.grey,
              onPressed: () {
                if (isFavorite) {
                  favoriteProvider.removeFromFavorites(itemTitle);
                } else {
                  favoriteProvider.addToFavorites(itemTitle);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
