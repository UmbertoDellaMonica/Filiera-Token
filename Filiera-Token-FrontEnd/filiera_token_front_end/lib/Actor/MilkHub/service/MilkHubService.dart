import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MilkHubService{

    static const String _apiUrl = 'http://127.0.0.1:5000/api/v1';

  static const String _APINameMilkHub = "MilkHubService";

  static const String queryLogin = 'login';

  static const String _queryMilkHubData = 'getMilkHubData';
  
  static const String _queryMilkHubID = 'getMilkHubId';
  
  static const String _queryListMilkhubs = 'getListAddressMilkHub';



  Future<bool> registerMilkHub(String email, String fullName, String password, String walletMilkHub) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletMilkHub);

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
      print('Registrazione Non avvenuta!' + error);
      return false;
    }
  }

  
  Future<bool> loginMilkHub(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/query/$queryLogin';
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



  Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String walletMilkHub) {
    return {
      'input': {
        'email': email,
        'fullName': fullName,
        'password': password,
        'walletMilkHub': walletMilkHub,
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
          "walletMilkHub": wallet,
        }
      };
    }



  Future<String> getMilkHubId(String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/query/$_queryMilkHubID';
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
      final String idMilkHub = data['output'];
      return idMilkHub;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Recupero ID Non avvenuto!');
      return error.toString();
    }
  }

  Future<User?> getMilkHubData(String id, String wallet) async {
  const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/query/$_queryMilkHubData';


    final body = jsonEncode({
      "input": {
        "id": id,
        "walletMilkHub": wallet,
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

      return _getUserData(data, Actor.MilkHub,wallet);
    
    } else {
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }

    _getIDPayload(String walletMilkHub) {

    return  {
      "input":{
          "walletMilkHub": walletMilkHub,
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


  Future<List<String>>getListMilkHubs() async {
      String url = API.buildURL(API.MilkHubNodePort, API.MilkHubService, API.Query, _queryListMilkhubs);
    print(" Sono nella funzione di getListMilkHubs! url : "+url);

    final headers = _getHeaders();

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({}),
     headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);

      final List<String> milkhubsList = jsonData['output'].cast<String>();

      print(milkhubsList);

      return milkhubsList;
    
    } else {
      print(response.body);
      throw Exception('Errore durante la chiamata API: ${response.statusCode}');
    }
  }




}



