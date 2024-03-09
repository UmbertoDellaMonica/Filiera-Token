

import 'dart:convert';

import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:http/http.dart' as http;



class ConsumerService {


  static const String _apiUrl = 'http://127.0.0.1:5003/api/v1';

  static const String _APINameConsumer = "ConsumerService";

  static const String _queryLogin = 'login';

  static const String _queryRegister = 'registerConsumer';

  static const String _queryConsumerData = 'getConsumerData';

  static const String _queryConsumerID = 'getConsumerId';

    Future<bool> registerConsumer(String email, String fullName, String password, String walletConsumer) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/invoke/$_queryRegister';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletConsumer);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Controllo del codice di stato
    if (response.statusCode == 200 || response.statusCode == 202) {
      // Richiesta avvenuta con successo
      print('Registrazione avvenuta con successo');
      return true;
    } else {
      // Errore nella richiesta
      print('Registrazione Non avvenuta!');
      return false;
    }
  }

    Future<bool> loginConsumer(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/query/$_queryLogin';
    final headers = _getHeaders();
    final body = _getLoginPayload(email, password, wallet);
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var responseLogin = jsonDecode(response.body);
    print(password);
    print(response);
    print("Response Login :"+responseLogin.toString());

    // Controllo del codice di stato
    if ((response.statusCode == 200 || response.statusCode == 202) && responseLogin['output'] == true ) {
      // Richiesta avvenuta con successo
      print('Login avvenuto con successo');
      return true;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Login Non avvenuta!');
      return false;
    }
  }

    /**
     * Recupera l'id del Consumer 
     */
    Future<String> getConsumerId(String walletConsumer) async{
      const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/query/$_queryConsumerID';
      final headers = _getHeaders();
      final body = _getIDPayload(walletConsumer);
      final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Controllo del codice di stato
    if (response.statusCode == 200) {
      // Richiesta avvenuta con successo
      print('Recupero ID avvenuto con successo');
      // Decodifica la stringa JSON in una mappa
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Ottieni il valore dalla chiave "output"
      final String idConsumer = data['output'];
      return idConsumer;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Recupero ID Non avvenuto!');
      return error.toString();
    }
    }


    /**
     * Recupera i dati del Consumer 
     */
    Future<User?> getConsumerData(String consumerId, String walletConsumer) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/query/$_queryConsumerData';

    final body = jsonEncode({
      "input": {
        "_id": consumerId,
        "walletConsumer": walletConsumer,
      }
    });

    final headers = _getHeaders();

    final response = await http.post(
      Uri.parse(url),
     headers: headers,
      body: body
      );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return _getUserData(data, Actor.Consumer,walletConsumer);
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }

   User _getUserData(Map<String, dynamic> response, Actor selected, String walletConsumer){
    return User(
        id: response['output'],
        fullName: response['output1'],
        password: response['output2'],
        email: response['output3'],
        balance: response['output4'], 
        wallet: walletConsumer,
        type: selected,
      );
  }





  Map<String, dynamic> _getLoginPayload(String email, String password, String wallet) {
      return {
        "input": {
          "email": email,
          "password": password,
          "walletConsumer": wallet,
        }
      };
  }
    
  Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String walletMilkHub) {
        return {
          'input': {
            'email': email,
            'fullName': fullName,
            'password': password,
            'walletConsumer': walletMilkHub,
          },
        };
    }

  Map<String, String> _getHeaders() {
    return {
      'Accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',
    };
  }

  _getIDPayload(String walletConsumer) {

    return  {
      "input":{
          "walletConsumer": walletConsumer,
        }
    };
  }

  
 
}