import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final List<Recipe> uploadedRecipes;

  ProfileScreen({
    required this.userName,
    required this.userEmail,
    required this.uploadedRecipes,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Recipe> _savedRecipes;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesMap = await _recipeService.getFavorites();
    // Filter saved recipes from all uploaded via matching names
    _savedRecipes = widget.uploadedRecipes
        .where((r) => favoritesMap[r.name] == true)
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final uploadedCount = widget.uploadedRecipes.length;
    final email = widget.userEmail;
    final userName = widget.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Text('Name:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(userName, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),

            Text('Email:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(email, style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),

            // Recipes uploaded
            Text('Recipes Uploaded:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$uploadedCount', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),

            // Saved Recipes button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(
                        recipes: widget.uploadedRecipes,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Saved Recipes', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
