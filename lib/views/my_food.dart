import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/models/food_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/add_food.dart';
import 'package:nutrition_app/views/food_details.dart';

class MyFood extends StatelessWidget {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      screenTitle('Available food list', height(context)),
                      FoodList(height(context)),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      screenTitle('Available food list', height(context)),
                      FoodList(height(context)),
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

  Widget FoodList(double height) {
    return FutureBuilder(
        future: getAllFoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (snapshot.data.length == 0) {
            return Container(
              height: height - 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No data available'),
                    TextButton(
                        onPressed: () {
                          Get.off(() => AddFood(),
                              transition: Transition.topLevel,
                              duration: Duration(milliseconds: 300));
                        },
                        child: Text(
                          'Add food',
                          style: TextStyle(color: btnColor),
                        ))
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Food food = Food.fromJson(snapshot.data[index]);
              return Column(
                children: [
                  InkWell(
                      onTap: () {
                        Get.to(() => FoodDetails(food.id),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      },
                      child: FoodCard(height, food)),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          );
        });
  }

  Future<dynamic> getAllFoods() async {
    var result = await DatabaseHelper().retrieveFoods();
    return result;
  }
}
