import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/controllers/statsController.dart';
import 'package:nutrition_app/controllers/switch_controller.dart';
import 'package:nutrition_app/utils/utilities.dart';
import 'package:nutrition_app/views/home.dart';
import 'package:nutrition_app/views/create_plan.dart';
import 'package:nutrition_app/views/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Parent(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Poppins",
          primaryColor: btnColor,
          primarySwatch: Colors.deepPurple,
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2))
              .then((value) => checkPreferences()),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Splash();
            } else {
              return snapshot.data == false ? CreatePlan() : Home();
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var result = pref.getBool('alreadyLogin');
    return result == null ? false : true;
  }
}

class Parent extends StatefulWidget {
  final child;
  var switchController = Get.put(SwitchController());
  var statsController = Get.put(StatsController());
  var loadingController = Get.put(LoadingController());
  Parent({Key key, this.child}) : super(key: key);

  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
