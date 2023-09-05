// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'fav.dart';
//
// class FavoritePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final favoriteProvider = Provider.of<FavoriteProvider>(context);
//     final favoriteList = favoriteProvider.favoriteList;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Favorite Items"),
//       ),
//       body: ListView.builder(
//         itemCount: favoriteList.length,
//         itemBuilder: (_, index) {
//           final itemTitle = favoriteList[index];
//           return ListTile(
//             title: Text(itemTitle),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fav.dart';
import 'fav_detais_Screen.dart';
import 'fav_screen.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class FavoriteHomeScreen extends StatefulWidget {
  const FavoriteHomeScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteHomeScreen> createState() => _FavoriteHomeScreenState();
}

class _FavoriteHomeScreenState extends State<FavoriteHomeScreen> {
  List<Empty>? carbrand;

  @override
  void initState() {
    super.initState();
    getBrandData();
  }

  getBrandData() async {
    carbrand = await fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Data"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoritePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: carbrand?.length ?? 0,
        itemBuilder: (_, i) {
          final itemTitle = carbrand?[i].title ?? "";
          final isFavorite =
              Provider.of<FavoriteProvider>(context).isItemFavorite(itemTitle);
          return Container(
            margin: EdgeInsets.only(bottom: 30, right: 20, top: 10, left: 20),
            color: Colors.pink[100],
            child: ListTile(
              title: Text(
                itemTitle,
                style: TextStyle(color: Colors.deepPurple),
              ),
              subtitle: Text(carbrand?[i].completed.toString() ?? ""),
              leading: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: isFavorite ? Colors.red : Colors.grey,
                onPressed: () {
                  final favoriteProvider =
                      Provider.of<FavoriteProvider>(context, listen: false);

                  if (isFavorite) {
                    favoriteProvider.removeFromFavorites(itemTitle);
                  } else {
                    favoriteProvider.addToFavorites(itemTitle);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Empty>> fetchImage() async {
    final url = 'https://jsonplaceholder.typicode.com/todos/?';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    print(body);
    List<Empty> carDetailScreenData = emptyFromJson(body);

    return carDetailScreenData;
  }
}
