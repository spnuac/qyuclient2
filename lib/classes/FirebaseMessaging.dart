import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'Api.dart' as api;
final NavigationService navService = NavigationService();

void configFirebaseMessage() {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      proccessMessage(message);
    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
//_navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      proccessMessage(message);
// _navigateToItemDetail(message);
    },
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    api.FCM_id = token;
  });
  _firebaseMessaging.subscribeToTopic("client");
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("MESSSAGEEEEEEEEEEEEEEEEEEEEEEEEE");
  print(message);
  if (message.containsKey('data')) {
// Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
// Handle notification message
    final dynamic notification = message['notification'];
  }

// Or do other work.
}

void proccessMessage(Map<String, dynamic> message){
  print("proccessMessage");
  print(message);
  if (message.containsKey('data') && (message['data'] as Map).containsKey("action")) {
    navService.pushNamed('/'+message['data']['action'], args:message['data'] );
  } else {
    bool autoclose  = (message['data'] as Map).containsKey("autoclose") && message['data']['autoclose']=="1";
    String img = api.getLogo();
    if((message['data'] as Map).containsKey("image") && message['data']['image'].toString().length>0) {
      CachedNetworkImage(imageUrl: message['data']['image'].toString());
      img = message['data']['image'].toString();
    }
    showSimpleNotification(
      Padding(padding: EdgeInsets.only(bottom:8),child: Text(message['notification']['title'],style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
      background: Colors.black,
      contentPadding: EdgeInsets.only(top:10,bottom:10,left:15,right:10),
      leading: SizedBox( width: 60, child:Image.network(img)),
      slideDismiss: true,
      foreground: Colors.amberAccent,
      position: NotificationPosition.bottom,
      autoDismiss: autoclose,
      duration: Duration(seconds: 60),
      subtitle: Text(message['notification']['body'],style: TextStyle(color:Colors.white60,fontSize: 13)),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.yellow,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Icon(Icons.close,color: Colors.white70,));
      }),
    );
  }
}