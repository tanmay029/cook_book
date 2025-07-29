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