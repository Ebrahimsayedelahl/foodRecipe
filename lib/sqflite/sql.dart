import 'package:food_recipe_app/sqflite/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String columnId = 'id';
final String columnTitle = 'title';
final String columnURL = 'url';
final String recipesTable = 'recipes_table';

class Sql {
  late Database db;

  static final Sql instance = Sql._internal();

  factory Sql() {
    return instance;
  }

  Sql._internal();

  Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'contact.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $recipesTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnURL TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<Recipes> insertRecipe(Recipes recipes) async {
    recipes.id = await db.insert( recipesTable, recipes.toMap());
    return recipes;
  }

  Future<int> updateRecipes(Recipes recipes) async {
    return await db.update(
      recipesTable,
      recipes.toMap(),
      where: '$columnId = ?',
      whereArgs: [recipes.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    return await db.delete(
      recipesTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipes>> getAllRecipes() async {
    List<Map<String, dynamic>> recipesMaps = await db.query(recipesTable);
    if (recipesMaps.length == 0) {
      return [];
    } else {
      List<Recipes> recipes = [];
      for (var element in recipesMaps) {
        recipes.add(Recipes.fromMap(element));
      }
      return recipes;
    }
  }

  Future close() async => db.close();


}