import 'package:flutter/material.dart';
import 'package:filiera_token_front_end/utils/enums.dart';

class CustomCard extends StatelessWidget {
  final String productName;
  final String description;
  final String? expirationDate; // Rendere la data di scadenza opzionale
  final String seller;
  final double price;
  final Asset image;
  final VoidCallback? onTap;

  const CustomCard({
    required this.productName,
    required this.description,
    this.expirationDate, // Aggiornato il tipo di dato
    required this.seller,
    required this.price,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(90),
        onTap: onTap,
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.asset(
                  Enums.getAssetPath(image),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$price'+'FTL',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    if (expirationDate != null) // Verifica se la data di scadenza è fornita
                      Text(
                        'Scadenza: $expirationDate',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    /*Text(
                      seller,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      )
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomCardPurchased extends StatelessWidget {
  final String productName;
  final String description;
  final String? expirationDate; // Rendere la data di scadenza opzionale
  final String seller;
  final Asset image;
  final VoidCallback? onTap;

  const CustomCardPurchased({
    required this.productName,
    required this.description,
    this.expirationDate, // Aggiornato il tipo di dato
    required this.seller,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(90),
        onTap: onTap,
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.asset(
                  Enums.getAssetPath(image),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        /*Text(
                          '$price'+'FTL',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),*/
                      ],
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    if (expirationDate != null) // Verifica se la data di scadenza è fornita
                      Text(
                        'Scadenza: $expirationDate',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    /*Text(
                      seller,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      )
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
