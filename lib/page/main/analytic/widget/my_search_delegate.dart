import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/analytic/widget/build_item_results.dart';
import 'package:expenditure_management/page/main/analytic/widget/filter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MySearchDelegate extends SearchDelegate {
  List<int> chooseIndex = [0, 0, 0, 0];
  int money = 0;
  DateTime? dateTime;
  String note = "";

  bool checkResult(Spending spending) {
    if (chooseIndex[0] == 1 && spending.money < money) {
      return false;
    } else if (chooseIndex[0] == 2 && spending.money > money) {
      return false;
    } else if (chooseIndex[0] == 4 && spending.money == money) {
      return false;
    }

    if (chooseIndex[1] == 1 && dateTime!.isAfter(spending.dateTime)) {
      return false;
    } else if (chooseIndex[1] == 2 && dateTime!.isBefore(spending.dateTime)) {
      return false;
    } else if (chooseIndex[1] == 4 && isSameDay(spending.dateTime, dateTime)) {
      return false;
    }

    if (spending.note != null && !spending.note!.contains(note)) return false;
    return true;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterPage(
                  action: (list, money, dateTime, note) {
                    this.dateTime = dateTime;
                    this.money = money;
                    this.note = note;
                    chooseIndex = list;
                  },
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.tune_rounded,
            color: Colors.black,
          ),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, "result");
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      );

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("data")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.requireData.data() as Map<String, dynamic>;
            List<String> list = [];
            for (var element in data.entries) {
              list.addAll((element.value as List<dynamic>)
                  .map((e) => e.toString())
                  .toList());
            }
            return FutureBuilder(
                future: SpendingFirebase.getSpendingList(list),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var spendingList = snapshot.data;
                    return buildItemResults(
                        spendingList!.where(checkResult).toList());
                  }
                  return const Center(child: CircularProgressIndicator());
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("history")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.requireData.data() as Map<String, dynamic>;
          List<String> history = (data["history"] as List<dynamic>)
              .map((e) => e.toString())
              .where((element) =>
                  element.toUpperCase().contains(query.toUpperCase()))
              .toList();
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  query = history[index];
                },
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      history[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          query = history[index];
                        },
                        icon: const Icon(Icons.upload)),
                    const SizedBox(width: 20),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: SingleChildScrollView());
      },
    );
  }

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: Colors.black54, fontSize: 18);
}
