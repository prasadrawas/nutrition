import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/consumed_food.dart';
import 'package:nutrition_app/models/food_model.dart';

Color btnColor = Color(0xFF6200EA);
Color textColor = Color(0xFF212121);

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Orientation orientation(BuildContext context) {
  return MediaQuery.of(context).orientation;
}

Widget screenTitle(String text, double size) {
  return Text(
    text,
    style: TextStyle(
        height: 3,
        fontSize: size * 0.035,
        fontWeight: FontWeight.w600,
        color: textColor),
  );
}

Widget pageTitle(String text, double size) {
  return Text(
    text,
    style: TextStyle(
        height: 3,
        fontSize: size * 0.035,
        fontWeight: FontWeight.w600,
        color: textColor),
  );
}

ButtonStyle buttonStyle() {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    backgroundColor: MaterialStateProperty.all(btnColor),
  );
}

Widget TextInputBox(
    double height, String label, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.all(20),
    child: TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      validator: (s) {
        return s.trim().isEmpty ? 'Required' : null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    ),
  );
}

void operationSuccessDialogBox(
    height, Function confirm, Function cancel, String text) {
  Get.defaultDialog(
      title: text,
      titleStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      content: Container(
        child: Column(
          children: [
            Image.asset(
              'assets/images/happy.png',
              height: height * 0.25,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      textCancel: 'Okay',
      confirmTextColor: Colors.white,
      textConfirm: 'Close',
      onConfirm: confirm,
      onCancel: cancel);
}

void sadDialogBox(Function confirm, Function cancel, String text) {
  Get.defaultDialog(
      title: text,
      titleStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      content: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Image.asset(
              'assets/images/sad.png',
              height: 140,
            ),
          ],
        ),
      ),
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: confirm,
      onCancel: cancel,
      confirmTextColor: Colors.white);
}

Widget NumberInputBox(
    double height, String label, TextEditingController controller,
    {String unit = 'g'}) {
  return Container(
    margin: EdgeInsets.all(20),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (s) {
        return s.trim().isEmpty ? 'Required' : null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    ),
  );
}

AppBar appBar() {
  return AppBar(
    backgroundColor: Colors.white,
    leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back_ios)),
    iconTheme: IconThemeData(color: textColor),
    elevation: 1,
  );
}

Widget AltText(double height, String text) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 25, top: 10),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w400),
    ),
  );
}

Widget ButtonText(LoadingController controller, String text1, String text2) {
  return controller.loading
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text1),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        )
      : Text(text2);
}

Widget FoodCard(double height, Food food) {
  return Container(
    padding: EdgeInsets.all(18),
    decoration: BoxDecoration(
        border: Border.all(
      color: Colors.grey.shade300,
    )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${food.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: height * 0.024,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text('Protein : ${food.protein} g')),
                Flexible(flex: 1, child: Text('Carbs : ${food.carbs} g')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text('Fats : ${food.fats} g')),
                Flexible(
                    flex: 1, child: Text('Calories : ${food.calories} Kcal')),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Widget ConsumedFoodCard(double height, ConsumedFoodModel food) {
  return Container(
    padding: EdgeInsets.all(18),
    decoration: BoxDecoration(
        border: Border.all(
      color: Colors.grey.shade300,
    )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${food.name} (${food.weight} g)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: height * 0.024,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text('Protein : ${food.protein} g')),
                Flexible(flex: 1, child: Text('Carbs : ${food.carbs} g')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Text('Fats : ${food.fats} g')),
                Flexible(
                    flex: 1, child: Text('Calories : ${food.calories} Kcal')),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

String weekDay(int day) {
  switch (day) {
    case 7:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
  }
}

void snackBar(String title, String message) {
  Get.rawSnackbar(
    backgroundColor: btnColor,
    title: title,
    message: message,
  );
}
