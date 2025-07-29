import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  static const String _favoriteRecipesKey = 'favoriteRecipes';
  static final RecipeService _instance = RecipeService._internal();

  factory RecipeService() => _instance;

  RecipeService._internal();

  Future<void> saveFavoriteStatus(String recipeName, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, bool> favorites = await getFavorites();
    favorites[recipeName] = isFavorite;
    await prefs.setString(_favoriteRecipesKey, jsonEncode(favorites));
  }

  Future<Map<String, bool>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoriteRecipesKey);
    if (favoritesJson == null) return {};

    Map<String, dynamic> favorites = jsonDecode(favoritesJson);
    return favorites.map((key, value) => MapEntry(key, value as bool));
  }
}