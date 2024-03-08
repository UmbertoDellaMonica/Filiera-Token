import 'dart:async' show Future;
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerService.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RetailerInventoryService {

  RetailerService retailerService = RetailerService();


  Future<List<Product>> getCheesePieceList(String wallet) async {
    String url = API.buildURL(API.RetailerNodePort, API.RetailerInventoryService, API.Query, "getUserCheesePieceIds");


    final headers = API.getHeaders();


    final body = jsonEncode(API.getRetailerPayload(wallet));

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {

        if(idList[i].compareTo('0')!=0){

          Product product = await getCheesePiece(wallet, idList[i]);
          productList.add(product);
        }
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

   Future<Product> getCheesePiece(String wallet, String id) async {
    String url = API.buildURL(API.RetailerNodePort, API.RetailerInventoryService, API.Query, "getCheesePiece");
    final headers = API.getHeaders();
    
    final body = jsonEncode(API.getCheesePieceRetailerPayload(wallet, id));

    print(body);
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        return CheesePiece.fromJson(jsonData, wallet);
      } else {
        throw Exception('Failed to fetch CheesePiece: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece: $error');
      rethrow;
    }
  }

  Future<bool> transformCheesePiece(String wallet, String idCheeseBlock, String quantityToTransform, String price) async {
    String url = API.buildURL(API.RetailerNodePort, API.RetailerInventoryService, API.Invoke, "transformCheeseBlock");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getTransformRetailerBody(idCheeseBlock, price, quantityToTransform, wallet));

    print(url);
    print(headers);
    print(body);
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {        
        return true;
      } else {
          throw Exception('Failed to transform CheeseBlock in CheesePiece: ${response.statusCode}');
      }

    } catch (error) {
      print('Error transforming CheeseBlock in CheesePiece: $error');
      rethrow;
    }
  }

  /**
   * Questa funzione restituisce una lista di tutti gli elementi del CheesePiece che un Consumer può vedere.
   */
  Future<List<Product>> getCheesePieceAll(String walletCheeseProducer) async {
    
    
    try {

    
        List<String> addressRetailerList = await retailerService.getListRetailers();
        List<Product> productList = [];


        for (int i = 0; i < addressRetailerList.length; i++) {
        
           if(addressRetailerList[i].compareTo('0')!=0){
        
            List<Product> productListRetailer = await getCheesePieceList(addressRetailerList[i]);
            productList.addAll(productListRetailer);
        
          }
        }

        return productList;
        
      } catch (error) {
      print('Error fetching MilkBatch Id List: $error');
      rethrow; // Re-throw to allow external handling of errors
    }
  }


  

}
