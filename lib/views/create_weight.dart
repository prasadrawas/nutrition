import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/weight_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/home.dart';
import 'package:nutrition_app/views/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateWeight extends StatelessWidget {
  final weight = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: width(context),
            child: LayoutBuilder(
              builder: (_, __) {
                if (orientation(context) == Orientation.portrait) {
                  return Column(
                    children: [
                      screenTitle('Weight Details', height(context)),
                      WeightForm(height(context)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      screenTitle('Weight Details', width(context)),
                      WeightForm(width(context)),
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

  Widget WeightForm(double height) {
    return Container(
      height: height * 0.6,
      child: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AltText(height, 'Your current weight'),
            NumberInputBox(height, 'Weight', weight, unit: 'kg'),
            AddWeightButton(height),
          ],
        ),
      ),
    );
  }

  Widget AddWeightButton(double height) {
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
                      if (_key.currentState.validate()) {
                        DateTime dateTime = DateTime.now();
                        WeightModel weigh = WeightModel(
                            id: null,
                            weight: double.parse(weight.text.trim()),
                            day: weekDay(dateTime.weekday),
                            date: dateTime.millisecondsSinceEpoch);

                        var result =
                            await DatabaseHelper().addWeightData(weigh);
                        if (result == 1) {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setBool('alreadyLogin', true);
                          Get.offAll(() => Home(),
                              transition: Transition.topLevel,
                              duration: Duration(milliseconds: 300));
                        } else {
                          Get.rawSnackbar(
                              title: 'Failed to add',
                              message: result.toString());
                        }
                      }
                    },
              child: ButtonText(controller, 'Adding', 'Add Weight')));
    });
  }
}
