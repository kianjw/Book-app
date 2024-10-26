import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/firebase_options.dart';

// Your specific application components
import 'package:flutter_ebook_app/src/app.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

// State management and routing
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// Database and storage related imports
import 'package:sembast/sembast.dart';

// Your application pages/screens
import 'package:flutter_ebook_app/UserSelectionPage.dart';
import 'package:flutter_ebook_app/CreateUserPage.dart';
import 'package:flutter_ebook_app/LoginPage.dart'; // Make sure to import UserListPage

// Firebase initialization
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Proceed with app initialization after Firebase is initialized
  await LocalStorage(); // Assuming this is a custom initialization method
  await DatabaseConfig.init(StoreRef<dynamic, dynamic>.main());
  if (kIsWeb) usePathUrlStrategy();

  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        initialRoute: '/userSelection',
        routes: {
          '/': (context) => MyApp(),
          '/userSelection': (context) => UserSelectionPage(),
          '/createUser': (context) => CreateUserPage(),
          
          '/userList': (context) => LoginPage(), // Ensure UserListPage is registered
        },
      ),
    ),
  );
}
