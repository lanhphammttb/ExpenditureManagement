import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget boxText({required String text, required int number}) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Text(
          numberFormat.format(number),
          style: const TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}
