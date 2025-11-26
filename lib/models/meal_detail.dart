class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final List<Map<String, String>> ingredients; // [{ingredient, measure}]
  final String? youtubeUrl;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
    this.youtubeUrl,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<Map<String, String>> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final meas = json['strMeasure$i'];

      if (ing != null &&
          ing.toString().trim().isNotEmpty &&
          meas != null &&
          meas.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ing.toString(),
          'measure': meas.toString(),
        });
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      youtubeUrl: json['strYoutube'],
    );
  }
}
