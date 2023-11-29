import 'package:flutter/material.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'package:food_recipe_app/recipePage.dart';
import 'package:food_recipe_app/sqflite/model.dart';
import 'package:food_recipe_app/sqflite/sql.dart';
import 'homeScreen.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});


  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  late List<Recipes> recipesList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Favorite Recipe',
          style: TextStyle(color: Color(0xFF02967B), fontSize: 30),
        ),
        leading: Icon(Icons.view_headline_sharp, color: Color(0xFF02967B),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Color(0xFF02967B)),
          )
        ],
      ),
      body: FutureBuilder<List<Recipes>>(
        future: Sql.instance.getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            recipesList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                  childAspectRatio: 0.7
              ),
              itemCount: recipesList.length,
              itemBuilder: (context, index) {
                Recipes recipe = recipesList[index];
                return Card(
                  child: InkWell(
                    onTap: ()async {
                      await Sql.instance.deleteRecipe(recipe.id!);
                      setState(() {

                      });

                    },
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(recipe.imageURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(recipe.recipeTitle),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
