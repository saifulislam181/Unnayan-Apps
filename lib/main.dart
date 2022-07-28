import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/AlWids.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/Services/notification_service.dart';

import 'Components/badge_model.dart';
import 'LoginPage/view/loginpage_view.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> mainIni() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().whenComplete(() {
    print("completed");
  });
  await NotificationService().iniNotification();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

void main() {
  mainIni();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginpageModel>(
          create: (context) => LoginpageModel(),
        ),
        ChangeNotifierProvider<BadgeCounter>(
          create: (context) => BadgeCounter(),
        ),
        ChangeNotifierProvider<WidContainer>(
          create: (context) => WidContainer(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unnayan App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChangeNotifierProvider<WidContainer>(
        //     create: (_)=>WidContainer(),
        //     child: const HomePageSTL()),
        //
        home: LoginPageSTL(),
        // home: Scaffold(body: LoginPageSTL()),
      ),
    );
  }
}
