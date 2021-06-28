import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/switch_controller.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/add_food.dart';
import 'package:nutrition_app/views/my_food.dart';
import 'package:nutrition_app/views/my_profile.dart';
import 'package:nutrition_app/views/nutrition.dart';
import 'package:nutrition_app/views/weight.dart';

class Home extends StatelessWidget {
  List<dynamic> screens = [Nutrition(), Weight()];
  int currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sadDialogBox(exitFromApp, closeDialog, 'Do you really want to exit ? ');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(orientation(context) == Orientation.portrait
            ? height(context)
            : width(context)),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: GetBuilder<SwitchController>(builder: (controller) {
              return LayoutBuilder(
                builder: (_, __) {
                  if (orientation(context) == Orientation.portrait) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Header(height(context)),
                        screens[controller.index],
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Header(width(context)),
                        screens[controller.index],
                      ],
                    );
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget CustomDrawer(double height) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: height * 0.4,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/drawer.png',
                    height: height * 0.25,
                  ),
                  screenTitle('Nutrition App', height),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(() => MyProfile(),
                  transition: Transition.topLevel,
                  duration: Duration(milliseconds: 300));
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.solidUserCircle,
                color: textColor,
              ),
              title: Text(
                'My profile',
                style: TextStyle(
                    fontSize: height * 0.022, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(() => MyFood(),
                  transition: Transition.topLevel,
                  duration: Duration(milliseconds: 300));
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.nutritionix,
                color: textColor,
              ),
              title: Text(
                'My Food',
                style: TextStyle(
                    fontSize: height * 0.020, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(() => AddFood(),
                  transition: Transition.topLevel,
                  duration: Duration(milliseconds: 300));
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.solidPlusSquare,
                color: textColor,
              ),
              title: Text(
                'Add new food',
                style: TextStyle(
                    fontSize: height * 0.022, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              sadDialogBox(
                  exitFromApp, closeDialog, 'Do you really want to exit ? ');
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                color: textColor,
              ),
              title: Text(
                'Exit',
                style: TextStyle(
                    fontSize: height * 0.022, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void exitFromApp() {
    exit(0);
  }

  void closeDialog() {
    Get.back();
  }

  Widget Header(double height) {
    return GetBuilder<SwitchController>(builder: (controller) {
      return Container(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.bars),
              onPressed: () async {
                _scaffoldKey.currentState.openDrawer();
              },
              color: textColor,
            ),
            Container(
              width: height * 0.3,
              height: height * 0.055,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                      width: height * 0.3,
                      height: height * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: controller.index == 0 ? btnColor : null,
                      ),
                      child: InkWell(
                        onTap: () {
                          controller.setPageIndex(0);
                        },
                        child: Center(
                          child: Text(
                            'Nutrition',
                            style: TextStyle(
                              color: controller.index == 0
                                  ? Colors.white
                                  : textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: height * 0.3,
                      height: height * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: controller.index == 1 ? btnColor : null,
                      ),
                      child: InkWell(
                        onTap: () {
                          controller.setPageIndex(1);
                        },
                        child: Center(
                            child: Text(
                          'Weight',
                          style: TextStyle(
                            color: controller.index == 1
                                ? Colors.white
                                : textColor,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.solidUserCircle,
                  size: 30, color: textColor),
              onPressed: () {
                Get.to(() => MyProfile(),
                    transition: Transition.topLevel,
                    duration: Duration(milliseconds: 400));
              },
            ),
          ],
        ),
      );
    });
  }
}
