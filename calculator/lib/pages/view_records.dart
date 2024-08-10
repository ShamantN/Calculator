import 'package:calculator/calc_database.dart';
import 'package:calculator/pages/calc_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ViewRecords extends StatefulWidget {
  const ViewRecords({super.key});

  @override
  State<ViewRecords> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecords> {
  CalcDatabase db = CalcDatabase();
  final recordsBox = Hive.box('calcBox');
  @override
  void initState() {
    db.readRecords();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "History",
            style: TextStyle(color: Colors.white70, fontFamily: 'Helvetica'),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CalcPage()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white70,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    db.records.clear();
                    recordsBox.clear();
                    db.writeRecord();
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white70,
                ))
          ],
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: db.records.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: db.records.length,
                    itemBuilder: (context, index) {
                      if (db.records[index].length == 3) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade900),
                            child: ListTile(
                                trailing: Text(db.records[index][2]),
                                titleTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                subtitleTextStyle:
                                    const TextStyle(color: Colors.white),
                                title: Text(db.records[index][0]),
                                subtitle: Text(
                                  db.records[index][1],
                                )),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }))
            : const Center(
                child: Text(
                  "No Records Available!",
                  style: TextStyle(color: Colors.white70),
                ),
              ));
  }
}
