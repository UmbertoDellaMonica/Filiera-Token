import 'dart:js';

import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/components/form_add_milkbatch.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/inventory_user_profile_.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:flutter/material.dart';

class CustomAddMilkBatchButton extends StatelessWidget {
  final String wallet;
  final String idUser;
  final String userType;
    final Function()? onProductAdded;


  const CustomAddMilkBatchButton({required this.wallet,  super.key, required this.idUser, required this.userType, this.onProductAdded});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildAddMilkBatchButton(context),
    );
  }

  FloatingActionButton _buildAddMilkBatchButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: MilkBatchForm(wallet: wallet,idUser: idUser,userType: userType,
                onProductAdded: () {
                  // Esegui altre azioni necessarie dopo l'aggiunta del prodotto
                  _completeAddProduct(context);
                },
                )

            );
          },
        );
      },
    );
  }

   // Al termine dell'aggiunta del prodotto, chiamiamo il callback
  void _onProductAddedSuccessfully(BuildContext context) {
    // Notifica il genitore che il prodotto è stato aggiunto con successo
      Future.delayed(Duration(seconds: 5), () {

      onProductAdded!();

      // Chiudi il modal bottom sheet
    Navigator.of(context).pop();
  });
  }

  // Al termine dell'aggiunta del prodotto, chiamiamo questa funzione
  void _completeAddProduct(BuildContext context) {
    // Logica per aggiungere il prodotto al database o altro
    // Dopo l'aggiunta con successo del prodotto, chiamiamo il callback
    _onProductAddedSuccessfully(context);
  }


}
