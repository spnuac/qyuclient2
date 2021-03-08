import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qyuclient/classes/Api.dart' as api;
import 'package:cached_network_image/cached_network_image.dart';
import 'Auth_phone.dart';
import 'Policy_Page.dart';
import 'Auth_email.dart';
import '../classes/Tools.dart' as tools;
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  double opacityimage=0;
  double toppos=100;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    Timer(Duration(microseconds:300),(){opacityimage=1;toppos=0;setState(() {});});
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset:true,
        body:
        Stack(
          fit: StackFit.expand,
          children: [

            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/login.png'),
                    fit: BoxFit.cover
                  ),
              ),
            ),

            SingleChildScrollView(

              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(top:toppos),
                curve: Curves.easeIn,
                child: Container(
                  padding: EdgeInsets.only(top:10,left:40,right:40,bottom:50),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: opacityimage,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center ,
                      children: [


                        Padding(padding:EdgeInsets.all(40)),
                        AnimatedOpacity(duration: Duration(seconds: 2),opacity: opacityimage, child: SizedBox(height: 150,width:150, child: Image(fit: BoxFit.fill, image:CachedNetworkImageProvider(api.getLogo())))),
                        Padding(padding:EdgeInsets.all(30)),
                        Text('Please select login method',textAlign: TextAlign.center,style: TextStyle( color: Colors.white,fontWeight:FontWeight.w500,fontSize: 18)),
                        Padding(padding:EdgeInsets.all(20)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              boxShadow: [BoxShadow(color: Colors.black26.withOpacity(.15),spreadRadius: 4,blurRadius: 0)]
                          ),
                          child: RaisedButton(
                            splashColor:  Colors.purple,
                            color: Colors.black,
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => Auth_phone()));
                            },
                            padding: EdgeInsets.only(left:40,top:15,bottom:15,right:40),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center ,
                              children: [
                                Icon(Icons.phone),
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Text(" With Phone Number",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding:EdgeInsets.all(10)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              boxShadow: [BoxShadow(color: Colors.black26.withOpacity(.15),spreadRadius: 4,blurRadius: 0)]
                          ),
                          child: RaisedButton(
                            splashColor:  Colors.purple,
                            color: Colors.black,
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => Auth_email()));
                            },
                            padding: EdgeInsets.only(left:40,top:15,bottom:15,right:40),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center ,
                              children: [
                                Icon(Icons.email_outlined,size: 18),
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Text(" With Email Address",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin:EdgeInsets.only(bottom:10),
                alignment: Alignment.bottomCenter,
                child:
                OutlineButton(
                    color: Colors.white,
                    borderSide: BorderSide.none,
                    onPressed: (){
                     // Navigator.push(context,MaterialPageRoute(builder: (context) => Policy_Page()));
                      tools.GotoPage(context,Policy_Page());
                    },
                    child:Text(
                        "TC & Privacy Policy.",
                        textAlign: TextAlign.center,
                        style:TextStyle(
                        fontSize: 10,
                        color: Colors.white
                        )
                    )
                )
            ),
            Container(
            margin:EdgeInsets.only(bottom:10),
            alignment: Alignment.bottomCenter,
            child:Text("© 2021.  All rights reserved.",textAlign: TextAlign.center,style:TextStyle(fontSize: 11,color: Colors.white))
            )
          ],
        )
    );
  }
}