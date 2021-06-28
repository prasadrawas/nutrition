import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/controllers/statsController.dart';
import 'package:nutrition_app/models/consumed_food.dart';
import 'package:nutrition_app/models/food_model.dart';
import 'package:nutrition_app/models/nutrion_plan_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/add_food.dart';

class Nutrition extends StatefulWidget {
  @override
  _NutritionState createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  final pageController = PageController(initialPage: 0);
  final pageTitles = ['Protein', 'Carbs', 'Fats', 'Calories'];
  final _formKey = GlobalKey<FormState>();
  Food selectedFood;
  DatabaseHelper helper = DatabaseHelper();
  final quant = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (_, __) {
        if (orientation(context) == Orientation.portrait) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              screenTitle('Daily nutrition count', height(context)),
              StatsPageView(height(context)),
              ConsumedFood(height(context)),
              AddCountButton(height(context)),
              ResetButton(width(context)),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              screenTitle('Daily nutrition count', width(context)),
              StatsPageView(width(context)),
              ConsumedFood(width(context)),
              AddCountButton(width(context)),
              ResetButton(width(context)),
            ],
          );
        }
      }),
    );
  }

  Widget StatsPageView(double height) {
    return GetBuilder<StatsController>(builder: (controller) {
      return Column(
        children: [
          FutureBuilder(
              future: getNutritionPlan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: height * 0.4,
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      onPageChanged: (int i) {
                        controller.setPageIndex(i);
                      },
                      controller: pageController,
                      children: [
                        StatPage(height, 0, 'protein', 0, 'g'),
                        StatPage(height, 0, 'carbs', 0, 'g'),
                        StatPage(height, 0, 'fats', 0, 'g'),
                        StatPage(height, 0, 'calories', 0, 'Kcal'),
                      ],
                    ),
                  );
                }
                // print(snapshot.data.toString());
                NutritionPlan required =
                    NutritionPlan.fromJson(snapshot.data[0]);
                NutritionPlan available =
                    NutritionPlan.fromJson(snapshot.data[1]);
                return Container(
                  height: height * 0.4,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (int i) {
                      controller.setPageIndex(i);
                    },
                    controller: pageController,
                    children: [
                      StatPage(height, available.protein, 'protein',
                          required.protein, 'g'),
                      StatPage(height, available.carbs, 'carbs', required.carbs,
                          'g'),
                      StatPage(
                          height, available.fats, 'fats', required.fats, 'g'),
                      StatPage(height, available.calories, 'calories',
                          required.calories, 'Kcal'),
                    ],
                  ),
                );
              }),
          Container(
            width: height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 7,
                  width: (index == controller.index) ? 50 : 20,
                  decoration: BoxDecoration(
                    color: (index == controller.index)
                        ? btnColor
                        : btnColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),
          Container(
            width: height * 0.4,
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: (index == controller.index) ? 1 : 0.3,
                  child: Text(
                    pageTitles[index],
                    style: TextStyle(
                        color: textColor,
                        fontSize: (index == controller.index)
                            ? height * 0.035
                            : height * 0.015),
                  ),
                );
              }),
            ),
          )
        ],
      );
    });
  }

  Widget ExpansionTitle() {
    return Text(
      "Food you've consumed",
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: textColor),
    );
  }

  Widget ConsumedFood(double height) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: FutureBuilder(
          future: getAllConsumedFood(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false)
              return ExpansionTile(
                title: ExpansionTitle(),
                children: [
                  Text("You haven't consumed any food yet"),
                ],
              );
            else {
              List<ConsumedFoodModel> consumedFood = [];
              for (int i = 0; i < snapshot.data.length; i++) {
                consumedFood.add(ConsumedFoodModel.fromJson(snapshot.data[i]));
              }
              if (consumedFood.length == 0)
                return ExpansionTile(
                  title: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ExpansionTitle(),
                  ),
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text("You haven't consumed any food yet")),
                  ],
                );
              return ExpansionTile(
                title: ExpansionTitle(),
                children: consumedFood.map((e) {
                  return ConsumedFoodCard(height, e);
                }).toList(),
              );
            }
          }),
    );
  }

  Widget StatPage(double height, double available, String name, double required,
      String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${available == 0 ? 0 : available.toPrecision(4)}',
              style: TextStyle(
                  color: textColor,
                  fontSize: height * 0.080,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '$unit',
              style: TextStyle(
                  color: textColor,
                  fontSize: height * 0.020,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Container(
            padding: EdgeInsets.only(top: height * 0.1),
            child: available >= required
                ? Text(
                    'Your daily $name requirements are completed.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: btnColor),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text:
                                '${(required - available).toPrecision(2)} $unit ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        TextSpan(
                          text: 'more $name is ',
                        ),
                        TextSpan(
                            text: 'required ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        TextSpan(
                          text: 'out of ',
                        ),
                        TextSpan(
                            text: '${(required).toPrecision(2)} $unit',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )),
      ],
    );
  }

  Widget AddCountButton(double height) {
    return Container(
        height: height * 0.060,
        width: height * 0.3,
        margin: EdgeInsets.all(40),
        child: ElevatedButton(
            style: buttonStyle(),
            onPressed: () async {
              Get.defaultDialog(
                title: 'Add your daily count',
                content: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: FutureBuilder(
                      future: getAllFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 80,
                          );
                        }

                        if (snapshot.data.length == 0) {
                          return AddFoodMessage();
                        } else {
                          return AddCountForm(snapshot, height);
                        }
                      }),
                ),
              );
            },
            child: Text("Add today's count")));
  }

  Container AddFoodMessage() {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "You haven't added any food yet !!!",
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                Get.back();
                Get.to(() => AddFood(),
                    transition: Transition.topLevel,
                    duration: Duration(milliseconds: 300));
              },
              child: Text(
                'Add food',
                style: TextStyle(color: btnColor),
              ))
        ],
      ),
    );
  }

  Form AddCountForm(AsyncSnapshot snapshot, double height) {
    List<Food> foodList = [];
    for (var food in snapshot.data) {
      foodList.add(Food.fromJson(food));
    }
    selectedFood = foodList[0];
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, top: 10, bottom: 7),
            child: Text(
              'Select food',
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonFormField<Food>(
              decoration: InputDecoration.collapsed(hintText: ''),
              value: selectedFood,
              hint: Text('Select food'),
              onChanged: (s) {
                selectedFood = s;
              },
              items: foodList.map((Food f) {
                return DropdownMenuItem(
                  value: f,
                  child: Text(f.name),
                );
              }).toList(),
            ),
          ),
          NumberInputBox(height, 'Quantity', quant),
          AddFoodButton(height),
        ],
      ),
    );
  }

  Widget ResetButton(double height) {
    return TextButton(
      onPressed: () {
        sadDialogBox(resetData, closeDialog, 'Do you really want to reset ? ');
      },
      child: Text(
        'Reset',
        style: TextStyle(color: btnColor),
      ),
    );
  }

  void resetData() async {
    var result = await helper.resetDailyNutrition(2);
    var res = await helper.resetConsumedFood();
    Get.back();
    if (result != 1) {
      Get.rawSnackbar(title: 'Failed to reset', message: result.toString());
    } else {
      if (mounted) {
        setState(() {});
      }
      snackBar('Success', 'Nutrition count reset successfully.');
    }
  }

  void closeDialog() {
    Get.back();
  }

  Widget AddFoodButton(double height) {
    return GetBuilder<LoadingController>(builder: (controller) {
      return Container(
          height: height * 0.060,
          width: height * 0.3,
          margin: EdgeInsets.all(40),
          child: ElevatedButton(
              style: buttonStyle(),
              onPressed: controller.loading
                  ? () {}
                  : () async {
                      if (_formKey.currentState.validate()) {
                        DatabaseHelper helper = DatabaseHelper();
                        double quantity =
                            double.parse(quant.text.trim()).toPrecision(4);
                        var available = await helper.getAvailableNutrtionData();
                        double pro =
                            (selectedFood.protein * quantity).toPrecision(4);
                        double carb =
                            (selectedFood.carbs * quantity).toPrecision(4);
                        double fat =
                            (selectedFood.fats * quantity).toPrecision(4);
                        double calorie =
                            ((pro * 4) + (carb * 4) + (fat * 9)).toPrecision(4);
                        NutritionPlan plan = NutritionPlan(
                            id: 2,
                            protein: (pro) + available['protein'],
                            carbs: (carb) + available['carbs'],
                            calories: (calorie) + available['calories'],
                            fats: (fat) + available['fats']);

                        print(quantity);
                        ConsumedFoodModel consumed = ConsumedFoodModel(
                            id: null,
                            name: selectedFood.name,
                            protein: pro,
                            carbs: carb,
                            fats: fat,
                            calories: calorie,
                            weight: quantity);

                        var result = await helper.addTodaysCount(plan);
                        var res = await helper.insertConsumedFood(consumed);
                        if (mounted) {
                          setState(() {
                            Get.back();
                          });
                        }
                        if (result != 1) {
                          snackBar('Failed', result);
                        } else {
                          snackBar('Success', 'Count added to list');
                        }
                      }
                    },
              child: ButtonText(controller, 'Adding', 'Add count')));
    });
  }

  Future<dynamic> getNutritionPlan() async {
    var result = await helper.retrieveNutritionPlan();
    return result;
  }

  Future<dynamic> getAllFoods() async {
    var result = await helper.retrieveFoods();
    return result;
  }

  Future<dynamic> getAllConsumedFood() async {
    var result = await helper.retrieveAllConsumedFood();
    return result;
  }
}
