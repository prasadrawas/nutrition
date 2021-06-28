import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/controllers/loading_controller.dart';
import 'package:nutrition_app/models/weight_model.dart';
import 'package:nutrition_app/utils/databaseHelper.dart';
import 'package:nutrition_app/utils/utilities.dart';

class Weight extends StatefulWidget {
  @override
  _WeightState createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final _key = GlobalKey<FormState>();
  var weightController = TextEditingController();
  int dateDifference = 0;
  DateTime currentDate;
  double totalDifference = 0;
  bool isTotalGain = false;
  final DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getWeightData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: height(context) - 100,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            calculateTotalWeightDifference(snapshot.data);
            double diff = 0;
            bool isGain = false;
            bool single = true;
            if (snapshot.data.length >= 2) {
              double w1 = snapshot.data[0]['weight'];
              double w2 = snapshot.data[1]['weight'];
              currentDate =
                  DateTime.fromMillisecondsSinceEpoch(snapshot.data[0]['date']);
              DateTime d2 =
                  DateTime.fromMillisecondsSinceEpoch(snapshot.data[1]['date']);
              dateDifference = currentDate.difference(d2).inDays;
              diff = (w1 - w2).toPrecision(3).abs();
              if (w1 > w2) {
                isGain = true;
              }
              single = false;
            }
            return LayoutBuilder(
              builder: (_, __) {
                if (orientation(context) == Orientation.portrait) {
                  return Column(
                    children: [
                      screenTitle('Weight details', height(context)),
                      StatPage(height(context), diff, isGain, single),
                      AddNewButton(height(context)),
                      WeightData(height(context), snapshot.data),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      screenTitle('Weight details', width(context)),
                      StatPage(width(context), diff, isGain, single),
                      AddNewButton(width(context)),
                      WeightData(width(context), snapshot.data),
                    ],
                  );
                }
              },
            );
          }),
    );
  }

  void calculateTotalWeightDifference(List<dynamic> list) {
    if (list.length > 1) {
      if ((list[0]['weight'] - list[list.length - 1]['weight']) < 0) {
        isTotalGain = false;
      } else {
        isTotalGain = true;
      }
      totalDifference =
          (list[0]['weight'] - list[list.length - 1]['weight']).abs();
      totalDifference = totalDifference.toPrecision(3);
    }
  }

  Widget AddNewButton(double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Weight table'),
        TextButton(
            onPressed: () {
              WeightInputDilogBox(height);
            },
            child: Text(
              'Add new',
              style: TextStyle(color: btnColor),
            )),
      ],
    );
  }

  void WeightInputDilogBox(double height) {
    Get.defaultDialog(
      title: 'Add Weight Data',
      content: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              NumberInputBox(height, 'Weight', weightController, unit: 'kg'),
              AddNewWeightButton(height),
            ],
          ),
        ),
      ),
    );
  }

  Widget AddNewWeightButton(double height) {
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
                      if (_key.currentState.validate()) {
                        await addWeightToDatabase(controller);
                      }
                    },
              child: ButtonText(controller, 'Adding', 'Add Weight')));
    });
  }

  Widget EditWeightButton(double height, int id) {
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
                      if (_key.currentState.validate()) {
                        double w = double.parse(weightController.text.trim())
                            .toPrecision(3);
                        var result = await helper.updateWeightById(id, w);
                        if (result == 1) {
                          if (mounted) {
                            setState(() {
                              Get.back();
                            });
                          }
                          snackBar('Success', 'Weight updated successfully.');
                        } else {
                          snackBar('Failed to update', result);
                        }
                      }
                    },
              child: ButtonText(controller, 'Editing', 'Edit Weight')));
    });
  }

  Future addWeightToDatabase(LoadingController controller) async {
    controller.setLoadingTrue();
    DateTime dateTime = DateTime.now();
    WeightModel weigh = WeightModel(
        id: null,
        weight: double.parse(weightController.text.trim()).toPrecision(3),
        day: weekDay(dateTime.weekday),
        date: dateTime.millisecondsSinceEpoch);

    var result = await helper.addWeightData(weigh);
    if (mounted) {
      setState(() {
        controller.setLoadingFalse();
        Get.back();
      });
    }
    if (result != 1) {
      snackBar('Failed to add', result);
    } else {
      snackBar('Success', 'Weight added to list.');
    }
  }

  Widget StatPage(double height, double diff, bool isGain, bool single) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (single ? '0 ' : (isGain ? '+' : '-') + '$diff '),
              style: TextStyle(
                  color: textColor,
                  fontSize: height * 0.080,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'kg',
              style: TextStyle(
                  color: textColor,
                  fontSize: height * 0.020,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        single
            ? SingleWeightText(height)
            : (isGain
                ? GainWeightText(height, diff)
                : LooseWeightText(height, diff)),
        single ? Center() : Text('Difference : $dateDifference days'),
        single
            ? Center()
            : Text(isTotalGain
                ? 'Total gain : $totalDifference kg'
                : 'Total loss : $totalDifference kg'),
        Container(
          margin: EdgeInsets.only(left: 50, right: 50, top: 40, bottom: 10),
          child: Divider(
            color: textColor,
            thickness: 0.3,
          ),
        ),
      ],
    );
  }

  Widget SingleWeightText(double height) {
    return Text(
      'Add your weight to see statistics of your weight data',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColor,
          fontSize: height * 0.017,
          fontWeight: FontWeight.w500),
    );
  }

  Widget GainWeightText(double height, double diff) {
    return Text(
      '$diff kg weight has gained compared to last record',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: btnColor,
          fontSize: height * 0.017,
          fontWeight: FontWeight.w500),
    );
  }

  Widget LooseWeightText(double height, double diff) {
    return Text(
      '$diff kg weight has loosed compared to last record',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.red,
          fontSize: height * 0.017,
          fontWeight: FontWeight.w500),
    );
  }

  Widget WeightData(double height, List<dynamic> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        WeightModel weight = WeightModel.fromJson(data[index]);
        return InkWell(
          onTap: data.length <= 1
              ? null
              : () {
                  weightController.clear();
                  Get.bottomSheet(Container(
                    alignment: Alignment.center,
                    height: height * 0.20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            'Edit weight',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: height * 0.030,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  Get.back();
                                  var result = await helper
                                      .deleteWeightById(data[index]['id']);
                                  if (result == 1) {
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    snackBar('Deleted',
                                        'Weight deleted successfully.');
                                  } else {
                                    snackBar('Failed to delete', result);
                                  }
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.defaultDialog(
                                    title: 'Edit Weight',
                                    content: Container(
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Form(
                                        key: _key,
                                        child: Column(
                                          children: [
                                            NumberInputBox(height, 'Weight',
                                                weightController,
                                                unit: 'kg'),
                                            EditWeightButton(
                                              height,
                                              data[index]['id'],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: btnColor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ));
                },
          child: WeightCard(height, weight),
        );
      },
    );
  }

  WeightCard(double height, WeightModel weight) {
    String date = DateFormat('dd MMMM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(weight.date));
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weight.day,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.030,
                      ),
                    ),
                    Text(
                      '$date',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: height * 0.016,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${weight.weight} ',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.030,
                      ),
                    ),
                    Text(
                      'kg',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: height * 0.016,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<dynamic> getWeightData() async {
    var result = await helper.retrieveWeightData();
    return result;
  }
}
