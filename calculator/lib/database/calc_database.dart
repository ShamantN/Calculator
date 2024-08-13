import 'package:hive_flutter/adapters.dart';

class CalcDatabase {
  List records = [];
  List reversedRecords = [];
  final calcBox = Hive.box('calcBox');

  void createInitData() {
    records = [];
    reversedRecords = [];
    writeRecord();
  }

  void readRecords() {
    records = calcBox.get("CALC_RECORD");
    reversedRecords = records.reversed.toList();
  }

  void writeRecord() {
    calcBox.put("CALC_RECORD", records);
  }
}
