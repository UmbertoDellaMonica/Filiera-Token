import 'package:filiera_token_front_end/components/organisms/user_environment/services/jwt_service.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/user_service.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';


class SigninService {


  /// Injection of Service 
  
  final userService = UserSerivce();

  final jwtService = JwtService();



  Future<bool> checkLogin(
    String emailInput,
    String passwordInput,
    String walletInput,
    String selectedValueUserType, 
    )async {
      return await userService.login(emailInput, passwordInput, walletInput, selectedValueUserType);
    }

  Future<User?> onLoginSuccess(String selectedValueUserType, String walletInput, SecureStorageService secureStorageService) async{
    /// Go to Home User page 
    /// Create a JWT (Optional)  
    
    /// Move to home-page-user and select our product 
    User? userProvider =  await userService.getData(selectedValueUserType,walletInput);
    // Inserisco nel Database Singleton
    await _saveUserReference(userProvider!,walletInput, secureStorageService);

    String tokenJWT = await  jwtService.generateJwtToken(
        userProvider.email,
        userProvider.password,
        walletInput,
        Enums.getActorText(userProvider.getType)
      );

    secureStorageService.saveJWT(tokenJWT);

    return userProvider;
  }




  Future<void> _saveUserReference(User user, String wallet, SecureStorageService secureStorageService) async {    
      await secureStorageService.save(
        user.id,
        user.fullName,
        user.email,
        user.password,
        user.balance,
        wallet,
        user.type
      );
  }
}