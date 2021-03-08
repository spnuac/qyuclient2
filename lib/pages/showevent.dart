import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/messages.dart' as messages;
import 'home_page.dart' as home;
import '../classes/Api.dart' as api;


class showevent extends StatefulWidget {

  final data;
  final String preStep ;
  showevent(this.data,this.preStep);

  @override
  _showeventState createState() => _showeventState(this.data,this.preStep);
}

class _showeventState extends State<showevent> {
  final data;
  final String preStep ;
  final TextEditingController number = TextEditingController();
  int numticket = 1;
  double price = 0;
  _showeventState(this.data,this.preStep);
  @override
  Widget build(BuildContext context) {
    number.text= numticket.toString();
    print(data['price']);
    price = data['price']==0?0.0:numticket * double.parse( data['price'].toString(),(s){return 0;});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Add Event",style: TextStyle(color: Colors.black.withOpacity(.6)),),
        actions: [
          FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: Icon(Icons.close,size: 25,color: Colors.black,),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
            children:[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(4)),
                          //boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4),blurRadius: 5)]
                          border: Border(bottom: BorderSide(width: 1,color: Color(
                              0xFFEAEAEA)))
                        ),
                        width: double.infinity,
                        height: 200,
                        child: Image.network(data['poster'],fit: BoxFit.cover,),
                      ),
                      Container(
                        padding:EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:22.0),
                                    child: Column(
                                      children: [
                                        Text(data['dateparas']['month_small'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.6))),
                                        Text(data['dateparas']['day'],style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
                                        Text(data['dateparas']['year'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.6))),

                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['dateparas']['weekday']+" "+data['dateparas']['startattime']+" - "+data['dateparas']['endattime'],style:TextStyle(color:Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 16)),
                                      Padding(padding: EdgeInsets.only(top:5)),
                                      Text(data['title'],style:TextStyle(color:Colors.black,fontWeight: FontWeight.w900,fontSize: 26)),
                                      Padding(padding: EdgeInsets.only(top:5)),

                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(top:30),
                                        child: Text(data['desc'], textAlign: TextAlign.justify,style: TextStyle( fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.6))),
                                      ),
                                    ],

                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 40,),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:22.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:45,height:45,
                                          decoration: BoxDecoration(
                                            color:Colors.black.withOpacity(.7),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.wc,size: 20,color:Colors.white,),
                                        )
                                        ,
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                      children: [

                                        Row(
                                          children: [
                                            Text("Age : ",style:TextStyle(color:Colors.black.withOpacity(.4),fontWeight: FontWeight.bold,fontSize: 14)),
                                            Spacer(),//Padding(padding: EdgeInsets.only(left:10)),
                                            Text(data['age'],style:TextStyle(color:Colors.black.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 14)),


                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(top:5)),
                                        Row(
                                          children: [
                                            Text("Dresscode : ",style:TextStyle(color:Colors.black.withOpacity(.4),fontWeight: FontWeight.bold,fontSize: 14)),
                                            Spacer(),//Padding(padding: EdgeInsets.only(left:10)),
                                            Text(data['dresscode'],style:TextStyle(color:Colors.black.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 14)),
                                          ],
                                        ),

                                        Padding(padding: EdgeInsets.only(top:5)),
                                        Row(
                                          children: [
                                            Text("Genre : ",style:TextStyle(color:Colors.black.withOpacity(.4),fontWeight: FontWeight.bold,fontSize: 14)),
                                            Spacer(),//Padding(padding: EdgeInsets.only(left:10)),
                                            Text(data['genres_names'],style:TextStyle(color:Colors.black.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 14)),

                                          ],
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),

                            Divider(height: 40,),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:22.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:45,height:45,
                                          decoration: BoxDecoration(
                                            color:Colors.black.withOpacity(.7),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.queue_music_outlined,size: 20,color:Colors.white,),
                                          ///child: Text(data['djs'].length.toString(),style:TextStyle(fontWeight: FontWeight.w900, color:Colors.white,fontSize: 22)),
                                        )
                                        ,
                                        Padding(padding: EdgeInsets.only(top:5)),
                                        Text("DJ(s)",style:TextStyle(color:Colors.black,fontSize: 12))
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    // crossAxisCount is the number of columns
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0,
                                    // This creates two columns with two items in each column
                                    children: List.generate(data['djs'].length, (indexing) {
                                      return Column(
                                        children: [
                                          Container(
                                            width:50,
                                            height:50,
                                            clipBehavior: Clip.antiAlias,
                                            margin: EdgeInsets.only(bottom:15),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(width: 2,color: Colors.deepPurple),
                                              borderRadius: BorderRadius.all(Radius.circular(50))
                                            ),
                                            child: Image.network(data['djs'][indexing]['img'],fit: BoxFit.cover,),

                                          ),
                                          Text(data['djs'][indexing]['name'],overflow: TextOverflow.ellipsis,style:TextStyle(color:Colors.black,fontSize: 12,fontWeight:FontWeight.bold))
                                        ],
                                      );
                                    }),
                                  ),
                                )
                              ],
                            ),

                            Divider(height: 40,),
                            Container(
                              child: InkWell(
                                onTap: (){
                                  List location= data['venuedata']['location'].toString().split(","); if(location.length==2) openMap(location[0],location[1]);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right:22.0),
                                        child: Container(
                                          width:45,
                                          padding: EdgeInsets.only(left:5,right:5,top:10,bottom:10),
                                          decoration: BoxDecoration(
                                              color:Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(117, 125, 249, 1.0),
                                                  Color.fromRGBO(214, 145, 236, 1),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.location_pin,color: Colors.white,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_pin,size: 15,color:Colors.black.withOpacity(.5)),
                                          Padding(padding: EdgeInsets.only(left:3)),
                                          Text(data['venuedata']['title']+" ,"+data['city'],style:TextStyle(color:Colors.black.withOpacity(.5),fontWeight: FontWeight.w400,fontSize: 16))

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
              if(data['buy_by_user']['paid']==1)
              Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                color: Color(0xffb3b3b3),
                child: Text("You purcashe "+data['buy_by_user']['numticket'].toString()+" ticket(s)",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
              ),
              if(data['buy_by_user']['paid']==0 && data['canbuy']=="1")
              Container(
                height: 110,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffc2c2c2)),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: (){setState(() {if(numticket>1) numticket--;  });},
                                child:Icon(Icons.remove_circle_outline,size: 30,)
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: number,
                                readOnly: true,
                                autofocus: false,
                                style: TextStyle(fontWeight: FontWeight.w900),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: (){setState(() {if(numticket<10)numticket++;  });},
                                child:Icon(Icons.add_circle_outline,size: 30,)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: (){ if(data['price']==0)checkout(context ); else opencardsheet(context);},
                        color: Colors.green,
                        child: Text("Purcashe ( "+(price==0?"Free":data['symbol']+price.toString())+" )",style: TextStyle(color:Colors.white),),
                      ),
                    )
                  ],
                ),
              )
            ]
        ),
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
  void opencardsheet(pcontext){
    showModalBottomSheet<void>(
      context: pcontext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 1,
            minChildSize: 0.25,
            builder:
                (BuildContext context, ScrollController scrollController) {
              return
                Container(
                  margin: EdgeInsets.only(left:10,right:10,bottom:0),
                  padding: EdgeInsets.only(left:10,right:10,top:10,bottom:10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10)),
                      boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 10,blurRadius: 8)]
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(child: Text("Payment Cards",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),)),
                              SizedBox(
                                width: 55,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pop(pcontext);
                                  },
                                  child: Icon(Icons.close,color: Colors.black,size: 22,),
                                ),
                              )

                            ],
                          ),
                        ),
                        Divider(),
                        if( home.DataTOPage['cards'].length==0)
                          Container(
                            padding:EdgeInsets.only(top:20,bottom: 15),
                            child:Text("Not found any card\r\n Please add payment card .",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.1)),),
                          ),
                        if(home.DataTOPage['cards'].length>0)
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            controller: scrollController,
                            itemCount: home.DataTOPage['cards'].length,
                            itemBuilder: (context, index) {
                              final item = home.DataTOPage['cards'][index];
                              return InkWell(
                                onTap: (){checkout(pcontext,cardid:home.DataTOPage['cards'][index]['cc_id'] );},
                                child: Container(
                                    padding: EdgeInsets.only(bottom:5,top:5),
                                    margin:  EdgeInsets.only(bottom:5,top:5),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(.1),width: 1))
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['masked'],style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 16,fontWeight: FontWeight.bold),),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Text(item['card_name'],style: TextStyle(color: Colors.black.withOpacity(.4),fontSize: 14),),
                                        )
                                      ],
                                    )
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
            });
      },
    );
  }
  
  void checkout(pcontext,{cardid:null}){
    messages.waiting(pcontext,title: "Proccess your request");
    api.Checkout({"uid":home.DataTOPage['uid'],"nums":numticket,"eid":data['eid'],"cardid":cardid}).then((value){
      messages.closeWaiting(pcontext);
      if(value['result']==true){
        if(value['data']!=null)
          home.DataTOPage= value['data'];
        if(cardid!=null)
          Navigator.pop(pcontext);
        Navigator.pop(pcontext,true);
          messages.toast(data['title'],subtitle: value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,size:35,color: Colors.lightGreen,));

      }
      else
        messages.toast("Error !",autoclose: true,duration: 4,subtitle: value['msg'],img: Icon(Icons.dangerous,size: 25,color: Colors.redAccent));
    });
  }
}
