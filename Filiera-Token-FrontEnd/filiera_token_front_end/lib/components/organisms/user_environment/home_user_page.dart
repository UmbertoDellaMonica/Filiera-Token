
import 'package:filiera_token_front_end/Actor/CheeseProducer/service/CheeseProducerInventoryService.dart';
import 'package:filiera_token_front_end/Actor/MilkHub/service/MilkHubInventoryService.dart';
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerInventoryService.dart';
import 'package:filiera_token_front_end/components/atoms/custom_balance.dart';
import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/components/custom_menu_home_user_page_environment.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:get_it/get_it.dart';


class HomePageUser extends StatefulWidget {

  final String userType;
  final String idUser;
  const HomePageUser({
    Key? key,
    required this.userType,
     required this.idUser, 
    }) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageUser> with SingleTickerProviderStateMixin {

  late AnimationController _drawerSlideController;

  late SecureStorageService secureStorageService;


  MilkHubInventoryService milkHubInventoryService = MilkHubInventoryService();
  
  RetailerInventoryService retailerInventoryService = RetailerInventoryService();

  CheeseProducerInventoryService cheeseProducerInventoryService = CheeseProducerInventoryService();

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
      Future<List<Product>> productList = Future.value([]);

      print(actor);
      print(wallet);

      String emptyMsg = "";

    switch(actor) {
      case Actor.CheeseProducer:{
      // Milkhub List
        productList = milkHubInventoryService.getMilkBatchListAll(wallet);
        emptyMsg = "Partite di Latte da acquistare";
        break;
      }
      case Actor.Retailer:{
        productList = cheeseProducerInventoryService.getCheeseBlockAll(wallet);
        emptyMsg = "Blocchi di Formaggio da acquistare";
        break;
      }
      case Actor.Consumer:{
        productList = retailerInventoryService.getCheesePieceAll(wallet);
        emptyMsg = "Pezzi di Formaggio da acquistare";
        break; 
      } 

      default:{
        emptyMsg = "prodotti da acquistare";
        print("Errore nella selezione dell'attore in fase di build (home_user_page.dart)");
        break;
    }
    }

      return Scaffold(
          appBar: _buildAppBar(),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(50.5),
                  child: 
                    CustomProductList(productList: productList, onProductTap: handleProductTap, emptyMsg: emptyMsg),
                ),
                _buildDrawer(),  
              ],
            ),
            floatingActionButton: CustomBalance(user: user!),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          );
    }
  }

  void handleProductTap(BuildContext context, Product product) {
    // Fai qualcosa in base alla pagina in cui ti trovi
    print("Prodotto ${product.name} cliccato!");
    // Esegui azioni diverse in base alla pagina
    DialogProductDetails.show(
      context, 
      product.seller,
      product,
      DialogType.DialogPurchase,
      widget.userType,
      user!.wallet
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
      title: 'Filiera-Token-Homepage',
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
          child: _isDrawerClosed() ? const SizedBox() :  CustomMenuHomeUserPageEnv(userData: user!, secureStorageService: secureStorageService),
        );
      },
    );
  }





}