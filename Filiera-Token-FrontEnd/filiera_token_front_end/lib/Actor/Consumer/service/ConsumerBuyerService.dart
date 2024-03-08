import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsumerBuyerService {

  Future<List<ProductPurchased>> getCheesePieceList(String wallet) async {

    String url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Query, "getUserCheesePieceIds");


    final headers = API.getHeaders();


    final body = jsonEncode(API.getConsumerPayload(wallet));

    print("Sono qui  --------------------");

    print("[URL]:"+url);


    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print("Erorre : "+response.body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();

        print("List : "+idList.toString());
        List<ProductPurchased> productList = [];

        for (int i = 0; i < idList.length; i++) {
          ProductPurchased product = await getCheesePiece(idList[i],wallet);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece Id List: $error');
      rethrow;
    }
  }

  // Effettuo una chiamata di prova per cercare di aggiungere i prodotti 

  Future<ProductPurchased> addCheesePiece(String id, String price, String walletConsumerBuyer, String walletRetailer, String weight) async {
    final url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Invoke, "addCheesePiece");
    
    final body = jsonEncode({
      'input': {
        '_id': id,
        '_price': price,
        '_walletConsumerBuyer': walletConsumerBuyer,
        '_walletRetailer': walletRetailer,
        '_weight': weight,
      },
    });
    final headers = API.getHeaders();
      try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        print(jsonData);

        return CheesePiecePurchased.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch CheesePiece: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece: $error');
      rethrow;
    }
  }

  Future<ProductPurchased> getCheesePiece(String cheeseId, String walletConsumerBuyer) async {

    
    String url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Query, "getCheesePiece");
    
    final body = jsonEncode(API.getCheesePieceForConsumerBody(cheeseId, walletConsumerBuyer));
    final headers = API.getHeaders();

    print("[BODY]:"+body);

    final response = await http.post(Uri.parse(url), body: body, headers: headers);


    if(response.statusCode == 200){
      
      final jsonData = jsonDecode(response.body);

      return CheesePiecePurchased.fromJson(jsonData);
    }else{
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
    }
  }
}
