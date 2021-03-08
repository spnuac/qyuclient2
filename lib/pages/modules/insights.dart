import 'dart:async';
import 'package:flutter/material.dart';
import '../home_page.dart' as home;
import '../../classes/Api.dart' as api;
import '../../classes/messages.dart' as messages;
import '../chart/chartbar_audience.dart';
import '../chart/chartpie_audience.dart';
import 'package:just_audio/just_audio.dart';

enum tabs {audience,feedback,user,tracks}
enum statusmusic {stop,playing,played}
tabs tab =tabs.audience;
int playedIndex = -1;
final playering = AudioPlayer();
statusmusic statusplay = statusmusic.stop;

class insights extends StatefulWidget {
  @override
  _insightsState createState() => _insightsState();
}

class _insightsState extends State<insights> {
  int selected=0;
  var selectrow = null;
  var datareport = null;
  Timer timng;
  @override
  void initState() {
    super.initState();
    refresh();
    playering.playerStateStream.listen((state) {
      switch (state.processingState) {
      case ProcessingState.loading:{statusplay = statusmusic.playing;};break;
      case ProcessingState.buffering:{statusplay = statusmusic.playing;};break;
      case ProcessingState.ready:{statusplay = statusmusic.played;};break;
      case ProcessingState.completed:{statusplay = statusmusic.stop;playedIndex =-1;setState(() {});};break;
      }

    });
  }
  @override
  void dispose() {
    super.dispose();
    timng.cancel();
  }
  void refresh(){
    timng = Timer(Duration(seconds: 10),(){
      refresh();
      if(mounted)
        setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    selectrow = (home.DataTOPage['old_upcomnig_event'] as List).length>0? home.DataTOPage['old_upcomnig_event'][selected]:false;

    datareport = selectrow!=false?selectrow['report']:datareport;
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child:selectrow==false?noData():Column(
        children: [
          Container(
            height: 65,
            child: selectorevent(),
          ),
          Container(
            child:tabslist(),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
              ),
              child: Container(

                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: loadtabpage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget noData({title ="Sorry ! no found any event",subtitle="please change filter and try again..."}){
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Image.asset("assets/nodata.png",width: 120),
            Padding(padding: EdgeInsets.all(10),),
            Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Padding(padding: EdgeInsets.all(3),),
            Text(subtitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black.withOpacity(.5)),),
          ],
        )
    );
  }

  Widget selectorevent() {
    return
      Container(
        margin: EdgeInsets.only(left:15,right:15,top:15),
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
            //border: Border.all(width: 1,color:Color(0xffa394af)),
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
      );
  }
  Widget tabslist(){
    return Container(
      decoration: BoxDecoration(
      ),
      padding: EdgeInsets.only(top:20),
      child: Row(
        children: [
          itemtabs("Audience",Icons.music_video,tabid: tabs.audience),
          itemtabs("Feedback",Icons.feedback_outlined,tabid: tabs.feedback),
          itemtabs("Participant",Icons.wc,tabid: tabs.user),
          itemtabs("Tracks",Icons.queue_music_outlined,tabid: tabs.tracks)
        ],
      ),
    );
  }
  Widget itemtabs(title,icon,{tabs tabid=tabs.audience}){
    final selected = tab==tabid;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: !selected?null:Color(0xfff1f1f1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(selected?8:0),
              topRight: Radius.circular(selected?8:0)
            ),
            border:  Border.all(color: selected?Color(0xfff1f1f1):Colors.transparent,width: 2)
        ),
        padding: EdgeInsets.only(left:5,right:5,top:5,bottom:10),
        child: InkWell(
          splashColor: Colors.purple.withOpacity(.2),
          onTap: (){setState(() {tab = tabid;});},
          child: Column(
            children: [
              Icon(icon,size: 20),
              Padding(padding: EdgeInsets.only(top:6)),
              Text(title,overflow: TextOverflow.ellipsis,style:TextStyle(color: Colors.black.withOpacity(selected?1:.5),fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
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
                                  selected = index;
                                  selectrow = (home.DataTOPage['old_upcomnig_event'] as List).length>selected? home.DataTOPage['old_upcomnig_event'][selected]:selectrow;


                                  },
                                child: Container(
                                    padding: EdgeInsets.only(bottom:5,top:5,left:5,right:5),
                                    margin:  EdgeInsets.only(bottom:5,top:5),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color:item['type']=='upcoming'?Colors.purple.withOpacity(.3):Colors.transparent,
                                        border: Border.all( color: Colors.black.withOpacity(.1),width: 1),
                                        borderRadius:BorderRadius.all(Radius.circular(5))
                                    ),
                                    child:Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item['title'],style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 16,fontWeight: FontWeight.bold),),
                                              Padding(
                                                padding: const EdgeInsets.only(top:5.0),
                                                child: Text(item['startat']+" "+item['dateparas']['startattime']+"-"+item['dateparas']['endattime'],style: TextStyle(color: Colors.black.withOpacity(.4),fontSize: 14),),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width:60,
                                          child: Text(item['saletickets'].toString()+"\r\nTickets",textAlign: TextAlign.center,style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
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

  Widget loadtabpage() {
    switch(tab){
      case tabs.feedback : return feedback();break;
      case tabs.user : return user();break;
      case tabs.tracks : return tracks();break;
      default:
        return audience();
    }
  }

  Widget audience(){
    return Container(
      padding: const EdgeInsets.only(bottom:10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20,0,20,40),
            child: Text("The music taste of your audience",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
          ),
          Expanded(
              child:datareport==null || (datareport['genre'] as List).length==0?noData():new chartbar_audience(datareport['genre'])
          ),
        ],
      ),
    );
  }
  Widget feedback(){
    return Container(
      padding: const EdgeInsets.only(bottom:10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20,0,20,40),
            child: Text("Feedback from audience",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
          ),
          Expanded(
              child:datareport==null || (datareport['feedback'] as List).length==0?noData():new chartbar_audience(datareport['feedback'])
          ),
        ],
      ),
    );
  }
  Widget user(){
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20,0,20,10),
            height: 50,
            child: Text("Age & Gender of your audience",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
          ),
          Expanded(
            child: datareport==null || (datareport['gender'] as List).length==0?noData():new chartpie_audience(datareport['gender']),
          ),
          Expanded(
              child:datareport==null || (datareport['age'] as List).length==0?noData():new chartbar_audience(datareport['age'])
          )
        ],
      ),
    );
  }
  Widget tracks(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: datareport==null || (datareport['tracks'] as List).length==0?noData(): ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        //controller: scrollController,
        itemCount: datareport['tracks'].length,
        itemBuilder: (context, index) {
          var item = datareport['tracks'][index];
          bool played = item['selected']=='selected';
          var id =datareport['tracks'][index]['id'];
          bool isFavorite = home.DataTOPage['favorite_music'].toString().indexOf(","+id.toString()+",")>=0;

          return Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(bottom:5),
            decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                    colors: [
                      !played? Color.fromRGBO(255, 255, 255, 1.0):  Color.fromRGBO(117, 125, 249, 1.0),
                      !played? Color.fromRGBO(227, 227, 227, 1.0):Color.fromRGBO(214, 145, 236, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                 // borderRadius: BorderRadius.all(Radius.circular(8)),
                  //boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4),blurRadius: 4)]
              ),
            padding: EdgeInsets.fromLTRB(8,12,8,12),
            child: InkWell(
              splashColor: Colors.deepPurple,
              onTap: [null,''].contains(item['url'])?(){}:() async {
                try {

                  await playering.stop();
                  if(playedIndex==-1 || playedIndex!=id) {
                    try {
                      await playering.setUrl(item['url'].toString());
                      playering.play();
                      statusplay=statusmusic.playing;
                      playedIndex = id;
                    } on PlayerException catch (e) {
                      messages.toast("Error",subtitle:e.message,autoclose: true,duration: 3,img: Icon(Icons.dangerous,size: 40,color: Colors.red));
                    } on PlayerInterruptedException catch (e) {
                      messages.toast("Connection aborted",subtitle:e.message,autoclose: true,duration: 3,img: Icon(Icons.dangerous,size: 40,color: Colors.red));
                    } catch (e) {
                      messages.toast("Error",subtitle:e.message,autoclose: true,duration: 3,img: Icon(Icons.dangerous,size: 40,color: Colors.red));
                    }
                  }
                  else {
                    playedIndex = -1;
                    statusplay = statusmusic.stop;
                  }
                  setState(() { });
                } catch (t) {
                  //stream unreachable
                }
              },
              child:Row(
                  children: [
                    Container(
                      width:60,
                      margin: EdgeInsets.only(right:15),
                      child: Stack(
                        alignment: Alignment.center,
                          children:[
                            ['',null].contains(item['img'])?Image.asset("assets/logo.png",fit: BoxFit.cover): Image.network(item['img'],fit: BoxFit.cover,),
                            if([null,''].contains(item['url'])==false)
                              playedIndex!=id ?Icon( Icons.play_circle_fill,size: 30,color: Colors.white.withOpacity(.6) ,):(statusplay==statusmusic.playing?CircularProgressIndicator(strokeWidth: 2) : Icon( statusplay==statusmusic.played? Icons.pause_circle_filled: Icons.play_circle_fill,size: 30,color: Colors.white.withOpacity(.6) ,))
                          ]
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: played?Colors.white:Colors.black),),
                          Padding(padding: EdgeInsets.all(5),),
                          Text("Album : "+item['albume'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: played?Colors.white:Colors.black.withOpacity(.5))),
                          Padding(padding: EdgeInsets.all(5),),
                          Text("Genre : "+item['genre'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: played?Colors.white:Colors.black.withOpacity(.5))),
                        ],
                      ),
                    ),
                    Container(
                      width:50,
                      height: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                          children: [
                            InkWell(onTap: (){
                                api.addRemoveFavorite(home.DataTOPage['uid'],id).then((value){
                                  if(value['result']==true){
                                    home.DataTOPage['favorite_music'] = value['data'];
                                    messages.toast(value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,color: Colors.green,size: 40,));
                                    setState(() {});
                                  }
                                  else
                                      messages.toast("Error!",duration: 3,autoclose: true,img: Icon(Icons.dangerous,color: Colors.red,size: 40,),subtitle: value['msg']);
                                });
                            },child: Image.asset(isFavorite?"assets/heart.png":"assets/heart_dis.png", width:35,)),
                            Text( item['votes'].toString()+" Vote",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                          ]
                      ),
                    ),
                  ],
                ),
            ),
          );
        },
      )
    );
  }

}
