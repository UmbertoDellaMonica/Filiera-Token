
import 'dart:convert';

import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;



class CheeseProducerBuyerService {

  static const String _queryGetMilkBatchPurchase="getUserMilkBatchIds";

  static const String _queryGetMilkBatch ="getMilkBatch";


  Future<List<ProductPurchased>> getMilkBatchList(String wallet) async {
    String url = API.buildURL(API.CheeseProducerNodePort,API.CheeseProducerBuyerService, API.Query, _queryGetMilkBatchPurchase);

    print(url);

    final headers = API.getHeaders();

    print(headers);

    final body = jsonEncode(API.getCheeseProducerPayload(wallet));

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();

        print("List : "+idList.toString());
        List<ProductPurchased> productList = [];

        for (int i = 0; i < idList.length; i++) {
          ProductPurchased product = await getMilkBatch(idList[i],wallet);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch MilkBatch Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching MilkBatch Id List: $error');
      rethrow;
    }
  }


  Future<ProductPurchased> getMilkBatch(String cheeseId, String walletMilkHub) async {
    
    String url = API.buildURL(API.CheeseProducerNodePort,API.CheeseProducerBuyerService, API.Query, _queryGetMilkBatch);
    
    final body = jsonEncode(API.getMilkBatchForCheeseProducerBody(cheeseId, walletMilkHub));
    final headers = API.getHeaders();

    final response = await http.post(Uri.parse(url), body: body, headers: headers);

    if(response.statusCode == 200){
      print(response.toString());
      
      final jsonData = jsonDecode(response.body);

      print(jsonData);

      return MilkBatchPurchased.fromJson(jsonData);
    }else{
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
    }
  }





}