import 'dart:convert';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:http/http.dart' as http;


class RetailerService {

  static const String _apiUrl = 'http://127.0.0.1:5002/api/v1';


  static const String _APINameRetailer = "RetailerService";

  static const String _queryRetailerData = 'getRetailerData';
  
  static const String _queryRetailerID = 'getRetailerId';

  static const String _queryRetailerList = 'getListAddressRetailer';

  static const String queryLogin = 'login';


  Future<bool> registerRetailer(String email, String fullName, String password, String walletRetailer) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/invoke/registerRetailer';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletRetailer);

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

  Future<bool> loginRetailer(String email, String password, String wallet) async {

    const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/query/$queryLogin';
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


  Future<String> getRetailerId(String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/query/$_queryRetailerID';
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
      final String idRetailer = data['output'];
      return idRetailer;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Recupero ID Non avvenuto!');
      return error.toString();
    }
  }

  Future<User?> getRetailerData(String id, String wallet) async {
  const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/query/$_queryRetailerData';

    final body = jsonEncode({
      "input": {
        "id": id,
        "walletRetailer": wallet,
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

      return _getUserData(data, Actor.Retailer,wallet);
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }

    _getIDPayload(String walletRetailer) {

    return  {
      "input":{
          "walletRetailer": walletRetailer,
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

  
  Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String walletRetailer) {
    return {
      'input': {
        'email': email,
        'fullName': fullName,
        'password': password,
        'walletRetailer': walletRetailer,
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
          "walletRetailer": wallet,
        }
      };
    }

  Future<List<String>> getListRetailers() async {
  String url = API.buildURL(API.ConsumerNodePort, API.RetailerService, API.Query, _queryRetailerList);
    

    final headers = _getHeaders();

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({}),
     headers: headers,
    );

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);


      final List<String> retailerList = jsonData['output'].cast<String>();


      return retailerList;
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }

}