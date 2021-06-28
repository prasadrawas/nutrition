import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/food_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';

class FoodDetails extends StatefulWidget {
  final int id;
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FoodDetails(this.id);

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final foodName = TextEditingController();
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
          child: Container(
            child: LayoutBuilder(
              builder: (_, __) {
                if (orientation(context) == Orientation.portrait) {
                  return Column(
                    children: [
                      screenTitle('Food Details', height(context)),
                      FoodData(height(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      screenTitle('Food Details', height(context)),
                      FoodData(width(context)),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget FoodData(double height) {
    return FutureBuilder(
      future: getFoodDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Container(
            height: height - 100,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        Food food = Food.fromJson(snapshot.data);
        return Column(
          children: [
            FoodCard(height, food),
            SizedBox(
              height: 20,
            ),
            EditFoodDataForm(height, food)
          ],
        );
      },
    );
  }

  Widget EditFoodDataForm(double height, Food food) {
    if (flag) {
      initializeController(food);
      flag = false;
    }
    return Form(
      key: FoodDetails._key,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            AltText(height, 'Edit food data'),
            Container(
              margin: EdgeInsets.only(right: 15),
              child: TextButton(
                  onPressed: () {
                    sadDialogBox(deleteFood, closeDialog,
                        'Do you really want to delete ?');
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
            )
          ]),
          TextInputBox(height, 'Food name', foodName),
          NumberInputBox(height, 'Protein (per gm)', protein),
          NumberInputBox(height, 'Carbs (per gm)', carbs),
          NumberInputBox(height, 'Fats (per gm)', fats),
          EditFoodButton(height),
        ],
      ),
    );
  }

  void closeDialog() {
    Get.back();
  }

  void deleteFood() async {
    var result = await DatabaseHelper().deleteFoodById(widget.id);
    if (result == 1) {
      Get.back();
      Get.back();
      setState(() {});
    } else {
      Get.rawSnackbar(title: 'Failed to delete', message: result);
    }
  }

  void initializeController(Food food) {
    protein.text = food.protein.toString();
    carbs.text = food.carbs.toString();
    fats.text = food.fats.toString();
    foodName.text = food.name;
    protein.selection =
        TextSelection.fromPosition(TextPosition(offset: protein.text.length));
    carbs.selection =
        TextSelection.fromPosition(TextPosition(offset: carbs.text.length));
    fats.selection =
        TextSelection.fromPosition(TextPosition(offset: fats.text.length));
    foodName.selection =
        TextSelection.fromPosition(TextPosition(offset: foodName.text.length));
  }

  Widget EditFoodButton(double height) {
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
                      if (FoodDetails._key.currentState.validate()) {
                        double pro =
                            double.parse(protein.text.trim()).toPrecision(4);
                        double carb =
                            double.parse(carbs.text.trim()).toPrecision(4);
                        double fat =
                            double.parse(fats.text.trim()).toPrecision(4);
                        double calorie =
                            ((pro * 4) + (carb * 4) + (fat * 9)).toPrecision(4);
                        Food food = Food(
                            id: widget.id,
                            name: foodName.text.trim(),
                            protein: pro,
                            carbs: carb,
                            fats: fat,
                            calories: calorie);

                        var result = await DatabaseHelper()
                            .updateFoodData(widget.id, food);
                        if (result == 1) {
                          operationSuccessDialogBox(height, closeDialog,
                              closeDialog, 'Updated Successfully');
                        } else {
                          Get.rawSnackbar(
                              title: 'Failed to update',
                              message: result.toString());
                        }
                      }
                    },
              child: ButtonText(controller, 'Saving', 'Save')));
    });
  }

  Future<dynamic> getFoodDetails() async {
    var result = await DatabaseHelper().retrieveFoodById(widget.id);
    return result[0];
  }
}
