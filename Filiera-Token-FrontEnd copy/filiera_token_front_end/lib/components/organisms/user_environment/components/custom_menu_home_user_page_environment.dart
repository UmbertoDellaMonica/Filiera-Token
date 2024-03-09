import 'package:filiera_token_front_end/components/organisms/user_environment/services/logout_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomMenuHomeUserPageEnv extends StatefulWidget {

  final User userData;
  final SecureStorageService secureStorageService;
  const CustomMenuHomeUserPageEnv({super.key, required this.userData, required this.secureStorageService});

  @override
  State<CustomMenuHomeUserPageEnv> createState() => _MenuState();
}

class _MenuState extends State<CustomMenuHomeUserPageEnv> with SingleTickerProviderStateMixin {

  final LogoutService logoutService = LogoutService();

  final List<String> _menuTitles = [];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  Duration getAnimationDuration(List<String> _menuTitles) {
    return _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;
  }

  @override
  void initState() {
    super.initState();

    User user = widget.userData;

    _menuTitles.add("Setting");

    switch(user.getType) {
      case Actor.MilkHub: {
        _menuTitles.add("Inventory");
        break;
      }
      case Actor.Consumer: {
        _menuTitles.add("Product Buyed");
        break;
      }
      default: {
        _menuTitles.add("Inventory");
        _menuTitles.add("Product Buyed");
        break;
      }
    }

    _menuTitles.add("Shop");
    _menuTitles.add("Logout");

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: getAnimationDuration(_menuTitles),
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / getAnimationDuration(_menuTitles).inMilliseconds,
          endTime.inMilliseconds / getAnimationDuration(_menuTitles).inMilliseconds,
        ),
      );
    }

  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(widget.userData),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: Image.asset('../assets/filiera-token-logo.png', 
        width: 400,
        height: 400),
      ),
    );
  }

  Widget _buildContent(User userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(userData),
        const Spacer(),
      ],
    );
  }

  List<Widget> _buildListItems(User userData) {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: CustomButton(
              text: _menuTitles[i],
              type: CustomType.neutral,
              onPressed: () async {
                print("Ho premuto il bottone dal menù principale!");
                String type = Enums.getActorText(userData.type);
                print(type);
                String userId = userData.id;

                if(_menuTitles[i].compareTo('Logout') == 0){
                  // Logout Routing 
                 await _logoutUser();
                  context.go('/');


                }else if(_menuTitles[i].compareTo('Inventory') == 0){
                  // Product Buyed Routing 
                  context.go('/home-page-user/'+type+'/'+userId+'/profile/inventory');

                }else if(_menuTitles[i].compareTo('Setting') ==0){

                  context.go('/home-page-user/'+type+'/'+userId+'/profile');

                }else if(_menuTitles[i].compareTo('Product Buyed')==0){
                  context.go('/home-page-user/'+type+'/'+userId+'/profile/product-buyed');
                }
                },
                ),
              ),
            ),
          );
      }
    return listItems;
  }

  Future<void> _logoutUser() async {
    String? token = await widget.secureStorageService.getJWT();
    
    if(logoutService.deleteUserData(widget.secureStorageService, token!) == true){
      print("Ho invalidato il token");
    }
  }



}