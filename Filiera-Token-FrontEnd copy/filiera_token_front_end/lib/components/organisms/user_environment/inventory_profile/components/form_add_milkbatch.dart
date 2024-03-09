import 'package:filiera_token_front_end/Actor/MilkHub/service/MilkHubInventoryService.dart';
import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/atoms/custom_input_validator.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MilkBatchForm extends StatefulWidget {
  final String wallet;
  final String userType;
  final String idUser;
  final Function()? onProductAdded;

  MilkBatchForm({required this.wallet, required this.userType, required this.idUser, this.onProductAdded, });

  @override
  _MilkBatchFormState createState() => _MilkBatchFormState();
}

class _MilkBatchFormState extends State<MilkBatchForm> {

  MilkHubInventoryService milkHubInventoryService = MilkHubInventoryService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _loading = false;

  Future<void> _addMilkBatch() async {
    setState(() {
      _loading = true;
    });

    try {

      bool success = await milkHubInventoryService.addMilkBatch(widget.wallet, _priceController.text, _quantityController.text, _expirationDateController.text);

      if (success) {
          CustomPopUpDialog.show(context, AlertDialogType.Add, CustomType.success);
          widget.onProductAdded!();
      } else {
          CustomPopUpDialog.show(context, AlertDialogType.Add, CustomType.error);
        _addCompleteProductAdded();
        
      }
    } catch (error) {
      print("Errore durante l'aggiunta della Partita di Latte: $error");
      CustomPopUpDialog.show(context, AlertDialogType.Add, CustomType.error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _addCompleteProductAdded(){
    widget.onProductAdded!();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputValidator(inputType: TextInputType.number, labelText: "Quantità (L)", controller: _quantityController),
          SizedBox(height: 8.0), // Aggiunto uno spazio tra i campi
          CustomInputValidator(inputType: TextInputType.datetime, labelText: "Data di Scadenza", controller: _expirationDateController),
          SizedBox(height: 8.0), // Aggiunto uno spazio tra i campi
          CustomInputValidator(inputType: TextInputType.number, labelText: "Prezzo (FTL)", controller: _priceController),
          SizedBox(height: 16.0), // Aumentato lo spazio tra i campi e il pulsante
          ElevatedButton(
            onPressed: _loading ? null : () async {
              if (_formKey.currentState?.validate() ?? false) {
                await _addMilkBatch();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorUtils.getColor(CustomType.success), // Imposta il colore di sfondo su verde
            ),
            child: _loading
                ? CircularProgressIndicator()
                : Text(
                    'Invia',
                    style: TextStyle(color: Colors.white), // Imposta il colore del testo su bianco
                  ),
          ),


        ],
      ),
    );
}

}
