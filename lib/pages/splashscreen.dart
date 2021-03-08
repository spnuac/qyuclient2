import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qyuclient/pages/Auth.dart';
import '../classes/Api.dart' as api;
import '../classes/messages.dart' as messages;
import '../classes/authentication_provider.dart';
import 'home_page.dart';
import 'genreform.dart';
import '../classes/Tools.dart' as tools;
import 'dart:io' as Io;

class splashscreen extends StatefulWidget {
  @override
  _splashscreenState createState() => _splashscreenState();


}
enum widget {waiting,splash,nosplash,genreform,homepage,venueform}

class _splashscreenState extends State<splashscreen> {
  bool loadSeting = false;
  bool internetError=false;
  widget page = widget.waiting;
  String Title = 'Welcome';
  String Desc = 'Created By Grub24';
  int timeout = 3;
  String Logo='';
  dynamic DataTOPage= null;

  void getSetting(){
    api.setting().then((value) async{
      if (value != false) {
        internetError = false;
        page = widget.splash;
        Title = value['data']['splashtitle'];
        Desc = value['data']['splashdesc'];
        Logo = await tools.getImageNetwork(value['data']['splashlogo']);
        timeout = int.parse( value['data']['splashtimeout']);
      }
      else {
        internetError = true;
        Desc = "NO Internet !";
        Title = 'Ooooops :(';
      }
      setState(()  {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(page==widget.homepage){
      return HomePage(DataTOPage);
    }
    if(page==widget.genreform || page==widget.venueform){
      return genreform(DataTOPage);
    }
    if(page == widget.nosplash){
      if (firebaseUser != null && (firebaseUser.emailVerified || ![null,'',false].contains(firebaseUser.phoneNumber))){

        final data = {
          "email" : firebaseUser.email,
          "emailVerified" : firebaseUser.emailVerified,
          "phoneNumber" : firebaseUser.phoneNumber,
          "uid" : firebaseUser.uid,
          "fcmid" : api.FCM_id,
          'timezone':api.UserIpInfo!=false? api.UserIpInfo['timezone']:api.default_timezone,
        };
        api.proccessUser(data).then((status){
          if(status['next_step']=='blocked') {
            messages.show(context, title: 'Error',type: messages.msgtype.error,content: status['msg']);
            context.read<AuthenticationProvider>().signOut().then((v) {
              setState(() {});
            });
          }
          else if(status['next_step']=='retry_register'){
            messages.toast(status['msg'],duration: 5,autoclose: true,subtitle: "Tray again",img:Icon(Icons.close,size: 30,color:Colors.red) );
              context.read<AuthenticationProvider>().signOut().then((v) {
                setState(() {});
              });
            }
          else if(status['next_step']=='home'){
            page = widget.homepage;
            DataTOPage = status['data'];
            setState(() {});
          }
          else if(status['next_step']!='home'){
            page = widget.genreform ;
            DataTOPage = {"data":status['data'],"step":status['next_step']};
            setState(() {});
          }
        });
        return defaultAuthView();
      }
      else
        return Auth();
    }
    else if(page == widget.splash ||  page==widget.waiting) {
      if(page ==widget.waiting) {
        getSetting();
      }
      else if(page ==widget.splash){
        Timer(Duration(seconds: timeout),(){
          setState(() {
           page = widget.nosplash;
          });
        });
      }
      return defaultAuthView();
    }
  }
  Widget defaultAuthView(){
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(117, 125, 249, 1.0),
                    Color.fromRGBO(214, 145, 236, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
            ),
          ),

          Container(
            alignment: Alignment.center,
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,height: 100,
                  child: page == internetError? Icon(Icons.phonelink_erase_outlined,size: 100,color: Colors.white,):(Image.asset("assets/logo_whte.png",fit: BoxFit.cover)),
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                Text(Title,
                    style: TextStyle(color: Colors.white, fontSize: 28,fontWeight: FontWeight.w900)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(Desc,
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Padding(padding: EdgeInsets.all(20.0)),
                Visibility(
                  visible: internetError,
                  child: MaterialButton(
                      color: Colors.black,
                      onPressed: () {getSetting();},
                      child:Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50.0,20,50,20),
                            child: Text('Try Again',style: TextStyle(color: Colors.white)),
                          )
                      )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}
