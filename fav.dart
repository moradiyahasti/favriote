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





