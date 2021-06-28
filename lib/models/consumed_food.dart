class ConsumedFoodModel {
  ConsumedFoodModel(
      {this.id,
      this.name,
      this.protein,
      this.carbs,
      this.fats,
      this.calories,
      this.weight});

  int id;
  String name;
  double protein;
  double carbs;
  double fats;
  double calories;
  double weight;

  factory ConsumedFoodModel.fromJson(Map<String, dynamic> json) =>
      ConsumedFoodModel(
        id: json["id"],
        name: json["name"],
        protein: json["protein"],
        carbs: json["carbs"],
        fats: json["fats"],
        calories: json["calories"],
        weight: json["Weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "protein": protein,
        "carbs": carbs,
        "fats": fats,
        "calories": calories,
        "Weight": weight,
      };
}
