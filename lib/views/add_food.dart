import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/food_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';

class AddFood extends StatelessWidget {
  final foodName = TextEditingController();
  final protein = TextEditingController();
  final carbs = TextEditingController();
  final fats = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: width(context),
            child: LayoutBuilder(builder: (_, __) {
              if (orientation(context) == Orientation.portrait) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pageTitle('Add new food', height(context)),
                      AltText(height(context)),
                      TextInputBox(height(context), 'Food name', foodName),
                      NumberInputBox(
                          height(context), 'Protein (per g)', protein),
                      NumberInputBox(height(context), 'Carbs (per g)', carbs),
                      NumberInputBox(height(context), 'Fats (per g)', fats),
                      AddFoodButton(height(context)),
                    ],
                  ),
                );
              } else {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pageTitle('Add new food', width(context)),
                      AltText(width(context)),
                      TextInputBox(width(context), 'Food name', foodName),
                      NumberInputBox(
                          width(context), 'Protein (per g)', protein),
                      NumberInputBox(width(context), 'Carbs (per g)', carbs),
                      NumberInputBox(width(context), 'Fats (per g)', fats),
                      AddFoodButton(width(context)),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget AltText(double height) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 25, top: 10),
      child: Text(
        'Enter food details',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
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
                        await addFood(height);
                      }
                    },
              child: ButtonText(controller, 'Adding', 'Add food')));
    });
  }

  Future addFood(double height) async {
    String name = foodName.text.trim();
    double pro = double.parse(protein.text.trim()).toPrecision(4);
    double carb = double.parse(carbs.text.trim()).toPrecision(4);
    double fat = double.parse(fats.text.trim()).toPrecision(4);
    double calorie = ((pro * 4) + (carb * 4) + (fat * 9)).toPrecision(4);
    Food food = Food(
        name: name, protein: pro, fats: fat, calories: calorie, carbs: carb);
    var result = await DatabaseHelper().insertFood(food);
    if (result == 1) {
      protein.clear();
      carbs.clear();
      foodName.clear();
      fats.clear();
      snackBar('Success', 'Food added to list');
    } else {
      snackBar('Failed to add', result);
    }
  }

  void closeDialog() {
    Get.back();
  }
}
