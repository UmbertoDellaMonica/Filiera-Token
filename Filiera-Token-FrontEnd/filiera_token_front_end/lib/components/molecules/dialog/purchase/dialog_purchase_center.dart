import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/atoms/custom_input_validator.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/transaction_service.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogPurchaseCenter extends StatefulWidget {
  final Product product;
  final String userType;
  final String buyer;

  DialogPurchaseCenter({
    required this.product, 
    required this.userType,
    required this.buyer
  });

  @override
  _DialogPurchaseCenterState createState() => _DialogPurchaseCenterState();
}

class _DialogPurchaseCenterState extends State<DialogPurchaseCenter> {



  TransactionService transactionService = TransactionService();
  



  TextEditingController ?_quantityToBuy;

  @override
  void dispose() {
    _quantityToBuy?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _quantityToBuy = TextEditingController();
    super.initState();
  }

  bool _checkBuyQuantity() {
    return _quantityToBuy!.text.isNotEmpty;
  }
  
  Widget _buildBuyButton() {
    return CustomButton(
        text: "Buy", 
        type: CustomType.neutralShade, 
        onPressed: () async {

        if(_checkBuyQuantity()) {

          Product productToBuy = widget.product;
          // BuyLogic 
          switch (widget.userType) {
            case "Consumer": {
                // Converto e calcolo il prezzo totale 
              String quantityToBuy = _quantityToBuy!.text;
              print("Sono nel metodo di acquisto!");
              int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
              print("Prezzo totale: " + totalPrice.toString());
              String priceToPay = totalPrice.toString();

              print("Product Seller : " + productToBuy.seller);
              print("Product buyer:" + widget!.buyer);

              // Verifica se la quantità desiderata è disponibile
              if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
                try {
                  bool success = await transactionService.buyCheesePieceProduct(
                    productToBuy.id,
                    quantityToBuy,
                    widget.buyer,
                    productToBuy.seller,
                    priceToPay,
                  );

                  if (success) {
                    // Mostra la transazione di successo
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.success, productName: "Pezzo di Formaggio");
                  } else {
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Pezzo di Formaggio");
                  }
                } catch (error) {
                  // Gestione degli errori, se necessario
                  print("Errore durante l'acquisto: $error");
                  CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Pezzo di Formaggio");
                }
              } else {
                // Mostra un messaggio che la quantità desiderata non è disponibile
                CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Pezzo di Formaggio", errorDetail: "Quantità desiderata non disponibile.");
              }

              break;

            }
            case "CheeseProducer": {
              // Converto e calcolo il prezzo totale 
              String quantityToBuy = _quantityToBuy!.text;
              print("Sono nel metodo di acquisto!");
              int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
              print("Prezzo totale: " + totalPrice.toString());
              String priceToPay = totalPrice.toString();

              print("Product Seller : " + productToBuy.seller);
              print("Product buyer:" + widget!.buyer);

              // Verifica se la quantità desiderata è disponibile
              if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
                try {
                  bool success = await transactionService.buyMilkBatchProduct(
                    productToBuy.id,
                    quantityToBuy,
                    widget.buyer,
                    productToBuy.seller,
                    priceToPay,
                  );

                  if (success) {
                    // Mostra la transazione di successo
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.success, productName: "Partita di Latte");
                  } else {
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Partita di Latte");
                  }
                } catch (error) {
                  // Gestione degli errori, se necessario
                  print("Errore durante l'acquisto: $error");
                  CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Partita di Latte");
                }
              } else {
                // Mostra un messaggio che la quantità desiderata non è disponibile
                CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Partita di Latte", errorDetail: "Quantità desiderata non disponibile.");
              }

              break;
            }
            case "Retailer": {
              String quantityToBuy = _quantityToBuy!.text;
              print("Sono nel metodo di acquisto del Retailer!");
              int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
              print("Prezzo totale: " + totalPrice.toString());
              String priceToPay = totalPrice.toString();

              print("Product Seller : " + productToBuy.seller);
              print("Product buyer:" + widget!.buyer);

              // Verifica se la quantità desiderata è disponibile
              if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
                try {
                  bool success = await transactionService.buyCheeseBlockProduct(
                    productToBuy.id,
                    quantityToBuy,
                    widget.buyer,
                    productToBuy.seller,
                    priceToPay,
                  );

                  if (success) {
                    // Mostra la transazione di successo
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.success, productName: "Blocco di Formaggio");
                  } else {
                    CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Blocco di Formaggio");
                  }
                } catch (error) {
                  // Gestione degli errori, se necessario
                  print("Errore durante l'acquisto: $error");
                  CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Blocco di Formaggio");
                }
              } else {
                // Mostra un messaggio che la quantità desiderata non è disponibile
                CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "Blocco di Formaggio", errorDetail: "Quantità desiderata non disponibile.");
              }
              
            }
          }
        } else {
            CustomPopUpDialog.show(context, AlertDialogType.Buy, CustomType.error, productName: "selezionato", errorDetail: "Inserisci la quantità desiderata.");
        }
      }
    );
  }

  Widget _buidlTextForm() {
    String kg = (widget.userType == "Consumer" || widget.userType == "Retailer") ? " (Kg)" : " (L)";

    return CustomInputValidator(
      inputType: TextInputType.number,
      labelText: 'Quantità richiesta$kg',
      controller: _quantityToBuy!,
      labelColor: Colors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buidlTextForm(),
            SizedBox(height: 30),
            _buildBuyButton()
          ],
        ),
      );
  }
}
