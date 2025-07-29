import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

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
              background: Image.asset(widget.recipe.image, fit: BoxFit.cover),
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
                  ...widget.recipe.ingredients.map(
                    (ingredient) => _buildIngredientItem(ingredient),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ...widget.recipe.instructions.asMap().entries.map(
                    (entry) =>
                        _buildInstructionItem(entry.key + 1, entry.value),
                  ),
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

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(child: Text(ingredient, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(int index, String instruction) {
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
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(instruction, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
