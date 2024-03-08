import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/history_user_profile_.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/home_user_page.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/inventory_user_profile_.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/product_buyed_user_profile_.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/setting_user_profile_page.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page 
import 'package:filiera_token_front_end/components/organisms/sign_in_page/sign_in.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up_page/sign_up.dart';
import 'package:filiera_token_front_end/components/organisms/home_page/home_page.dart';

// Page User 


import 'package:get_it/get_it.dart';


void setupDependencies() {
  GetIt.I.registerSingleton<SecureStorageService>(SecureStorageService.instance);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp.router(
      routerConfig: _routerConsumer,
    );
  }
}

/**
 * Map Router 
 */
/*final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const MySignUpPage(title: "Filiera-Token-SignUp"),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const MySignInPage(title: "Filiera-Token-SignIn"),
    ),

    GoRoute(
    path: '/home-page-user',
    builder: (context, state) => const HomePageUser(),
    routes: [
      GoRoute(
        path: 'profile',
        builder: (context, state) => const UserProfilePage(),
        routes: [
            /// Sub Path of Profile of User
            GoRoute(
              path: 'history',
              builder: (context,state)=> const UserProfileHistoryPage()), 
            GoRoute(
              path: 'inventory',
              builder: (context,state) => const UserProfileInventoryProductPage()),                
            GoRoute(
              path: 'product-buyed',
              builder: ((context, state) => const UserProfileProductBuyed())),
        ]
      ),
    ],
  ),
  ],
);*/


/// Route Consumer 

// Assuming you have defined your page widgets:
// - MyHomePage
// - MySignUpPage
// - MySignInPage
// - HomePageUser
// - UserProfilePage
// - UserProfileHistoryPage
// - UserProfileInventoryProductPage
// - UserProfileProductBuyed

final GoRouter _routerConsumer = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const MySignUpPage(title: "Filiera-Token-SignUp"),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const MySignInPage(title: "Filiera-Token-SignIn"),
    ),

    // Dynamically pass user data to nested routes
    GoRoute(
      path: '/home-page-user/:userType/:id_user',
      builder: (context, state) {
        final userType = state.pathParameters['userType']!;
        final idUser = state.pathParameters['id_user']!;
        return HomePageUser(
          userType: userType,
          idUser: idUser,

        );
      },
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state)  {
            final userType = state.pathParameters['userType']!;
            final idUser = state.pathParameters['id_user']!;
            return UserProfilePage(
              userType: userType,
              idUser: idUser,
            );
          },
          routes: [
            GoRoute(
              path: 'history',
              builder: (context, state) {
                final userType = state.pathParameters['userType']!;
                final idUser = state.pathParameters['id_user']!;

                return UserProfileHistoryPage(
                  userType: userType,
                  idUser: idUser,
                );
              },
            ),
            GoRoute(
              path: 'inventory',
              builder: (context, state) {
                final userType = state.pathParameters['userType']!;
                final idUser = state.pathParameters['id_user']!;

                return UserProfileInventoryProductPage(
                  userType: userType,
                  idUser: idUser,
                );
              },
            ),
            GoRoute(
              path: 'product-buyed',
              builder: (context, state) {
                final userType = state.pathParameters['userType']!;
                final idUser = state.pathParameters['id_user']!;

                return UserProfileProductBuyed(
                  userType: userType,
                  idUser: idUser,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);




