import 'package:hive_flutter/adapters.dart';

class CalcDatabase {
  List records = [];
  final calcBox = Hive.box('calcBox');

  void createInitData() {
    records = [];
    writeRecord();
  }

  void readRecords() {
    records = calcBox.get("CALC_RECORD");
  }

  void writeRecord() {
    calcBox.put("CALC_RECORD", records);
  }
}
