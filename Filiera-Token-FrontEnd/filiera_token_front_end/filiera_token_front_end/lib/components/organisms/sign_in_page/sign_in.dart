import 'package:bcrypt/bcrypt.dart';
import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/atoms/custom_dropdown.dart';
import 'package:filiera_token_front_end/components/atoms/custom_input_validator.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/sign_in_page/components/custom_menu_singin.dart';
import 'package:filiera_token_front_end/components/organisms/sign_in_page/service/sign_in_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../molecules/custom_nav_bar.dart';



class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key, required this.title});

  final String title;

  @override
  State<MySignInPage> createState() => _MySignInPageAnimations();
}

class _MySignInPageAnimations extends State<MySignInPage> with SingleTickerProviderStateMixin{

  var dropdownItems = ["MilkHub","CheeseProducer", "Retailer", "Consumer"];
  
  late AnimationController _drawerSlideController;

  /// Select value to Menu 
  late String selectedValueUserType;

  /// Controller of Text 
  TextEditingController ? _emailController;
  TextEditingController ?_passwordController;
  TextEditingController ?_walletController;

  /// Dynamic Value to Retrieve 
  late String emailInput;
  late String passwordInput;
  late String walletInput;
  String salt = "\$2a\$10\$Gs.PmaGJQtm0ThQF3VkX2u";
  

  final signinService = SigninService();

  late SecureStorageService secureStorageService;




   @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _walletController = TextEditingController();
    selectedValueUserType = "MilkHub";
    
    super.initState();

    
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    final storage = GetIt.I.get<SecureStorageService>();
    if(storage!=null){
      print("storage non è nullo!");
      secureStorageService = storage;
    }
    
  }


   @override
  void dispose() {
    // Clean up the controllers when the Widget is disposed
    _emailController?.dispose(); 
     _passwordController?.dispose();
    _walletController?.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }


  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }




  /**
   * Build Back Button
   */
   Widget _buildRegisterButton(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Non sei registrato ?'),
                SizedBox(width: 20,height: 0),
                
                ElevatedButton(
                  child: const Text('Registrati'),

                  onPressed: () => context.go('/signup'),
                
                ),
              ],
            );
  }


  /**
   * Build Login Form 
   */
  Widget _buildFormLogin(BuildContext context) {
  return Center(
    child: IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorUtils.getColor(CustomType.neutral),
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Allineato a sinistra
          children: <Widget>[
            Text(
              'Login', // Titolo "Login"
              style: TextStyle(
                fontSize: 24.0, // Dimensione del testo
                fontWeight: FontWeight.bold, // Grassetto
                color: ColorUtils.getColor(CustomType.neutral), // Colore neutral
              ),
            ),
            const SizedBox(height: 20),
            CustomInputValidator(
              inputType: TextInputType.emailAddress,
              labelText: 'Email',
              controller: _emailController!,
            ),
            const SizedBox(height: 20),
            CustomInputValidator(
              inputType: TextInputType.visiblePassword,
              labelText: 'Password',
              controller: _passwordController!,
            ),
            const SizedBox(height: 20),
            CustomInputValidator(
              inputType: TextInputType.text,
              labelText: 'Wallet',
              controller: _walletController!,
            ),
            const SizedBox(height: 20),
            CustomDropdown<String>(
              items: dropdownItems,
              value: "MilkHub",
              onChanged: (value) {
                setState(() {
                  selectedValueUserType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              expandWidth: true,
              text: "Login",
              type: CustomType.neutral,
              onPressed: () async {
                emailInput = _emailController!.text;
                passwordInput = _passwordController!.text;
                walletInput = _walletController!.text;
                String passwordHashed = _hashPassword(passwordInput);
                if (await signinService.checkLogin(
                    emailInput, passwordHashed, walletInput, selectedValueUserType)) {
                  User? userLogged = await signinService.onLoginSuccess(
                      selectedValueUserType, walletInput, secureStorageService);
                  User? userDataStored = await secureStorageService.get();

                  if (userDataStored != null) {
                    CustomPopUpDialog.show(context, AlertDialogType.Signin, CustomType.success, path: '/home-page-user/$selectedValueUserType/' + userLogged!.getId);
                  }
                } else {
                  CustomPopUpDialog.show(context, AlertDialogType.Signin, CustomType.error);
                }
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Non sei ancora registrato ?',
                style: TextStyle(
                  color: ColorUtils.labelColor,
                ),
              ),
            ),
            CustomButton(
                expandWidth: true,
                text: "Registrati",
                type: CustomType.neutral,
                onPressed: () => context.go('/signup')),
          ],
        ),
      ),
    ),
  );
}



    String _hashPassword(String password) {
    final hashedPassword = BCrypt.hashpw(password, salt);
    return hashedPassword;
  }



  /**
   * Build Layout 
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nav Bar 
      appBar: _buildAppBar(),
      body: Stack(
          children: <Widget>[
            // Form di iscrizione
            _buildFormLogin(context),
            _buildDrawer()
          ],
        ),
    );
  }

     /**
   * Construisce la NavBar Custom
   * - Inserimento del Logo 
   * - Inserimento del Testo 
   * - Inserimento del Menù 
   */
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: Image.asset('../assets/filiera-token-logo.png',width: 1000, height: 1000, fit: BoxFit.fill),
      centerTitle: true,
      title: 'Filiera-Token-Login',
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.blue,
                    ),
            );
          },
        ),
      ],
    );
  }


    Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuSignin(),
        );
      },
    );
  }
}