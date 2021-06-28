class NutritionPlan {
  NutritionPlan({
    this.id,
    this.protein,
    this.carbs,
    this.fats,
    this.calories,
  });

  int id;
  double protein;
  double carbs;
  double fats;
  double calories;

  factory NutritionPlan.fromJson(Map<String, dynamic> json) => NutritionPlan(
        id: json["id"],
        protein: json["protein"],
        carbs: json["carbs"],
        fats: json["fats"],
        calories: json["calories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "protein": protein,
        "carbs": carbs,
        "fats": fats,
        "calories": calories,
      };
}
