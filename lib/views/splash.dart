import 'package:flutter/material.dart';
import 'package:nutrition_app/utils/utilities.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height(context),
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      height: height(context) * 0.25,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Nutrition App',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                    ),
                  ],
                ),
                Positioned(
                  child: Text(
                    'from prasad',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ),
                  left: 0,
                  right: 0,
                  bottom: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
