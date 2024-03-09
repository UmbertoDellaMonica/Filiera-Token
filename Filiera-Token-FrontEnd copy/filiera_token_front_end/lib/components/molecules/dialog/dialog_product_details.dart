import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/purchase/dialog_purchase_center.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/purchase/dialog_purchase_right.dart';


import 'package:filiera_token_front_end/components/molecules/dialog/conversion/dialog_conversion_center.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/conversion/dialog_conversion_right.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

class DialogProductDetails extends StatelessWidget {

  final Product product;
  final DialogType dialogType; // Nuovo parametro
  final String wallet; // Seller 
  final String buyer;
  final String userType;

  const DialogProductDetails({
    required this.product,
    required this.dialogType,
    required this.wallet, 
    required this.userType, 
    required this.buyer
  });

  static void show(BuildContext context,String wallet,Product product, DialogType dialogType, String userType, String walletBuyer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogProductDetails(product: product, dialogType: dialogType, wallet: wallet, userType: userType, buyer: walletBuyer);
      },
    );
  }


    Widget _buildLeftColumn(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.0,
            width: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(Enums.getAssetPath(product.getAsset())),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0), // Adjust spacing as needed
          CustomButton(
            text: "Back",
            type: CustomType.neutral,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}


  /// Center Column 
  Widget _buildCenterColumn(BuildContext context){
    return Expanded(
      child: Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile('ID', ' ${product.id}'),
                  if (product.getExpirationDate().isNotEmpty)
                    InfoTile('Scadenza', ' ${product.getExpirationDate()}'),
                  InfoTile('Quantità disponibile', ' ${product.getQuantity()}' + ((product is! MilkBatch) ? "Kg" : "L")),
                  InfoTile('Prezzo', ' ${product.getUnitPrice()}FTL'),
                  SizedBox(height: 30),
                  if(dialogType == DialogType.DialogConversion) //Il consumer non può convertire

                    DialogConversionCenter(product: product, wallet: wallet)
                  else if(dialogType == DialogType.DialogPurchase)
                    
                    DialogPurchaseCenter(product: product,userType: userType, buyer :buyer)
                ],
              ),
            )
    );
  }

  /// Right Column 
  Widget _buildRightColumn(BuildContext context){
    return IntrinsicWidth(
              child: (dialogType == DialogType.DialogConversion) ? DialogConversionRight() : DialogPurchaseRight(wallet), // Puoi fornire un widget vuoto o un altro widget di fallback
            );
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicWidth(
        stepHeight: 5.5,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(30.5),
            child: Row(
              children: [
                _buildLeftColumn(context),
                SizedBox(width: 30.0),
                _buildCenterColumn(context),
                SizedBox(width: 30.0),
                _buildRightColumn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DialogProductDetailsPurchased extends StatelessWidget {

  final ProductPurchased product;
  final DialogType dialogType; // Nuovo parametro
  final String wallet; // Seller 
  final String buyer;
  final String userType;

  const DialogProductDetailsPurchased({
    required this.product,
    required this.dialogType,
    required this.wallet, 
    required this.userType, 
    required this.buyer
  });

  

   static void showObjectPurchased(BuildContext context,String wallet,ProductPurchased product, DialogType dialogType, String userType, String walletBuyer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogProductDetailsPurchased(product: product, dialogType: dialogType, wallet: wallet, userType: userType, buyer: walletBuyer);
      },
    );
  }


    Widget _buildLeftColumn(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.0,
            width: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(Enums.getAssetPath(product.getAsset())),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0), // Adjust spacing as needed
          CustomButton(
            text: "Back",
            type: CustomType.neutral,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}


  /// Center Column 
  Widget _buildCenterColumn(BuildContext context){
    return Expanded(
      child: Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile('ID', ' ${product.id}'),
                  if (product.getExpirationDate().isNotEmpty)
                    InfoTile('Scadenza', ' ${product.getExpirationDate()}'),
                    InfoTile('Quantità disponibile', ' ${product.getQuantity()}' + ((product is! MilkBatchPurchased) ? "Kg" : "L")),
                  SizedBox(height: 30),
                  if(dialogType == DialogType.DialogConversion && Enums.getActor(userType) != Actor.Consumer) //Il consumer non può convertire)

                    DialogConversionCenterPurchased(product: product, wallet: wallet)
                ],
              ),
            )
    );
  }

  /// Right Column 
  Widget _buildRightColumn(BuildContext context){
    return IntrinsicWidth(
              child: (dialogType == DialogType.DialogConversion) ? DialogConversionRight() : DialogPurchaseRight(wallet), // Puoi fornire un widget vuoto o un altro widget di fallback
            );
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicWidth(
        stepHeight: 5.5,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(30.5),
            child: Row(
              children: [
                _buildLeftColumn(context),
                SizedBox(width: 30.0),
                _buildCenterColumn(context),
                SizedBox(width: 30.0),
                _buildRightColumn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





//Crea un div per ogni info
class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white, // Imposta il colore del testo a bianco
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

