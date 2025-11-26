class MealSummary {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
  });

  // од filter.php?c=
  factory MealSummary.fromFilterJson(Map<String, dynamic> json, String category) {
    return MealSummary(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      category: category,
    );
  }

  // од search.php?s=
  factory MealSummary.fromSearchJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      category: json['strCategory'],
    );
  }
}
