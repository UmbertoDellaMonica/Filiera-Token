import 'package:bcrypt/bcrypt.dart';
import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/atoms/custom_input_validator.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up_page/components/custom_menu_singup.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



// Package Utils
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/atoms/custom_dropdown.dart';

// UserService - Registration
import 'package:filiera_token_front_end/components/organisms/user_environment/services/user_service.dart';



class MySignUpPage extends StatefulWidget {

  const MySignUpPage({super.key,required this.title});

  final String title;

  @override
  State<MySignUpPage> createState() => _MySignUpPageAnimations();

}

class _MySignUpPageAnimations extends State<MySignUpPage> with SingleTickerProviderStateMixin{

  var dropdownItems = ["MilkHub","CheeseProducer", "Retailer", "Consumer"];
  
  late String selectedValueUserType;

  late String nameInput;
  late String cognomeInput;
  late String fullName;

  String salt = "\$2a\$10\$Gs.PmaGJQtm0ThQF3VkX2u";



  late String emailInput;
  late String passwordInput;
  late String confermaPasswordInput;
  late String walletInput;
  
  TextEditingController ?_nameController;
  TextEditingController ?_lastNameController;
  TextEditingController ? _emailController;
  TextEditingController ?_passwordController;
  TextEditingController ?_confirmPasswordController;
  TextEditingController ?_walletController;

  /// Injection of Service 
  final userService = UserSerivce();
  /// Injection of Static Widget 
  final customPopUpDialog = CustomPopUpDialog();

  late AnimationController _drawerSlideController;



  
  @override
  void initState() {
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _walletController = TextEditingController();
    selectedValueUserType = "MilkHub";
    super.initState();

     _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }


   @override
  void dispose() {
    // Clean up the controllers when the Widget is disposed
    _nameController?.dispose();
    _lastNameController?.dispose();
    _emailController?.dispose(); 
     _passwordController?.dispose();
    _confirmPasswordController?.dispose();
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
   * Build Form di Registrazione 
   */
  Widget buildFormRegistrazione(BuildContext context) {
    // Form di iscrizione
    return Center(
      child: Expanded(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Registrazione', // Titolo "Login"
                style: TextStyle(
                  fontSize: 24.0, // Dimensione del testo
                  fontWeight: FontWeight.bold, // Grassetto
                  color: ColorUtils.getColor(CustomType.neutral), // Colore neutral
                ),
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.name,
                labelText: 'Nome',
                controller: _nameController!,
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.name,
                labelText: 'Cognome',
                controller: _lastNameController!,
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.emailAddress,
                labelText: 'Email',
                controller: _emailController!,
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.visiblePassword,
                labelText: 'Password',
                controller: _passwordController!,
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.visiblePassword,
                labelText: 'Conferma password',
                controller: _confirmPasswordController!,
              ),
              const SizedBox(height: 10),
              CustomInputValidator(
                inputType: TextInputType.text,
                labelText: 'Wallet',
                controller: _walletController!,
              ),
              const SizedBox(height: 10),
              CustomDropdown<String>(
                items: dropdownItems,
                value: "MilkHub",
                onChanged: (value) {
                  setState(() {
                    selectedValueUserType = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                expandWidth: true,
                text: "Registrati",
                type: CustomType.neutral,
                onPressed: () async {
                  // Recupera i valori dai controller
                  nameInput = _nameController!.text;
                  cognomeInput = _lastNameController!.text;
                  emailInput = _emailController!.text;
                  passwordInput = _passwordController!.text;
                  confermaPasswordInput = _confirmPasswordController!.text;
                  walletInput = _walletController!.text;

                  fullName = nameInput + " " + cognomeInput;

                  if(passwordInput != confermaPasswordInput) {
                      CustomPopUpDialog.show(context, AlertDialogType.Signup, CustomType.error, errorDetail: "Le password non corrispondono.");
                  } else {
                    String passwordHashed = _hashPassword(confermaPasswordInput);
                    if (await userService.registrationUser(
                        emailInput, fullName, passwordHashed, walletInput, selectedValueUserType)) {
                      /// TRUE Registration
                      CustomPopUpDialog.show(context, AlertDialogType.Signup, CustomType.success, path: "/signin");
                    } else {
                      /// FALSE Registration
                      CustomPopUpDialog.show(context, AlertDialogType.Signup, CustomType.error);
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Hai già un account?',
                  style: TextStyle(
                    color: ColorUtils.labelColor,
                  ),
                ),
              ),
              CustomButton(
                expandWidth: true,
                text: "Login",
                type: CustomType.neutral,
                onPressed: () => context.go('/signin')),
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




  /***
   * Build Registered Action 
   */
  Widget buildIsRegistered(BuildContext context){
      return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Hai già un account?'),
                SizedBox(width: 20,height: 0),
                
                CustomButton(
                  text: "Login",
                  type: CustomType.neutral,
                  onPressed: () => context.go('/signin'),
                ),
              ],
            );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
          children: <Widget>[
            /// Registration Form 
            buildFormRegistrazione(context),
            _buildDrawer(),
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
      title: 'Filiera-Token-Registrazione',
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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuSignup(),
        );
      },
    );
  }
}