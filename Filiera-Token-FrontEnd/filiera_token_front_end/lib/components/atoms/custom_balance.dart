import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomBalance extends StatelessWidget {
  final User user;

  CustomBalance({required this.user});

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: ColorUtils.getColor(CustomType.neutral), // Colore neutral
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        'Saldo: '+user.balance+"FLT",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}