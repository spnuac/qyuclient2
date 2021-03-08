import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/messages.dart' as messages;
import 'dart:convert' show utf8;

class item2 extends StatelessWidget {
  final data;
  bool showImage=false;
  bool disabledMode=false;
  Function onTap =(){};
  item2(this.data,{bool this.showImage=false,bool this.disabledMode=false,this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:disabledMode?null: (){onTap();},
      child: Container(
        margin: EdgeInsets.only(bottom:15),
          padding: EdgeInsets.only(right:10,left:10,top:15,bottom:15),
          clipBehavior:Clip.antiAlias,
          decoration:  BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                colors: [
                  disabledMode?Color(0xff828282): Color.fromRGBO(117, 125, 249, 1.0),
                  disabledMode?Color(0xff9c9c9c):Color.fromRGBO(214, 145, 236, 1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            borderRadius: BorderRadius.all(Radius.circular(6)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4),blurRadius: 4)]
          ),
          child:Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex:1,child: Column(
                    children: [
                      Text(data['dateparas']['month_small'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(.6))),
                      Text(data['dateparas']['day'],style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900,color: Colors.white),),
                      Text(data['dateparas']['year'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(.6))),
                    ],
                  )),
                  Expanded(flex:3,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(data['dateparas']['weekday_small']+" "+data['dateparas']['startattime']+" - "+data['dateparas']['endattime'],style: TextStyle(fontSize: 15,color: Colors.white.withOpacity(.7),fontWeight: FontWeight.w400)),
                      Padding(
                        padding: const EdgeInsets.only(top:4.0,bottom:4),
                        child: Text(data['title'],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white.withOpacity(.8))),
                      ),
                      Text(data['genres_names'],style: TextStyle(fontSize: 12,color: Colors.white)),

                    ],
                  )),
                  Expanded(
                      child:
                      showImage==true?SizedBox( width: 60,height: 60,child: Image.network(data['poster'],fit: BoxFit.cover,)):
                      InkWell(
                        onTap: (){List location= data['venuedata']['location'].toString().split(","); if(location.length==2) openMap(location[0],location[1]);},
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(left:5,right:5,top:8,bottom:8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    color: Colors.white,
                                ),
                                child: Icon(Icons.location_pin,size: 30,color: Colors.black,)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:5.0),
                              child: Text(data['city'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                            )
                          ],
                        ),
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

  static Future<void> openMap( latitude,  longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      messages.toast("can not laod map");
    }
  }
}

