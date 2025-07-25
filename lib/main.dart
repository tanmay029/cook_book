import 'package:flutter/material.dart';
// import 'package:shared_preferences.dart';
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

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Book',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[300]!, Colors.orange[600]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu, size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Cook Book',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Login',
                                          style: TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text('Don\'t have an account? Sign up'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate login delay
      await Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[300]!, Colors.orange[600]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your password';
                                }
                                if (value!.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Sign Up',
                                          style: TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate registration delay
      await Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}

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

  final List<Recipe> recipes = [
    Recipe(
      name: 'Spaghetti Carbonara',
      image:
          'https://images.unsplash.com/photo-1621996346565-e3dbc36d2844?w=500&h=300&fit=crop',
      cookTime: '20 min',
      difficulty: 'Medium',
      rating: 4.8,
      ingredients: [
        '400g spaghetti',
        '200g pancetta',
        '4 large eggs',
        '100g pecorino cheese',
        'Black pepper',
        'Salt',
      ],
      instructions: [
        'Cook spaghetti in salted boiling water until al dente.',
        'Fry pancetta in a large pan until crispy.',
        'Whisk eggs with grated cheese and black pepper.',
        'Drain pasta and add to pan with pancetta.',
        'Remove from heat and quickly stir in egg mixture.',
        'Serve immediately with extra cheese and pepper.',
      ],
    ),
    Recipe(
      name: 'Chicken Tikka Masala',
      image:
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500&h=300&fit=crop',
      cookTime: '45 min',
      difficulty: 'Hard',
      rating: 4.9,
      ingredients: [
        '500g chicken breast',
        '1 cup yogurt',
        '400ml coconut milk',
        '2 tbsp tikka masala paste',
        '1 onion',
        '3 cloves garlic',
        'Ginger',
        'Basmati rice',
      ],
      instructions: [
        'Marinate chicken in yogurt and spices for 30 minutes.',
        'Cook chicken in a hot pan until golden.',
        'Sauté onions, garlic, and ginger.',
        'Add tikka masala paste and cook for 2 minutes.',
        'Add coconut milk and simmer.',
        'Return chicken to pan and simmer for 15 minutes.',
        'Serve with basmati rice and naan bread.',
      ],
    ),
    Recipe(
      name: 'Caesar Salad',
      image:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500&h=300&fit=crop',
      cookTime: '15 min',
      difficulty: 'Easy',
      rating: 4.5,
      ingredients: [
        '1 large romaine lettuce',
        '100g parmesan cheese',
        '1 cup croutons',
        '2 anchovy fillets',
        '2 cloves garlic',
        '1 egg yolk',
        'Olive oil',
        'Lemon juice',
      ],
      instructions: [
        'Wash and chop romaine lettuce.',
        'Make dressing with anchovies, garlic, egg yolk, lemon juice, and olive oil.',
        'Toss lettuce with dressing.',
        'Add croutons and grated parmesan.',
        'Serve immediately.',
      ],
    ),
    Recipe(
      name: 'Chocolate Chip Cookies',
      image:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500&h=300&fit=crop',
      cookTime: '25 min',
      difficulty: 'Easy',
      rating: 4.7,
      ingredients: [
        '2¼ cups flour',
        '1 tsp baking soda',
        '1 cup butter',
        '¾ cup brown sugar',
        '¾ cup white sugar',
        '2 large eggs',
        '2 tsp vanilla',
        '2 cups chocolate chips',
      ],
      instructions: [
        'Preheat oven to 375°F (190°C).',
        'Mix flour and baking soda in a bowl.',
        'Cream butter and both sugars.',
        'Beat in eggs and vanilla.',
        'Gradually mix in flour mixture.',
        'Stir in chocolate chips.',
        'Drop spoonfuls on baking sheet and bake 9-11 minutes.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cook Book'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  PopupMenuItem(child: Text('Favorites'), value: 'favorites'),
                  PopupMenuItem(child: Text('Logout'), value: 'logout'),
                ],
            onSelected: (value) {
              if (value == 'favorites') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(recipes: recipes),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
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
                        hintText: 'Search recipes...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  // child: IconButton(
                  //   icon: Icon(Icons.tune, color: Colors.white),
                  //   onPressed: () {
                  //     // Filter functionality
                  //   },
                  // ),
                ),
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
                          child: Image.network(
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
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.recipe.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.restaurant,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  widget.recipe.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.recipe.isFavorite ? Colors.red : null,
                ),
                onPressed: () async {
                  setState(() {
                    widget.recipe.isFavorite = !widget.recipe.isFavorite;
                  });
                  await RecipeService().saveFavoriteStatus(
                    widget.recipe.name,
                    widget.recipe.isFavorite,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Share recipe
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(Icons.access_time, widget.recipe.cookTime),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.signal_cellular_alt,
                        widget.recipe.difficulty,
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.star,
                        widget.recipe.rating.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ...widget.recipe.ingredients
                      .map(
                        (ingredient) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.fiber_manual_record,
                                size: 8,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  SizedBox(height: 24),
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ...widget.recipe.instructions.asMap().entries.map((entry) {
                    int index = entry.key;
                    String instruction = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              instruction,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.orange[700]),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> recipes;

  FavoritesScreen({required this.recipes});

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes =
        recipes.where((recipe) => recipe.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
        backgroundColor: Colors.orange,
      ),
      body:
          favoriteRecipes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No favorite recipes yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
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
                            child: Image.network(
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
    );
  }
}

class Recipe {
  final String name;
  final String image;
  final String cookTime;
  final String difficulty;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.image,
    required this.cookTime,
    required this.difficulty,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });

  // Convert recipe to JSON format
  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'cookTime': cookTime,
    'difficulty': difficulty,
    'rating': rating,
    'ingredients': ingredients,
    'instructions': instructions,
    'isFavorite': isFavorite,
  };

  // Create recipe from JSON format
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json['name'],
    image: json['image'],
    cookTime: json['cookTime'],
    difficulty: json['difficulty'],
    rating: json['rating'],
    ingredients: List<String>.from(json['ingredients']),
    instructions: List<String>.from(json['instructions']),
    isFavorite: json['isFavorite'],
  );
}
