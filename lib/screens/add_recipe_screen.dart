import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  final void Function(Recipe) onRecipeAdded;

  AddRecipeScreen({required this.onRecipeAdded});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final picker = ImagePicker();
  File? _image;

  final _nameController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _instructionControllers = [];

  String _difficulty = 'Easy';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _cookTimeController.addListener(() {
      _updateDifficulty(_cookTimeController.text);
      _validateForm();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateDifficulty(String timeStr) {
    double? time = double.tryParse(timeStr);
    if (time == null || time <= 0) {
      _difficulty = 'Easy'; // default/fallback
    } else if (time <= 15) {
      _difficulty = 'Easy';
    } else if (time <= 30) {
      _difficulty = 'Medium';
    } else {
      _difficulty = 'Hard';
    }
    setState(() {});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Invalid Input'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _addIngredientField() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_validateForm);
      _ingredientControllers.add(controller);
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers[index].removeListener(_validateForm);
      _ingredientControllers.removeAt(index);
    });
    _validateForm();
  }

  void _addInstructionField() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_validateForm);
      _instructionControllers.add(controller);
    });
  }

  void _removeInstructionField(int index) {
    setState(() {
      _instructionControllers[index].removeListener(_validateForm);
      _instructionControllers.removeAt(index);
    });
    _validateForm();
  }

  void _validateForm() {
    final nameFilled = _nameController.text.trim().isNotEmpty;

    final cookTimeStr = _cookTimeController.text.trim();
    final cookTimeValid =
        double.tryParse(cookTimeStr) != null && double.parse(cookTimeStr) > 0;

    final ingredientsFilled = _ingredientControllers.any(
      (c) => c.text.trim().isNotEmpty,
    );
    final instructionsFilled = _instructionControllers.any(
      (c) => c.text.trim().isNotEmpty,
    );

    final isValid =
        nameFilled && cookTimeValid && ingredientsFilled && instructionsFilled;

    if (_isButtonEnabled != isValid) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  void _submitRecipe() {
    final name = _nameController.text.trim();
    final cookTime = _cookTimeController.text.trim();

    final ingredients =
        _ingredientControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();

    final instructions =
        _instructionControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();

    final newRecipe = Recipe(
      name: name,
      image: _image?.path ?? '',
      cookTime: '$cookTime min',
      difficulty: _difficulty,
      rating: 0,
      ingredients: ingredients,
      instructions: instructions,
      isFavorite: false,
    );

    widget.onRecipeAdded(newRecipe);
    Navigator.pop(context);
  }

  void _handleFinishPressed() {
    final name = _nameController.text.trim();
    final cookTimeStr = _cookTimeController.text.trim();
    final ingredients =
        _ingredientControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();
    final instructions =
        _instructionControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();

    if (name.isEmpty) {
      _showErrorDialog('Please enter the dish name.');
      return;
    }
    if (cookTimeStr.isEmpty) {
      _showErrorDialog('Please enter the cook time.');
      return;
    }
    final cookTime = double.tryParse(cookTimeStr);
    if (cookTime == null || cookTime <= 0) {
      _showErrorDialog('Cook time must be a positive number.');
      return;
    }
    if (ingredients.isEmpty) {
      _showErrorDialog('Please add at least one ingredient.');
      return;
    }
    if (instructions.isEmpty) {
      _showErrorDialog('Please add at least one instruction.');
      return;
    }

    _submitRecipe();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cookTimeController.dispose();
    _ingredientControllers.forEach((c) => c.dispose());
    _instructionControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe'), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish Name
            Text('Dish Name', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter dish name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Optional Image
            Text(
              'Upload Dish Image (optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child:
                    _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey[700],
                        ),
              ),
            ),
            SizedBox(height: 20),

            // Cook Time
            Text(
              'Cook Time (in minutes)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _cookTimeController,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 20',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Difficulty: $_difficulty',
              style: TextStyle(color: Colors.grey[700]),
            ),

            SizedBox(height: 24),

            // Ingredients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addIngredientField,
                ),
              ],
            ),
            ..._ingredientControllers.asMap().entries.map((entry) {
              int i = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          hintText: 'Ingredient ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeIngredientField(i),
                  ),
                ],
              );
            }),

            SizedBox(height: 24),

            // Instructions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Instructions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addInstructionField,
                ),
              ],
            ),
            ..._instructionControllers.asMap().entries.map((entry) {
              int i = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          hintText: 'Step ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeInstructionField(i),
                  ),
                ],
              );
            }),

            SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleFinishPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('Finish Recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
