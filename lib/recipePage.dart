import 'package:flutter/material.dart';
import 'package:food_recipe_app/models/ingredients.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food_recipe_app/models/ingredientRecipe.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  RecipePage({required this.recipe});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int count = 0;
  late Future<List<RecipeInformation>> recipeData;

  @override
  void initState() {
    super.initState();
    recipeData = getAllIngredients();
  }

  Future<List<RecipeInformation>> getAllIngredients() async {
    final response = await http.get(Uri.parse('https://api.spoonacular.com/recipes/${widget.recipe.id}/information?apiKey=0e23042aa4de4d36b6bed556e81d0afe'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> recipeData = json.decode(response.body);
      final List<Ingredient> ingredients = (recipeData['extendedIngredients'] as List)
          .map((ingredientData) => Ingredient.fromJson(ingredientData))
          .toList();
      final RecipeInformation recipeInformation = RecipeInformation(
        recipes: ingredients,
        readyInMinutes: recipeData['readyInMinutes'],
        summary: recipeData['summary'],
      );
      return [recipeInformation]; // Wrap the single recipeInformation in a list
    } else {
      throw Exception('Failed to load random recipe');
    }
  }

  void decrementCount() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF02967B),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: recipeData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ingredient = snapshot.data![index];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(widget.recipe.image),
                      const SizedBox(height: 15),
                      Text(
                        widget.recipe.title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF02967B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Center(child: Text('Easy')),
                          ),
                          Container(
                            height: 60,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.watch_later_outlined, size: 19, color: Color(0xFF02967B)),
                                Text('${ingredient.readyInMinutes} mins'),
                              ],
                            )
                          ),
                          Container(
                            height: 60,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${ingredient.recipes.length} ', style: const TextStyle(color: Color(0xFF02967B),fontSize: 19)),
                                  Text(' indredients', style: const TextStyle(color: Colors.black))
                                ]),

                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        child:

                        Column(
                          children: [
                            Text('${ingredient.summary}'),

                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Text('$count serving', style: TextStyle(fontSize: 17)),
                                SizedBox(width: 150),
                                Container(
                                  height: 33,
                                  width: 33,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF02967B)),
                                  ),
                                  child: IconButton(
                                    iconSize: 18,
                                    onPressed: () {
                                      incrementCount();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  height: 33,
                                  width: 33,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF02967B)),
                                  ),
                                  child: IconButton(
                                    iconSize: 18,
                                    onPressed: () {
                                      decrementCount();
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                Text('Ingredients', style: TextStyle(color: Color(0xFF02967B), fontSize: 25)),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Container(
                              height: 400,
                              child: ListView.builder(
                                itemCount: ingredient.recipes.length,
                                itemBuilder: (context, index) {
                                  final currentIngredient = ingredient.recipes[index];
                                  return ListTile(
                                    leading: Icon(Icons.circle, size: 14, color: Color(0xFF02967B)),
                                    title: Text('${currentIngredient.amount} ${currentIngredient.unit} ${currentIngredient.name}', style: TextStyle(fontSize: 18)),
                                    subtitle: Text(" "),
                                  );
                                },
                              ),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}', style: TextStyle(color: Colors.red));
          }
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
