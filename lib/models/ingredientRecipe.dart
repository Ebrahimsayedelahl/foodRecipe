import 'package:food_recipe_app/models/ingredients.dart';
class RecipeInformation {
  final List<Ingredient> recipes;
  final int readyInMinutes;
  final String summary;

  RecipeInformation({
    required this.recipes,
    required this.readyInMinutes,
    required this.summary,
  });

  factory RecipeInformation.fromJson(Map<String, dynamic> json) {
    return RecipeInformation(
      recipes: (json['recipes'] as List).map((recipeData) => Ingredient.fromJson(recipeData)).toList(),
      readyInMinutes: json['readyInMinutes'],
      summary: json['summary'],
    );
  }
}
