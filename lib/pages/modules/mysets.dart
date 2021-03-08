import 'package:flutter/material.dart';
import '../home_page.dart' as homepage;
import '../items/item.dart';
import '../items/item2.dart';
import '../showevent.dart';
import '../../classes/Api.dart' as api;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';

enum steps {loading,nodata,hasdata}

steps step_upcoming = steps.loading;
List data_upcoming =[] ;


steps step_old = steps.loading;
List data_old =[] ;
int page = 1;
bool endlist=false;



class mysets extends StatefulWidget {
  @override
  _mysetsState createState() => _mysetsState();
}

class _mysetsState extends State<mysets> {
  Timer timng;

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    refresh();
  }
  void refresh(){
    timng = Timer(Duration(seconds: 10),(){
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

  @override
  Widget build(BuildContext context) {
    data_old = homepage.DataTOPage['old'];
    data_upcoming = homepage.DataTOPage['upcoming'];
    setStatus();
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start ,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10,bottom:10),
                        child: Text("Your upcoming set",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold )),
                      ),
                      upcomingwidget()
                    ],
                  ),
                )
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:10,bottom:10),
                    child: Text("Old Sets",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold )),
                  ),
                  upoldwidget()
                ],
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

  Future<void> getolddata() async {
    await api.getEvents({"uid":homepage.DataTOPage['uid'],"page":page,"myme":"1","old":"1"}).then((value){
      if(value['result']==true){
        if((value['data']['data'] as List).isEmpty || value['data']['total']==0)
          endlist = true;
        if(value['data']['total']>0) {
          step_old = steps.hasdata;
          if(page==1)
            data_old = value['data']['data'];
          else
            data_old.addAll(value['data']['data']);
        }
        else
          step_old = steps.nodata;
        if (mounted)
          setState(() {});
      }
    });
  }

  Widget upcomingwidget() {
    switch(step_upcoming){
      case steps.loading : {
        return Container(alignment: Alignment.center,  child: Column( children: [CircularProgressIndicator(strokeWidth: 2)]));
      }
      case steps.hasdata : {
        return Container(
          child:  ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            //controller: new ScrollController(),
            //controller: scrollController,
            itemCount: data_upcoming.length,
            itemBuilder: (context, index) {
              return item2(
                data_upcoming[index],
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => showevent(data_upcoming[index],"myset")),).then((value){

                  });
                }
                ,
              );
            },
          ),
        );
      }
      default : {
        return noData();
      }
    }
  }
  Widget upoldwidget() {
    switch(step_old){
      case steps.loading : {
        return Container(alignment: Alignment.center,  child: Column( children: [CircularProgressIndicator(strokeWidth: 2)]));
      }
      case steps.hasdata : {
        return Expanded(
          child: SmartRefresher(
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
            child:  ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                //controller: new ScrollController(),
                //controller: scrollController,
                itemCount: data_old.length,
                itemBuilder: (context, index) {
                  return new item2(
                    data_old[index],
                    disabledMode: true,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => showevent(data_old[index], "myset")),)
                          .then((value) {

                      });
                    }
                    ,
                  );

            }),
          ),
        );
      }
      default : {
        return noData();
      }
    }
  }

  void _onLoading() async{
    // monitor network fetch
    if(endlist==false) {
      page++;
      getolddata();
      if (mounted)
        setState(() {

        });
    }
    _refreshController.loadComplete();
  }
  void _onRefresh() async{
    page=1;
    await getolddata();
    if (mounted)
      setState(() {
      });
    _refreshController.refreshCompleted();
  }
  void setStatus() {
    step_old= data_old.length>0?steps.hasdata:steps.nodata;
    step_upcoming= data_upcoming.length>0?steps.hasdata:steps.nodata;
  }
}
