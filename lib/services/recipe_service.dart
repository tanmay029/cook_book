import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeService {
  static const String _favoriteRecipesKey = 'favoriteRecipes';
  static const String _savedRecipesKey = 'savedRecipes';

  static final RecipeService _instance = RecipeService._internal();

  factory RecipeService() => _instance;

  RecipeService._internal();

  // Favorite status methods (your existing ones)
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

  // New method: Save full list of recipes locally
  Future<void> saveRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> recipesJson = recipes.map((r) => r.toJson()).toList();
    await prefs.setString(_savedRecipesKey, jsonEncode(recipesJson));
  }

  // New method: Load saved recipes
  Future<List<Recipe>> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesString = prefs.getString(_savedRecipesKey);
    if (recipesString == null) return [];

    List<dynamic> jsonList = jsonDecode(recipesString);
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }
}
