import 'package:calculator/database/calc_database.dart';
import 'package:calculator/pages/numbers_button.dart';
import 'package:calculator/pages/view_records.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:math_expressions/math_expressions.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  String evalExpression = "";
  String displayExpression = "";
  String dummyExpression = "";
  String result = '';
  bool onEqual = false;
  CalcDatabase cdb = CalcDatabase();
  final _caclBox = Hive.box('calcBox');

  @override
  void initState() {
    if (_caclBox.get("CALC_RECORD") == null) {
      cdb.createInitData();
    } else {
      cdb.readRecords();
    }
    super.initState();
  }

  void evaluateExpression(String expression) {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    setState(() {
      if (eval == eval.toInt()) {
        result = eval.toInt().toString();
        dummyExpression = displayExpression;
        evalExpression = result;
        displayExpression = result;
      } else {
        result = eval.toString();
        dummyExpression = displayExpression;
        evalExpression = result;
        displayExpression = result;
      }
    });
    writeData(dummyExpression, result);
  }

  void writeData(String exp, String res) {
    DateTime now = DateTime.now();
    cdb.records.add([
      exp,
      res,
      DateTime(now.year, now.month, now.day, now.hour, now.minute)
          .toString()
          .substring(0, 16)
    ]);
    cdb.writeRecord();
  }

  void addToExpression(String operation) {
    setState(() {
      String replace = "";
      switch (operation) {
        case "*":
          replace = "×";
          break;

        case "/":
          replace = "÷";
          break;

        case "*0.01*":
          replace = "%";

        default:
          replace = operation;
      }
      onEqual = false;
      displayExpression = displayExpression + replace;
      evalExpression = evalExpression + operation;
    });
  }

  void clearAll() {
    setState(() {
      result = '';
      evalExpression = '';
      displayExpression = '';
      onEqual = false;
    });
  }

  double evalFontSize(String expression) {
    if (expression.length >= 19) {
      return 30;
    } else if (expression.length >= 16) {
      return 35;
    } else if (expression.length >= 11) {
      return 40;
    }
    return 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
              clipBehavior: Clip.hardEdge,
              color: Colors.grey.shade700,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white70,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewRecords()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Text(
                          "History",
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Helvetica'),
                        ),
                      ))
                ];
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onEqual)
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  onEqual ? result : displayExpression,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: evalFontSize(result)),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    onEqual ? result : displayExpression,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: evalFontSize(evalExpression)),
                  ),
                ),
              ),
            ),

          // FIRST ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumbersButton(
                  onTap: () {
                    clearAll();
                  },
                  number: "AC",
                  backgroundColor: Colors.grey.shade700),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("*0.01*");
                  },
                  number: "%",
                  backgroundColor: Colors.grey.shade700),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (evalExpression.isEmpty) {
                      HapticFeedback.heavyImpact();
                    } else {
                      HapticFeedback.heavyImpact();
                      evalExpression = evalExpression.substring(
                          0, evalExpression.length - 1);
                    }
                  });
                },
                child: InkWell(
                  //radius: 30,
                  borderRadius: BorderRadius.circular(42),
                  highlightColor: Colors.purple,
                  splashColor: Colors.red,
                  onTap: () {
                    if (evalExpression.isEmpty && displayExpression.isEmpty) {
                      HapticFeedback.heavyImpact();
                    } else {
                      HapticFeedback.heavyImpact();
                      evalExpression = evalExpression.substring(
                          0, evalExpression.length - 1);
                      setState(() {
                        displayExpression = displayExpression.substring(
                            0, displayExpression.length - 1);
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade700,
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("/");
                  },
                  number: "÷",
                  backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 10),

          // SECOND ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumbersButton(
                  onTap: () {
                    addToExpression("7");
                  },
                  number: "7",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("8");
                  },
                  number: "8",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("9");
                  },
                  number: "9",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("*");
                  },
                  number: "×",
                  backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 10),

          // THIRD ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumbersButton(
                  onTap: () {
                    addToExpression("4");
                  },
                  number: "4",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("5");
                  },
                  number: "5",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("6");
                  },
                  number: "6",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("-");
                  },
                  number: "−",
                  backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 10),

          // FOURTH ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumbersButton(
                onTap: () {
                  addToExpression("1");
                },
                number: "1",
                backgroundColor: const Color.fromARGB(255, 29, 29, 29),
              ),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("2");
                  },
                  number: "2",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("3");
                  },
                  number: "3",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("+");
                  },
                  number: "+",
                  backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 10),

          // FIFTH ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumbersButton(
                  onTap: () {
                    addToExpression("00");
                  },
                  number: "00",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression("0");
                  },
                  number: "0",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    addToExpression(".");
                  },
                  number: ".",
                  backgroundColor: const Color.fromARGB(255, 29, 29, 29)),
              const SizedBox(width: 10),
              NumbersButton(
                  onTap: () {
                    evaluateExpression(evalExpression);
                    onEqual = true;
                  },
                  number: "=",
                  backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
