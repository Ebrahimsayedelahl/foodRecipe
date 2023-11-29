import 'package:flutter/material.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'package:food_recipe_app/recipePage.dart';
import 'package:food_recipe_app/sqflite/sql.dart';
import 'package:http/http.dart 'as http;
import 'dart:convert';
import 'package:food_recipe_app/sqflite/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipes> recipesList = [];
  Color _iconColor = Colors.white60;
  late Future<List<Recipe>> recipeData;

  @override
  void initState() {
    super.initState();
    recipeData = getAllRecipes();
  }

  Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(Uri.parse('https://api.spoonacular.com/recipes/complexSearch?apiKey=0e23042aa4de4d36b6bed556e81d0afe&number=20'));

    if (response.statusCode == 200) {
      final List<dynamic> recipeDataList = json.decode(response.body)['results'];
      final List<Recipe> recipes = recipeDataList.map((recipeData) => Recipe.fromJson(recipeData)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load random recipe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Home',style: TextStyle(color: Color(0xFF02967B),fontSize: 35),),
        leading: Icon(Icons.view_headline_sharp,color: Color(0xFF02967B),),
          actions: [
          IconButton(
          onPressed: () {

    },
      icon: const Icon(Icons.search,color: Color(0xFF02967B),),
    )
        ]

      ) ,

      body: Center(
        child: FutureBuilder(
          future: recipeData,
          builder:( context,  snapshot) {
            if(snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final recipe = snapshot.data![index];
                  return Stack(children: [
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context
                            ,MaterialPageRoute(
                              builder: (context) => RecipePage(recipe: recipe),
                            ),
                          );
                        },
                        child: Column(
                          children: [

                            Stack(
                              children:[
                                Container(
                                width: 200,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(recipe.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white24,),
                                    child: IconButton(
                                      onPressed: () async{
                                        await Sql.instance.insertRecipe(
                                         Recipes(
                                             recipeTitle: recipe.title,
                                             imageURL: recipe.image),
                                        );
                                        setState(() {
                                          setState(() {
                                            _iconColor = Colors.red;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.favorite,color: _iconColor,),
                                    ),
                                  ),
                                )
                            ]),
                            SizedBox(height: 10),
                            Text(recipe.title),
                          ],
                        ),
                      ),
                    ),

                  ],

                  );
                },
              );


            }else if(snapshot.hasError){
              return Text('${snapshot.hasError}',style: TextStyle(color: Colors.red));

            }
            return const CircularProgressIndicator();
          },
        ) ,
      ),

      );
  }
}
