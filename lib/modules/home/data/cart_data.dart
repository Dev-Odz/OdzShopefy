import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartLocalStorage {
  Future<void> setData(List<dynamic> data) async {
    try {
      var cartBox = await Hive.openBox('cartBox');
      cartBox.put('data', jsonEncode(data));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>> getData() async {
    try {
      var cartBox = await Hive.openBox('cartBox');
      List<dynamic> data = jsonDecode(cartBox.get('data'));
      return data;
    } catch (e) {
      print(e);
      List<dynamic> data = [];
      return data;
    }
  }

  Future<void> clearData() async {
    try {
      var cartBox = await Hive.openBox('cartBox');
      await cartBox.deleteAll(cartBox.keys);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
