import 'dart:io';
import 'package:nutrition_app/models/consumed_food.dart';
import 'package:nutrition_app/models/food_model.dart';
import 'package:nutrition_app/models/nutrion_plan_model.dart';
import 'package:nutrition_app/models/weight_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databasehelper;
  static Database _database;

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databasehelper == null)
      _databasehelper = DatabaseHelper._createInstance();
    return _databasehelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'nutrition.db';
    var userDatabase = openDatabase(path, version: 1, onCreate: _onCreate);
    return userDatabase;
  }

  getDatabasePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'nutrition.db';
    return path;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''create table NutritionPlan(
        id INTEGER PRIMARY KEY, 
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        calories REAL NOT NULL)''');

    await db.execute('''create table Food(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        calories REAL NOT NULL)''');

    await db.execute('''create table Weight(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        day TEXT NOT NULL,
        date INTEGER NOT NULL,
        weight REAL NOT NULL)''');

    await db.execute('''create table ConsumedFood(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        calories REAL NOT NULL,
        Weight REAL NOT NULL)''');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<dynamic> insertFood(Food food) async {
    Database db = await this.database;
    try {
      await db.insert('Food', food.toJson());
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> retrieveFoods() async {
    Database db = await this.database;
    try {
      var result = await db.rawQuery('SELECT * FROM Food');
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteFoodById(int id) async {
    Database db = await this.database;
    try {
      await db.delete('Food', where: 'id = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      e.toString();
    }
  }

  Future<dynamic> retrieveFoodById(int id) async {
    Database db = await this.database;
    try {
      var result = await db.rawQuery('SELECT * FROM Food WHERE id = ?', [id]);
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> insertNutritionPlan(List<NutritionPlan> plan) async {
    Database db = await this.database;
    try {
      await db.rawDelete('DELETE FROM NutritionPlan');
      await db.insert('NutritionPlan', plan[0].toJson());
      await db.insert('NutritionPlan', plan[1].toJson());
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> insertRequiredNutrition(NutritionPlan plan) async {
    Database db = await this.database;
    try {
      await db.update('NutritionPlan', plan.toJson(),
          where: 'id = ?', whereArgs: [1]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateProtein(int protein, String table, int id) async {
    Database db = await this.database;
    try {
      await db.rawUpdate(
          'UPDATE $table SET protein = ? where id = ?', [protein, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateCarbs(int carbs, String table, int id) async {
    Database db = await this.database;
    try {
      await db
          .rawUpdate('UPDATE $table SET carbs = ? where id = ?', [carbs, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateFats(int fats, String table, int id) async {
    Database db = await this.database;
    try {
      await db.rawUpdate('UPDATE $table SET fats = ? where id = ?', [fats, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateCalories(int calories, String table, int id) async {
    Database db = await this.database;
    try {
      await db.rawUpdate(
          'UPDATE $table SET calories = ? where id = ?', [calories, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateFoodName(String name, String table, int id) async {
    Database db = await this.database;
    try {
      await db.rawUpdate('UPDATE $table SET name = ? where id = ?', [name, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> retrieveNutritionPlan() async {
    Database db = await this.database;
    try {
      var result = await db.rawQuery('SELECT * FROM NutritionPlan');
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> resetDailyNutrition(int id) async {
    Database db = await this.database;
    NutritionPlan plan =
        NutritionPlan(id: 2, protein: 0, calories: 0, carbs: 0, fats: 0);
    try {
      await db.update('NutritionPlan', plan.toJson(),
          where: 'id = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateFoodData(int id, Food food) async {
    Database db = await this.database;
    try {
      await db.update('Food', food.toJson(), where: 'id=?', whereArgs: [id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> retrieveWeightData() async {
    Database db = await this.database;
    try {
      var result = await db.rawQuery('SELECT * FROM Weight ORDER BY date DESC');
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> addWeightData(WeightModel weight) async {
    Database db = await this.database;
    try {
      await db.insert('Weight', weight.toJson());
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getAvailableNutrtionData() async {
    Database db = await this.database;
    try {
      var result =
          await db.rawQuery('SELECT * FROM NutritionPlan WHERE id = ?', [2]);
      return result[0];
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> addTodaysCount(NutritionPlan plan) async {
    Database db = await this.database;
    try {
      await db.update('NutritionPlan', plan.toJson(),
          where: 'id=?', whereArgs: [2]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> deleteWeightById(int id) async {
    Database db = await this.database;
    try {
      await db.delete('Weight', where: 'id = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> updateWeightById(int id, double weight) async {
    Database db = await this.database;
    try {
      await db
          .rawUpdate('UPDATE Weight SET weight = ? WHERE id = ?', [weight, id]);
      return 1;
    } catch (e) {
      return e.toString();
    }
  }

  Future insertConsumedFood(ConsumedFoodModel food) async {
    Database db = await this.database;
    try {
      await db.insert('ConsumedFood', food.toJson());
    } catch (e) {
      return e.toString();
    }
  }

  Future retrieveAllConsumedFood() async {
    Database db = await this.database;
    try {
      var result = await db.rawQuery('SELECT * FROM ConsumedFood');
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Future resetConsumedFood() async {
    Database db = await this.database;
    try {
      await db.rawQuery('DELETE FROM ConsumedFood');
      return 1;
    } catch (e) {
      return e.toString();
    }
  }
}
