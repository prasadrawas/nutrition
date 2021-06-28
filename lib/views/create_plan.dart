import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/nutrion_plan_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/create_weight.dart';

class CreatePlan extends StatelessWidget {
  final protein = TextEditingController();
  final carbs = TextEditingController();
  final fats = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      pageTitle('My nutrition plan', height(context)),
                      SizedBox(
                        height: 30,
                      ),
                      AltText(height(context), 'Enter your requirements'),
                      NumberInputBox(height(context), 'Protein', protein),
                      NumberInputBox(height(context), 'Carbs', carbs),
                      NumberInputBox(height(context), 'Fats', fats),
                      CreatePlanButton(height(context)),
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
                      AltText(width(context), 'Edit my plan'),
                      SizedBox(
                        height: 30,
                      ),
                      NumberInputBox(width(context), 'Protein', protein),
                      NumberInputBox(width(context), 'Carbs', carbs),
                      NumberInputBox(width(context), 'Fats', fats),
                      CreatePlanButton(width(context)),
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

  Widget CreatePlanButton(double height) {
    return GetBuilder<LoadingController>(builder: (controller) {
      return Container(
          height: height * 0.060,
          width: height * 0.3,
          margin: EdgeInsets.all(40),
          child: ElevatedButton(
              style: buttonStyle(),
              onPressed: controller.loading
                  ? () {
                      controller.setLoadingFalse();
                    }
                  : () async {
                      if (_formKey.currentState.validate()) {
                        await createPlan(controller);
                      }
                    },
              child: ButtonText(controller, 'Creating', 'Create my plan')));
    });
  }

  Future createPlan(LoadingController controller) async {
    controller.setLoadingTrue();
    double pro = double.parse(protein.text.trim()).toPrecision(4);
    double carb = double.parse(carbs.text.trim()).toPrecision(4);
    double fat = double.parse(fats.text.trim()).toPrecision(4);
    double calorie = ((pro * 4) + (carb * 4) + (fat * 9)).toPrecision(4);

    NutritionPlan required = NutritionPlan(
        id: 1, protein: pro, carbs: carb, fats: fat, calories: calorie);

    NutritionPlan available =
        NutritionPlan(id: 2, protein: 0, carbs: 0, fats: 0, calories: 0);
    var result =
        await DatabaseHelper().insertNutritionPlan([required, available]);
    controller.setLoadingFalse();
    if (result == 1) {
      Get.offAll(() => CreateWeight(),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 400));
    } else {
      Get.rawSnackbar(title: 'Failed', message: result.toString());
    }
  }
}
