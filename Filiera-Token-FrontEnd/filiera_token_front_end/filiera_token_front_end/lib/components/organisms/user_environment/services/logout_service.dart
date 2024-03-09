import 'package:filiera_token_front_end/components/organisms/user_environment/services/jwt_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';

class LogoutService {

  final JwtService jwtService = JwtService();

  Future<bool> deleteUserData(SecureStorageService secureStorageService, String token)async {
    if(await jwtService.invalidateToken(token)){
     return await secureStorageService.delete();
    }else{
      return false;
    }
  }



}