import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class PurchaseDialog extends StatefulWidget {
  final Product product;

  PurchaseDialog({required this.product});

  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  TextEditingController quantityController = TextEditingController();
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return buildColumnCenter();
  }

  Widget buildColumnCenter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantità richiesta:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                int quantity = int.parse(value);
                setState(() {
                  totalPrice = (quantity * widget.product.getUnitPrice()) as int;
                });
              }
            },
          ),
          SizedBox(height: 4.0),
          Text(
            'Total Price: ${totalPrice.toStringAsFixed(2)}FT',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildColumnRight() {
    return Text('Contenuto per PurchaseDialog');
  }
}
