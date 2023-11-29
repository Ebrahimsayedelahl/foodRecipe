import 'package:food_recipe_app/models/recipe.dart';

class RandomRecipeResponse {
  final List<Recipe> recipes;

  RandomRecipeResponse({required this.recipes});

  factory RandomRecipeResponse.fromJson(Map<String, dynamic> json) {
    final List<Recipe> recipes = (json['results'] as List)
        .map((recipeData) => Recipe.fromJson(recipeData))
        .toList();

    return RandomRecipeResponse(recipes: recipes);
  }
}
