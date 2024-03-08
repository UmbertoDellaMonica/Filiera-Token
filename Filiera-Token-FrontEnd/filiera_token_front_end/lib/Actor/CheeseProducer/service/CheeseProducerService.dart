import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheeseProducerService{

    static const String _apiUrl = 'http://127.0.0.1:5001/api/v1';


  static const String _APINameCheeseProducer = "CheeseProducerService";

  static const String queryLogin = 'login';

  static const String _queryCheeseProducerData = 'getCheeseProducerData';
  
  static const String _queryCheeseProducerID = 'getCheeseProducerId';

  static const String _queryListCheeseProducers = 'getListAddressCheeseProducer';




  Future<bool> registerCheeseProducer(String email, String fullName, String password, String walletCheeseProducer) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/invoke/registerCheeseProducer';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletCheeseProducer);

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
      final error = jsonDecode(response.body)['error'];
      print('Registrazione Non avvenuta!');
      return false;
    }
  }


  Future<bool> loginCheeseProducer(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/query/$queryLogin';
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
    print(response.body);

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

    
  Future<String> getCheeseProducerId(String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/query/$_queryCheeseProducerID';
      final headers = _getHeaders();
      final body = _getIDPayload(wallet);
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
      final String idCheeseProducer = data['output'];
      return idCheeseProducer;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Recupero ID Non avvenuto!');
      return error.toString();
    }
  }

  Future<User?> getCheeseProducerData(String id, String wallet) async {
  const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/query/$_queryCheeseProducerData';

    final body = jsonEncode({
      "input": {
        "id": id,
        "walletCheeseProducer": wallet,
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

      return _getUserData(data, Actor.CheeseProducer,wallet);
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }


  
  Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String wallet) {
    return {
      'input': {
        'email': email,
        'fullName': fullName,
        'password': password,
        'walletCheeseProducer': wallet,
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

  Map<String, dynamic> _getLoginPayload(String email, String password, String wallet) {
      return {
        "input": {
          "email": email,
          "password": password,
          "walletCheeseProducer": wallet,
        }
      };
    }

      _getIDPayload(String walletCheeseProducer) {

    return  {
      "input":{
          "walletCheeseProducer": walletCheeseProducer,
        }
    };
  }

  User _getUserData(Map<String, dynamic> response, Actor selected, String wallet){
    return User(
        id: response['output'],
        fullName: response['output1'],
        password: response['output2'],
        email: response['output3'],
        balance: response['output4'], 
        wallet: wallet,
        type: selected,
      );
  }

  Future<List<String>> getListCheeseProducers() async{
    String url = API.buildURL(API.RetailerNodePort, API.CheeseProducerService, API.Query, _queryListCheeseProducers);
    
    final headers = _getHeaders();

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({}),
     headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<String> milkhubsList = jsonData['output'].cast<String>();

      return milkhubsList;
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }

  
}