import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  List<String> _favoriteList = [];

  List<String> get favoriteList => _favoriteList;

  FavoriteProvider() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _favoriteList = _prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  void addToFavorites(String item) {
    _favoriteList.add(item);
    _prefs.setStringList('favorites', _favoriteList);
    notifyListeners();
  }

  void removeFromFavorites(String item) {
    _favoriteList.remove(item);
    _prefs.setStringList('favorites', _favoriteList);
    notifyListeners();
  }

  bool isItemFavorite(String item) {
    return _favoriteList.contains(item);
  }
}









===================// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   List<String> list = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     final response =
//         await http.get(Uri.parse("http://www.kbmusique.com/api/bands.php"));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final bands = jsonData['bands'] as List<dynamic>;
//       setState(() {
//         list = bands.map((band) => band['name'].toString()).toList();
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load data from the API');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 "assets/img.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Center(
//               child: AppBar(
//                 leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 centerTitle: true,
//               ),
//             ),
//           ],
//         ),
//         toolbarHeight: 100.0,
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : AlphabetScrollView(
//               list: list.map((e) => AlphaModel(e)).toList(),
//               alignment: LetterAlignment.right,
//               itemExtent: 50,
//               unselectedTextStyle: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Colors.red),
//               selectedTextStyle: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Colors.grey),
//               overlayWidget: (value) => Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         height: 65,
//                         width: 65,
//                         decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.circular(10)),
//                       ),
//                       Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         alignment: Alignment.center,
//                         child: Center(
//                           child: Text(
//                             '$value'.toUpperCase(),
//                             style: TextStyle(fontSize: 18, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//               itemBuilder: (
//                 _,
//                 index,
//                 id,
//               ) {
//                 final currentName = list[index];
//                 final previousName = index > 0 ? list[index - 1] : null;
//                 final isFirstItemWithNewCharacter = previousName == null ||
//                     currentName[0].toUpperCase() !=
//                         previousName[0].toUpperCase();
//                 if (isFirstItemWithNewCharacter) {
//                   return ListTile(
//                     title: Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                       ),
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.only(right: 20),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           currentName[0].toUpperCase(),
//                           style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Colors.white,
//                             fontSize: 22,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return ListTile(
//                     title: Text(currentName),
//                   );
//                 }
//               }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> list = [];
  List<String> filteredList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("http://www.kbmusique.com/api/bands.php"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final bands = jsonData['bands'] as List<dynamic>;
      setState(() {
        list = bands.map((band) => band['name'].toString()).toList();
        filteredList = list; // Initialize filteredList with the full list
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  void filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show the entire list.
        filteredList = list;
      } else {
        // Filter the list based on the full band name.
        filteredList = list
            .where((name) => name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/img.png",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: AppBar(
                leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
              ),
            ),
          ],
        ),
        toolbarHeight: 100.0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterList(query); // Call filterList on text change
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Search',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AlphabetScrollView(
                    list: filteredList.map((e) => AlphaModel(e)).toList(),
                    alignment: LetterAlignment.right,
                    itemExtent: 50,
                    unselectedTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                    selectedTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    overlayWidget: (value) => Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              '$value'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    itemBuilder: (
                      _,
                      index,
                      id,
                    ) {
                      final currentName = filteredList[index];
                      final previousName =
                          index > 0 ? filteredList[index - 1] : null;
                      final isFirstItemWithNewCharacter =
                          previousName == null ||
                              currentName[0].toUpperCase() !=
                                  previousName[0].toUpperCase();
                      if (isFirstItemWithNewCharacter) {
                        return ListTile(
                          title: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.red,
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(right: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currentName[0].toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(currentName),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}


  azlistview: ^2.0.0
  alphabet_scroll_view: ^0.3.2
