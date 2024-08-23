import 'package:calculator/database/calc_database.dart';
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
                    db.reversedRecords.clear();
                    recordsBox.clear();
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
        body: db.reversedRecords.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: db.reversedRecords.length,
                    itemBuilder: (context, index) {
                      if (db.reversedRecords[index].length == 3) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 21, 21, 21)),
                            child: ListTile(
                                trailing: Text(
                                  db.reversedRecords[index][2],
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 85, 85, 85)),
                                ),
                                titleTextStyle: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                subtitleTextStyle: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    color: Colors.white70),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(db.reversedRecords[index][0]),
                                ),
                                subtitle: Text(
                                  db.reversedRecords[index][1],
                                )),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }))
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color: Colors.white70,
                    ),
                    Text(
                      "There's no history yet.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ));
  }
}
