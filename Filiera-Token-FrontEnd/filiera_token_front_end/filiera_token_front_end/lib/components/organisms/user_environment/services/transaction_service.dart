import 'dart:convert';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;


class TransactionService {


Future<bool> buyMilkBatchProduct(
  String milkBatchId,
   String quantityToBuy,
   String buyer,
   String ownerMilkBatch,
   String totalPrice,
) async {

  print("Sono nel metodo di Acquisto finale!");
  var url = Uri.parse(API.buildURL(API.CheeseProducerNodePort,API.TransactionBuyMilkBatchService , API.Invoke, "BuyMilkBatchProduct"));

  var body = jsonEncode(API.buyMilkBatchProductBody(milkBatchId, quantityToBuy, buyer, ownerMilkBatch, totalPrice));

  try {
    var response = await http.post(
      url,
      headers: API.getHeaders(),
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      // Transazione è stata effettuata con successo 
      print('Risposta: ${response.body}');
      return true;

    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
    return false;
  }
}



Future<bool> buyCheeseBlockProduct(
   String cheeseBlockId,
   String quantityToBuy,
   String buyer,
   String ownerMilkBatch,
   String totalPrice,
) async {
  var url = Uri.parse(API.buildURL(API.RetailerNodePort,API.TransactionBuyCheeseService , API.Invoke, "BuyCheeseProduct"));
  var body = jsonEncode(API.buyCheeseBlockProductBody(cheeseBlockId, quantityToBuy, buyer, ownerMilkBatch, totalPrice));
  var header = API.getHeaders();

  try {
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print('Risposta: ${response.body}');
      return true;
    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
    return false;
  }
}



Future<bool> buyCheesePieceProduct(
  String cheesePieceId,
   String quantityToBuy,
   String buyer,
   String ownerCheesePiece,
   String totalPrice,
) async {
  var url = Uri.parse(API.buildURL(API.ConsumerNodePort,API.TransactionBuyCheesePieceService , API.Invoke, "BuyCheesePieceProduct"));
  var body = jsonEncode(API.buyCheesePieceProductBody(cheesePieceId, quantityToBuy, buyer, ownerCheesePiece, totalPrice));
  var header = API.getHeaders();

  print(url);

  try {
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print('Risposta: ${response.body}');
      return true;
    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
    return false;
  }
}




  
}