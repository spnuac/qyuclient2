import 'package:flutter/material.dart';
import '../classes/Api.dart' as api;
import 'package:just_audio/just_audio.dart';
import 'home_page.dart' as home;
import '../classes/messages.dart' as messages;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';


enum statusmusic {stop,playing,played}
int playedIndex = -1;
final playering = AudioPlayer();
statusmusic statusplay = statusmusic.stop;
enum steps {loading,nodata,hasdata}

class fav extends StatefulWidget {
  @override
  _favState createState() => _favState();
}

class _favState extends State<fav> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List datalist =[] ;
  int page = 1;
  steps step_fav = steps.loading;
  bool endlist=false;
  @override
  void initState() {
    super.initState();
    playering.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.loading:{statusplay = statusmusic.playing;};break;
        case ProcessingState.buffering:{statusplay = statusmusic.playing;};break;
        case ProcessingState.ready:{statusplay = statusmusic.played;};break;
        case ProcessingState.completed:{statusplay = statusmusic.stop;playedIndex =-1;setState(() {});};break;
      }
    });
    datalist =  home.DataTOPage['fav']['data'];
  }
  @override
  Widget build(BuildContext context) {
    step_fav= datalist.length>0?steps.hasdata:steps.nodata;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,foregroundColor: Colors.white, title: Text("Favorites List",style: TextStyle(),)),
      body: Container(padding: EdgeInsets.all(15), child: tracks()),
    );
  }

  Future<void> gefavdata() async {
    await api.getFavorite({"uid":home.DataTOPage['uid'],"page":page}).then((value){
      if(value['result']==true){
        if((value['data']['data'] as List).isEmpty || value['data']['total']==0)
          endlist = true;
        if(value['data']['total']>0) {
          step_fav = steps.hasdata;
          if(page==1)
            datalist = value['data']['data'];
          else
            datalist.addAll(value['data']['data']);
        }
        else
          step_fav = steps.nodata;
        if (mounted)
          setState(() {});
      }
    });
  }
  Widget noData({title ="Sorry ! not found any music in your list",subtitle=""}){
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
  Widget tracks(){
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: datalist==null || (datalist as List).length==0?noData(): SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  null;
              }
              else if(mode==LoadStatus.loading){
                body =  CircularProgressIndicator(strokeWidth: 2);
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          header: WaterDropHeader(),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            //controller: scrollController,
            itemCount: datalist.length,
            itemBuilder: (context, index) {
              var item = datalist[index];
              var id =datalist[index]['id'];
              bool isFav = home.DataTOPage['favorite_music'].toString().indexOf(","+id.toString()+",")>=0;

              return Container(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(bottom:5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                    colors: [
                       Color.fromRGBO(255, 255, 255, 1.0),
                       Color.fromRGBO(227, 227, 227, 1.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                            Text(item['title'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("Album : "+item['albume'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.5))),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("Genre : "+item['genre'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.5))),
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
                              InkWell(onTap:!isFav?null: (){
                                api.addRemoveFavorite(home.DataTOPage['uid'],id).then((value){
                                  if(value['result']==true){
                                    home.DataTOPage['favorite_music'] = value['data'];
                                    messages.toast(value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,color: Colors.green,size: 40,));
                                    setState(() {});
                                  }
                                  else
                                    messages.toast("Error!",duration: 3,autoclose: true,img: Icon(Icons.dangerous,color: Colors.red,size: 40,),subtitle: value['msg']);
                                });
                              },child: Icon(Icons.delete_sharp,size: 30,color: !isFav?Colors.black.withOpacity(.4):Colors.blue)),
                              Text( item['votes'].toString()+" Vote",overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
    );
  }
  void _onLoading() async{
    // monitor network fetch
    if(endlist==false) {
      page++;
      gefavdata();
      if (mounted)
        setState(() {});
    }
    _refreshController.loadComplete();
  }
  void _onRefresh() async{
    page=1;
    await gefavdata();
    if (mounted)
      setState(() {});
    _refreshController.refreshCompleted();
  }
}
