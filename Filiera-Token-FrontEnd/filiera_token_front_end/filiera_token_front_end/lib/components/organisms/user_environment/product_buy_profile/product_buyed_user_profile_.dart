import 'package:filiera_token_front_end/Actor/CheeseProducer/service/CheeseProducerBuyerService.dart';
import 'package:filiera_token_front_end/Actor/Consumer/service/ConsumerBuyerService.dart';
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerBuyerService.dart';
import 'package:filiera_token_front_end/components/atoms/custom_balance.dart';
import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/components/custom_menu_product_buyed.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Prodotti acquistati
class UserProfileProductBuyed extends StatefulWidget {

  final String  userType;
  final String idUser;
  const UserProfileProductBuyed({Key? key, 
  required this.userType,
   required this.idUser
   }) : super(key: key);

  @override
  State<UserProfileProductBuyed> createState() => _UserProfileProductBuyedState();
  
}

class _UserProfileProductBuyedState extends State<UserProfileProductBuyed> with SingleTickerProviderStateMixin{

  late AnimationController _drawerSlideController;

  late SecureStorageService secureStorageService;

  ConsumerBuyerService consumerBuyerService = ConsumerBuyerService();
  
  RetailerBuyerService retailerBuyerService = RetailerBuyerService();

  CheeseProducerBuyerService cheeseProducerBuyerService = CheeseProducerBuyerService();


  User? user;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    final storage = GetIt.I.get<SecureStorageService>();
    if(storage!=null){
      print("storage non è nullo!");
      secureStorageService = storage;
      _fetch_Data();
      
    }
  }

  Future<void> _fetch_Data() async {
  final retrievedUser = await secureStorageService.get();
  if (retrievedUser != null) {
    setState(() {
      user = retrievedUser;
    });
    print("Type of User : ${user!.type.name}");
    print("User is Alive!");
  }
}

  @override
  void dispose() {
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


  
  
  // Indice della pagina corrente
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
  // Ottieni l'istanza di UserProvider
    if (user == null) {
    // Se user non è ancora stato inizializzato, visualizza un indicatore di caricamento o un altro widget di fallback
      return CustomLoadingIndicator(progress: 4.5);
      } else {

      print("Build!");
      Actor actor = user!.type; //TODO: gettarsi con hive il valore dell'attore    
      String wallet = user!.wallet; //TODO: gettarsi con hive il wallet
      Future<List<ProductPurchased>> productList = Future.value([]);

      print(actor);
      print(wallet);
      String emptyMsg = "";


      switch(actor) {
        case Actor.Consumer:{
          productList = consumerBuyerService.getCheesePieceList(wallet);
          emptyMsg = "Pezzi di Formaggio acquistati";
          break;}
        case Actor.CheeseProducer:{
          productList = cheeseProducerBuyerService.getMilkBatchList(wallet);
          emptyMsg = "Partite di Latte acquistate";
          break;}
        case Actor.Retailer:{
          productList = retailerBuyerService.getCheeseBlockList(wallet);
          emptyMsg = "Blocchi di Formaggio acquistati";
          break; }
        default:{
          emptyMsg = "prodotti";
          print("Errore nella selezione dell'attore in fase di build (product_buyed_page.dart)");
          break;
        }
      }

      return Scaffold(
        appBar: _buildAppBar(),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(50.5),
                child: CustomProductListPurchased(productList: productList,onProductTap: handleProductTap, emptyMsg: emptyMsg),
              ),
              _buildDrawer()
            ],
          ),
        );
    }

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
      title: 'Filiera-Token-Product-Buyed',
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
          child: _isDrawerClosed() ? const SizedBox() :  CustomMenuUserProductBuyed(userData: user! ,secureStorageService: secureStorageService,),
        );
      },
    );
  }

  void handleProductTap(BuildContext context, ProductPurchased product) {
    // Fai qualcosa in base alla pagina in cui ti trovi
    print("Prodotto ${product.name} cliccato!");
    // Esegui azioni diverse in base alla pagina

    DialogProductDetailsPurchased.showObjectPurchased(
      context,
      user!.wallet, 
      product,
      DialogType.DialogConversion,
      widget.userType,
      product.seller
      );
  }



}