import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomEmptyList extends StatelessWidget {
  final String product;

  CustomEmptyList({required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorUtils.getColor(CustomType.neutral), // Colore della linea
          ),
          borderRadius: BorderRadius.circular(10.0), // Angoli smussati
        ),
        child: Text(
          'Lista ${product} vuota.',
          style: TextStyle(
            fontSize: 20.0,
            color: ColorUtils.labelColor
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomEmptyList(product: "personalizzato"),
        ),
      ),
    ),
  );
}
