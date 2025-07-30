import 'package:flutter/material.dart';
import 'package:recipe_book/screens/add_recipe_screen.dart';
import 'package:recipe_book/screens/profile_screen.dart';
import '../data/recipe_data.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'recipe_detail_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> _filteredRecipes;
  final TextEditingController _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _filteredRecipes = recipes;
    _searchController.addListener(_filterRecipes);
    _loadFavoriteStatuses();
  }

  Future<void> _loadFavoriteStatuses() async {
    final favorites = await _recipeService.getFavorites();
    setState(() {
      for (var recipe in recipes) {
        recipe.isFavorite = favorites[recipe.name] ?? false;
      }
      _filterRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          recipes.where((recipe) {
            return recipe.name.toLowerCase().contains(query) ||
                recipe.difficulty.toLowerCase().contains(query) ||
                recipe.ingredients.any(
                  (ingredient) => ingredient.toLowerCase().contains(query),
                );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s Cooking? Good Lookin'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search recipes or ingredients...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _filteredRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            recipe.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.restaurant,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    recipe.cookTime,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(
                                    Icons.signal_cellular_alt,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    recipe.difficulty,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    recipe.rating.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddRecipeScreen(
                    onRecipeAdded: (newRecipe) {
                      setState(() {
                        recipes.add(newRecipe);
                        _filterRecipes();
                      });
                    },
                  ),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(recipes: recipes),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProfileScreen(
                            userName: 'John Doe',
                            userEmail: 'johndoe@example.com',
                            uploadedRecipes: recipes,
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
