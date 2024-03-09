import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  factory SecureStorageService()  {
    final instance = SecureStorageService._internal();
    return instance;
  }

  final FlutterSecureStorage storage = FlutterSecureStorage(webOptions: WebOptions());



   // **Save User data securely (assuming password is already hashed):**
  Future<void> save(
    String id,
     String fullName,
     String email,
     String password,
     String balance,
     String wallet,
      Actor type
    ) async {
    try {

    print("Sono nel metodo di Save del SignIn -------------------------");

      await storage.write(key: 'wallet', value: wallet);
      await storage.write(key: 'user_id', value: id);
      await storage.write(key: 'full_name', value: fullName);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'balance', value: balance);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'type', value: Enums.getActorText(type)); 
      // Assuming Actor has a toString() method
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error saving user data: $e');
    }
  }

  // **Get User data:**
  Future<User?> get() async {
    try {
      print("Sono nel metodo di getting ! ----------------------------");
      final userId = await storage.read(key: 'user_id');
      final fullName = await storage.read(key: 'full_name');
      final email = await storage.read(key: 'email');
      final balance = await storage.read(key: 'balance');
      final password = await storage.read(key: 'password');
      final walletStored = await storage.read(key: 'wallet');
      final typeString = await storage.read(key: 'type');
      final type = Enums.getActor(typeString!);
      print("Sono all'interno della Get()");

      if (userId != null && fullName != null && email != null && balance != null && password!=null && type!=null && walletStored!=null) {
        
      print("Ho effettuato il getting dei miei dati !");
        return User(
          id: userId,
          fullName: fullName,
          email: email,
          balance: balance,
          type: type, 
          wallet: walletStored,
          password: password,
        );
      }

    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error getting user data: $e');
    }
    return null;
  }

  // **Get User data:**
  Future<String?> getWallet() async {
    try {

      final wallet = await storage.read(key: 'wallet');

      if (wallet!=null) {
        return wallet;
      }
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error getting user data: $e');
    }
    return null;
  }

  // **Delete User data:**
  Future<bool> delete() async {
    try {
      await storage.delete(key: 'user_id');
      await storage.delete(key: 'full_name');
      await storage.delete(key: 'email');
      await storage.delete(key: 'password');
      await storage.delete(key: 'balance');
      await storage.delete(key: 'wallet');
      await storage.delete(key: 'type');
      await storage.delete(key: 'token');
      return true;
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error deleting user data: $e');
      return false;
    }
  }





  /// Metodo : Salvataggio del Token JWT
  Future<void> saveJWT(String tokenJWT) async {

      try {

    print("Sono nel metodo di Save del jwt -------------------------");

      await storage.write(key: 'token', value: tokenJWT); 
      // Assuming Actor has a toString() method
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error saving user data: $e');
    }

  }


    // **Get User TOKEN:**
  Future<String?> getJWT() async {
    try {

      final token = await storage.read(key: 'token');

      if (token!=null) {
        return token;
      }
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error getting user data: $e');
    }
    return null;
  }
}