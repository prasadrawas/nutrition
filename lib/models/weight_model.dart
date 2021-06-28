class WeightModel {
  WeightModel({
    this.id,
    this.day,
    this.date,
    this.weight,
  });

  int id;
  String day;
  int date;
  double weight;

  factory WeightModel.fromJson(Map<String, dynamic> json) => WeightModel(
        id: json["id"],
        day: json["day"],
        date: json["date"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "date": date,
        "weight": weight,
      };
}
