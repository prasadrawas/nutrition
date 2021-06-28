class Food {
  Food({
    this.id,
    this.name,
    this.protein,
    this.carbs,
    this.fats,
    this.calories,
  });

  int id;
  String name;
  double protein;
  double carbs;
  double fats;
  double calories;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"],
        name: json["name"],
        protein: json["protein"],
        carbs: json["carbs"],
        fats: json["fats"],
        calories: json["calories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "protein": protein,
        "carbs": carbs,
        "fats": fats,
        "calories": calories,
      };
}
