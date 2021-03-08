import 'package:firebase_auth/firebase_auth.dart';
import 'classes/authentication_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splashscreen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'pages/Auth_phone.dart';
import 'pages/Auth_email.dart';
import 'classes/FirebaseMessaging.dart';
import 'classes/Api.dart' as  api;
import 'package:no_context_navigation/no_context_navigation.dart';
import 'pages/genreform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  api.initPreferences();
  await Firebase.initializeApp();
  configFirebaseMessage();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/login.png"), context);
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
        )
      ],
      child:  OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Authentication',
          //home: splashscreen(),
          navigatorKey: NavigationService.navigationKey,

          initialRoute: '/',
          routes: {
            '/': (context) => splashscreen(),
            '/phonelogin': (context) => Auth_phone(),
            '/emaillogin': (context) => Auth_email(),
            '/completeprofile':(context) => genreform(null),
          },
        ),
      ),
    );
  }
}