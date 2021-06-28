import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/models/nutrion_plan_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final protein = TextEditingController();
  final carbs = TextEditingController();
  final fats = TextEditingController();
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder(
              future: getNutritionPlan(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return Container(
                    height: height(context) - 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                NutritionPlan plan = NutritionPlan.fromJson(snapshot.data[0]);
                if (flag) {
                  initializeControllers(plan);
                  flag = false;
                }
                return Container(
                  width: width(context),
                  child: LayoutBuilder(
                    builder: (_, __) {
                      if (orientation(context) == Orientation.portrait) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            screenTitle('My nutrition plan', height(context)),
                            PlanCard(height(context), plan),
                            EditNutritionPlan(height(context)),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            screenTitle('My nutrition plan', height(context)),
                            PlanCard(width(context), plan),
                            EditNutritionPlan(width(context)),
                          ],
                        );
                      }
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }

  void initializeControllers(NutritionPlan plan) {
    protein.text = plan.protein.toString();
    carbs.text = plan.carbs.toString();
    fats.text = plan.fats.toString();
    protein.selection =
        TextSelection.fromPosition(TextPosition(offset: protein.text.length));
    carbs.selection =
        TextSelection.fromPosition(TextPosition(offset: carbs.text.length));
    fats.selection =
        TextSelection.fromPosition(TextPosition(offset: fats.text.length));
  }

  Widget EditNutritionPlan(double height) {
    return Column(
      children: [
        AltText(height, 'Edit my plan'),
        NumberInputBox(height, 'Protein (per g)', protein),
        NumberInputBox(height, 'Carbs (per g)', carbs),
        NumberInputBox(height, 'Fats (per g)', fats),
        EditPlanButton(height),
      ],
    );
  }

  Widget EditPlanButton(double height) {
    return Container(
        height: height * 0.060,
        width: height * 0.3,
        margin: EdgeInsets.all(40),
        child: ElevatedButton(
            style: buttonStyle(),
            onPressed: () async {
              savePlan(height);
            },
            child: Text("Save plan")));
  }

  Future savePlan(height) async {
    double pro = double.parse(protein.text.trim());
    double carb = double.parse(carbs.text.trim());
    double fat = double.parse(fats.text.trim());
    double calorie = ((pro * 4) + (carb * 4) + (fat * 9));
    NutritionPlan required = NutritionPlan(
        id: 1, protein: pro, calories: calorie, fats: fat, carbs: carb);
    var result = await DatabaseHelper().insertRequiredNutrition(required);

    if (result != 1) {
      Get.rawSnackbar(title: 'Failed to update', message: result);
    } else {
      operationSuccessDialogBox(
          height, closeDialog, closeDialog, 'Updated Successfully');
    }
  }

  void closeDialog() {
    if (mounted) {
      setState(() {
        Get.back();
      });
    }
  }

  Widget PlanCard(double height, NutritionPlan plan) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      padding: EdgeInsets.all(20),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Protein',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${plan.protein} g',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Carbs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${plan.carbs} g',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Fats',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${plan.fats} g',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Calories',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${plan.calories} Kcal',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> getNutritionPlan() async {
    var result = await DatabaseHelper().retrieveNutritionPlan();
    return result;
  }
}
