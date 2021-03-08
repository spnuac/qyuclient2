import 'package:flutter/material.dart';
import '../home_page.dart' as home;
import '../../classes/Api.dart' as api;
import '../../classes/messages.dart' as message;
import 'dart:async';

int selected=0;
var selectrow = null;
class upcoming extends StatefulWidget {
  @override
  _upcomingState createState() => _upcomingState();
}

class _upcomingState extends State<upcoming> {
  Timer timng;
  @override
  void initState() {
    super.initState();
    refresh();
  }
  void refresh(){
    timng = Timer(Duration(seconds: 5),(){
      refresh();
      if(mounted)
        setState(() {});
    });
  }
  @override
  void dispose() {
    super.dispose();
    timng.cancel();
  }
  Future<dynamic> getdata() async {
    if(selectrow!=null)
      return await api.getEventData({"uid":home.DataTOPage['uid'],"eid":home.DataTOPage['old_upcomnig_event'][selected]['eid']});
    return false;
  }
  @override
  Widget build(BuildContext context) {
    selectrow = (home.DataTOPage['old_upcomnig_event'] as List).length>0? home.DataTOPage['old_upcomnig_event'][selected]:false;

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child:
      selectrow==false?

      Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
              Image.asset("assets/nodata.png",width: 120),
              Padding(padding: EdgeInsets.all(10),),
              Text("Sorry ! no event found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Padding(padding: EdgeInsets.all(3),),
              Text("You may not have set any event yet",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black.withOpacity(.5)),)
            ],
          )
      )

          :

      Column(
        children: [
          Container(
            padding: EdgeInsets.only(top:10,left:20,right:20,bottom:10),
            decoration: BoxDecoration(
                color: Colors.black,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(117, 125, 249, 1.0),
                    Color.fromRGBO(214, 145, 236, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              border: Border.all(width: 1,color:Color(0xffa394af)),
              boxShadow:[BoxShadow(color: Colors.deepPurple.withOpacity(.4),blurRadius: 10,spreadRadius: 1)]
            ),
            child: InkWell(
              onTap: (){openupcomingsheet(context);},
              child: Row(
                children: [
                  Expanded(child: Text(selectrow['title'],style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.w900),)),
                  Align(
                    child: Icon(Icons.arrow_drop_down,size: 30,color: Colors.white,),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom:10,right:5,left:5),
                child: Column(
                  children: [
                    if(selectrow['type']!='upcoming')
                      Container(
                          alignment: Alignment.center,
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center ,
                            children: [
                              Image.asset("assets/nodata.png",width: 120),
                              Padding(padding: EdgeInsets.all(10),),
                              Text("Sorry ! Event is done!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Padding(padding: EdgeInsets.all(3),),
                              Text("Please Select other upcoming event.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black.withOpacity(.5)),)
                            ],
                          )
                      ),
                    if(api.votes.length>0 && selectrow['type']=='upcoming')
                      Container(
                        width: double.infinity,
                          padding: EdgeInsets.only(top:30),
                          child:Column(
                            children: [
                              Text("How is the Event?",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black.withOpacity(.6),fontSize: 20),),
                              Container(
                                padding: EdgeInsets.only(top:20),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  // crossAxisCount is the number of columns
                                  crossAxisCount: api.votes.length>5?5:api.votes.length,
                                  mainAxisSpacing: 7,
                                  crossAxisSpacing: 7,
                                  // This creates two columns with two items in each column
                                  children: List.generate(api.votes.length, (indexing) {
                                    var item = api.votes[indexing];
                                    return Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(selectrow['vote'].toString()==item['vn_id'].toString()?1:.2),
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                      ),
                                      child: InkWell(
                                        focusColor: selectrow['vote'].toString()==item['vn_id'].toString()?Colors.transparent: Colors.deepPurple,
                                        splashColor: selectrow['vote'].toString()==item['vn_id'].toString()?Colors.transparent: Colors.deepPurple,
                                        onTap: selectrow['vote'].toString()!="0"?null: (){
                                          api.getvoteEvent({"uid":home.DataTOPage['uid'],"eid":selectrow['eid'],"vote":item['vn_id'].toString()}).then((value){
                                            if(value['result']==true){
                                              selectrow = value['data'];
                                              home.DataTOPage['old_upcomnig_event'][selected] = selectrow;
                                              message.toast("Notification",subtitle: value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,size:35,color: Colors.lightGreen,));
                                              setState(() {});
                                            }
                                            else
                                              message.toast("Error !",autoclose: true,duration: 4,subtitle: value['msg'],img: Icon(Icons.dangerous,size: 25,color: Colors.redAccent));
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 40,height:40,
                                              child: Image.network(item['vn_icon'],fit: BoxFit.fill,),
                                            ),

                                            Align(alignment:Alignment.bottomCenter, child: Text(item['vn_name'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,))

                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Divider(height: 40,)
                            ],
                          )
                      ),
                      if(selectrow['type']=='upcoming' && selectrow['currentMusic']!=null)
                      Container(
                        child:Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: 80,height:80,
                                    child: [null,''].contains(selectrow['currentMusic']['img'])?Image.asset("assets/logo.png",fit:BoxFit.cover):Image.network(selectrow['currentMusic']['img'],fit:BoxFit.cover),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right:30),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Current Played Music :",style:TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18)),
                                    Padding(padding: EdgeInsets.all(6),),
                                    Row(
                                      children: [
                                        Container(child: Text("Title :",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.4),fontWeight: FontWeight.bold,fontSize: 13),)),
                                        Text(selectrow['currentMusic']['title'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.7),fontWeight: FontWeight.bold,fontSize: 13),),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(3),),
                                    Row(
                                      children: [
                                        Text("Singer :",style: TextStyle(color: Colors.black.withOpacity(.4),fontWeight: FontWeight.bold,fontSize: 13),),
                                        Text(selectrow['currentMusic']['singer'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.7),fontWeight: FontWeight.bold,fontSize: 13),),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(height: 30,)
                          ],
                        )
                      ),
                    if(selectrow['type']=='upcoming' && (selectrow['votetrack'] as List).length==2)
                      Container(
                        child: Column(
                          children:[
                            Padding(
                              padding: const EdgeInsets.only(bottom:20.0),
                              child: Text("Vote to play next song?",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black.withOpacity(.6),fontSize: 20),),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex:2,
                                  child: InkWell(
                                    onTap:selectrow['votedtotrack']!="0"?null: (){voteTrack(selectrow['votetrack'][0]['id']);},
                                    splashColor: Colors.deepPurple,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:  Colors.white,
                                          boxShadow:selectrow['votedtotrack'].toString()!=selectrow['votetrack'][0]['id'].toString()?null: [BoxShadow(color: Colors.black.withOpacity(.5),blurRadius: 10,spreadRadius: 0)]


                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height:100,width:double.infinity,
                                            child: [null,''].contains(selectrow['votetrack'][0]['img'])?Image.asset("assets/logo.png",fit:BoxFit.cover):Image.network(selectrow['votetrack'][0]['img'],fit:BoxFit.cover),
                                          ),
                                          Padding(padding: EdgeInsets.all(6),),
                                          Text(selectrow['votetrack'][0]['title'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(1),fontWeight: FontWeight.bold,fontSize: 16),),
                                          Padding(padding: EdgeInsets.all(3),),
                                          Text(selectrow['votetrack'][0]['singer'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.6),fontWeight: FontWeight.bold,fontSize: 13),),
                                          Padding(padding: EdgeInsets.all(3),),
                                          Text(selectrow['votetrack'][0]['genre'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.6),fontWeight: FontWeight.bold,fontSize: 13),),
                                          Padding(padding: EdgeInsets.all(5),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex:1,child: Column(
                                  children: [
                                    Text("V.S",style: TextStyle(color:Colors.deepPurple,fontSize: 25,fontWeight: FontWeight.w900),),
                                  ],
                                )),
                                Expanded(
                                  flex:2,
                                  child: InkWell(
                                    onTap: selectrow['votedtotrack']!="0"?null:(){voteTrack(selectrow['votetrack'][1]['id']);},
                                    splashColor: Colors.deepPurple,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: selectrow['votedtotrack'].toString()!=selectrow['votetrack'][1]['id'].toString()?null:[BoxShadow(color: Colors.black,blurRadius: 5,spreadRadius: 0)]


                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height:100,width:double.infinity,
                                            child: [null,''].contains(selectrow['votetrack'][1]['img'])?Image.asset("assets/logo.png",fit:BoxFit.cover):Image.network(selectrow['votetrack'][1]['img'],fit:BoxFit.cover),
                                          ),
                                          Padding(padding: EdgeInsets.all(6),),
                                          Text(selectrow['votetrack'][1]['title'] ,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(1),fontWeight: FontWeight.bold,fontSize: 16),),
                                          Padding(padding: EdgeInsets.all(3),),
                                          Text(selectrow['votetrack'][1]['singer'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.6),fontWeight: FontWeight.bold,fontSize: 13),),
                                          Padding(padding: EdgeInsets.all(3),),
                                          Text(selectrow['votetrack'][1]['genre'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(.6),fontWeight: FontWeight.bold,fontSize: 13),),
                                          Padding(padding: EdgeInsets.all(5),),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  void voteTrack(etid){
    api.getvoteTrack({"uid":home.DataTOPage['uid'],"eid":selectrow['eid'],"etid":etid}).then((value){
      if(value['result']==true){
        selectrow = value['data'];
        home.DataTOPage['old_upcomnig_event'][selected] = selectrow;
        message.toast("Notification",subtitle: value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,size:35,color: Colors.lightGreen,));
        setState(() {});
      }
      else
        message.toast("Error !",autoclose: true,duration: 4,subtitle: value['msg'],img: Icon(Icons.dangerous,size: 25,color: Colors.redAccent));
    });
  }
  void openupcomingsheet(pcontext){
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
                              Expanded(child: Text("Upcoming events",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),)),
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
                        if( home.DataTOPage['old_upcomnig_event'].length==0)
                          Container(
                            padding:EdgeInsets.only(top:20,bottom: 15),
                            child:Text("Not found any Upcoming events",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.1)),),
                          ),
                        if(home.DataTOPage['old_upcomnig_event'].length>0)
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            controller: scrollController,
                            itemCount: home.DataTOPage['old_upcomnig_event'].length,
                            itemBuilder: (context, index) {
                              final item = home.DataTOPage['old_upcomnig_event'][index];
                              return InkWell(
                                onTap: (){
                                    Navigator.pop(pcontext);
                                    message.waiting(pcontext);
                                    selected = index;
                                    getdata().then((value){
                                      message.closeWaiting(pcontext);
                                      if(value['result']==true){
                                        selectrow = value['data'];
                                        home.DataTOPage['old_upcomnig_event'][selected] = selectrow;
                                        setState(() {});
                                      }
                                    });
                                  },
                                child: Container(
                                    padding: EdgeInsets.only(bottom:5,top:5),
                                    margin:  EdgeInsets.only(bottom:5,top:5),
                                    decoration: BoxDecoration(
                                        color:item['type']=='upcoming'?Colors.purple.withOpacity(.3):Colors.transparent,
                                        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(.1),width: 1))
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['title'],style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 16,fontWeight: FontWeight.bold),),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Text(item['startat']+" "+item['dateparas']['startattime']+"-"+item['dateparas']['endattime'],style: TextStyle(color: Colors.black.withOpacity(.4),fontSize: 14),),
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
}
