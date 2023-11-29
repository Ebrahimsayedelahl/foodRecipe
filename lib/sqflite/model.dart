import 'sql.dart';

class Recipes {
  int? id;
  late String recipeTitle;
  late String imageURL;

  Recipes({
    this.id,
    required this.recipeTitle,
    required this.imageURL,
  });

  Recipes.fromMap(Map<String, dynamic> map) {
    if (map[columnId] != null) id = map[columnId];
    recipeTitle = map[columnTitle];
    imageURL = map[columnURL];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnTitle] = recipeTitle;
    map[columnURL] = imageURL;

    return map;
  }
}