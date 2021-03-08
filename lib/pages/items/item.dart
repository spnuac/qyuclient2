import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/messages.dart' as messages;

class item extends StatelessWidget {
  final data;
  final showPrice;
  item(this.data,{bool this.showPrice=false});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
     // padding: EdgeInsets.only(right:5,left:5),
      child:Column(
        children: [
          Container(
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.black,
                  //borderRadius: BorderRadius.only()
              ),
              child: Stack(
                fit:StackFit.expand,
                  children:[
                    Image.network(data['poster'],fit: BoxFit.cover,width: double.infinity,),
                    if(data['price']>0 && showPrice)
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: EdgeInsets.only(right:8,left:8,top:5,bottom:5),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.7),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [BoxShadow(color: Colors.deepPurple,spreadRadius: 0,blurRadius: 3)]

                        ),
                        child: Text(data['priceFormat'],style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]
              )
          ),
          Container(
            padding: EdgeInsets.only(top:10,bottom:10,left:5,right:10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex:1,child: Column(
                  children: [
                    Text(data['dateparas']['month_small'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.6))),
                    Text(data['dateparas']['day'],style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                    Text(data['dateparas']['year'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.6))),
                  ],
                )),
                Expanded(flex:3,child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(data['dateparas']['weekday_small']+" "+data['dateparas']['startattime']+" - "+data['dateparas']['endattime'],style: TextStyle(fontSize: 15,color: Colors.deepPurple,fontWeight: FontWeight.w400)),
                    Padding(
                      padding: const EdgeInsets.only(top:4.0,bottom:4),
                      child: Text(data['title'],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.8))),
                    ),
                    Text(data['genres_names'],style: TextStyle(fontSize: 12)),

                  ],
                )),
                  Expanded(
                      flex:1,
                      child: InkWell(
                        onTap: (){List location= data['venuedata']['location'].toString().split(","); if(location.length==2) openMap(location[0],location[1]);},
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(left:5,right:5,top:8,bottom:8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                child: Icon(Icons.location_pin,size: 30,color: Colors.white,)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:5.0),
                              child: Text(data['city'],style: TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      )
                  ),
              ],
            ),
          )
        ],
      )
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

