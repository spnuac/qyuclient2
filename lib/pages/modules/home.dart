import 'package:flutter/material.dart';
import '../home_page.dart' as homepage;
import '../../classes/Api.dart' as api;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../items/item.dart';
import '../items/item2.dart';
import '../showevent.dart';
import 'package:qyuclient/pages/citypicker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../../classes/messages.dart' as messages;
import 'dart:async';

enum steps {loading,nodata,hasdata}
steps step_upcoming = steps.loading;
List data_upcoming =[] ;

steps step_suggest = steps.loading;
List data_suggest =[];
int page=1;

steps step_nexting = steps.loading;
List data_nexting=[] ;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:api.GoogleApi);

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<StatefulWidget> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Timer timng;
  void _onRefresh() async{
    await getfulldata();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    refresh();
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
    print(homepage.city);
    data_suggest = homepage.DataTOPage['suggest'];
    data_nexting = homepage.DataTOPage['next'];
    data_upcoming = homepage.DataTOPage['upcoming'];
    setStatus();
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left:20,right:15,top:30,bottom:20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your upcoming set",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold )),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top:30,bottom: 30),
                child: upcomingwidget()

              ),
              Row(

                children: [
                  Expanded(child:Text("Suggested Events",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold ))),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: SizedBox(
                      child: OutlineButton(
                        color: Colors.red,
                        visualDensity: VisualDensity.compact,
                        onPressed: (){
                          PlacesAutocomplete.show(
                              context: context,
                              types: ['(cities)'],
                              sessionToken: Uuid().generateV4(),
                              apiKey: api.GoogleApi,
                              //api.GoogleApi,
                              mode: Mode.overlay,
                              // Mode.fullscreen
                              overlayBorderRadius: BorderRadius.all(
                                  Radius.circular(20)),
                              hint: "Enter your city",
                              logo: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  ],
                                ),
                              ),
                              components: []).then((value) {
                            messages.waiting(context);
                            _places.getDetailsByPlaceId(value.placeId).then((
                                detail) {
                              final lat = detail.result.geometry.location.lat;
                              final lng = detail.result.geometry.location.lng;
                              homepage.city =detail.result.addressComponents[0].longName;
                              messages.closeWaiting(context);
                              step_suggest = steps.loading;
                              homepage.changedcity=true;
                              setState(() {});
                            });
                          }).catchError((error) {
                            messages.closeWaiting(context);
                            setState(() {});
                          });
                        },
                        shape: new RoundedRectangleBorder( borderRadius: new BorderRadius.circular(4.0)),
                        padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Icon(Icons.filter_alt_outlined,size: 20, color: Colors.black.withOpacity(.4),),
                              Text(homepage.city,style: TextStyle(color: Colors.black.withOpacity(.4)),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top:10,bottom: 30),
                  child: suggestwidget()

              ),
              Text("Your Next events",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold )),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top:30,bottom: 30),
                  child: nextwidget()

              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void>  getfulldata() async {
    final value = await api.getAllEventUser({"uid":homepage.DataTOPage['uid'],"city":homepage.city});
    if(value['result']==true){
      print(value);
      if((value['data']['upcoming'] as List).length>0){
        step_upcoming = steps.hasdata;
        data_upcoming = value['data']['upcoming'];
        homepage.DataTOPage['upcoming'] = value['data']['upcoming'];
      }
      else
        step_upcoming = steps.nodata;
      if((value['data']['next'] as List).length>0){
        step_nexting = steps.hasdata;
        data_nexting = value['data']['next'];
        homepage.DataTOPage['next'] = value['data']['next'];
      }
      else
        step_nexting = steps.nodata;
      if((value['data']['suggest'] as List).length>0){
        step_suggest = steps.hasdata;
        data_suggest = value['data']['next'];
        homepage.DataTOPage['suggest'] = value['data']['suggest'];
      }
      else
        step_suggest = steps.nodata;
      if (mounted)
        setState(() {});
    }
  }
  Widget upcomingwidget() {
    switch(step_upcoming){
      case steps.loading : {
        return Container(alignment: Alignment.center, height: 250, child: Column( children: [CircularProgressIndicator(strokeWidth: 2)]));
      }
      case steps.hasdata : {
        return Container(
          height: 250,
          transform: Matrix4.translationValues(-14.0, 0.0, 10.0),
          child: Swiper(
            fade: .5,
            onTap: (index){
              Navigator.push(context,MaterialPageRoute(builder: (context) => showevent(data_upcoming[index],"home")),).then((value){
                setState(() {});
              });
            },
            viewportFraction: .9,
            scale: 1,
            loop: false ,
            onIndexChanged: (index){},
            itemCount: data_upcoming.length,
            itemBuilder: (BuildContext contexting,int index){
              return item(data_upcoming[index],);
            },
          ),
        );
      }
      default : {
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
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
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child:Image.asset("assets/logo_whte.png",fit:BoxFit.cover,)
              ),
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text("Sorry ! no data found",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),),
                      Padding(padding: EdgeInsets.all(3),),
                      Text("You have not set any event yet",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(.6),fontWeight: FontWeight.bold,fontSize: 13),)
                    ],
                  ),
                )
              )
            ],
          ),
        );
      }
    }
  }

  Widget suggestwidget() {
    switch(step_suggest){
      case steps.loading : {
        return Column(children: [CircularProgressIndicator(strokeWidth: 2,)]);
      }
      case steps.hasdata : {

        return Container(
          height: 250,
          margin: EdgeInsets.only(top:20),
          transform: Matrix4.translationValues(-14.0, 0.0, 10.0),
          child: Swiper(
            fade: .5,
            onTap: (index){
              Navigator.push(context,MaterialPageRoute(builder: (context) => showevent(data_suggest[index],"home")),).then((value) async {
                if(value==true){
                  setState(() {});
                }
              });
            },
            viewportFraction: .9,
            scale: 1,
            loop: false ,
            onIndexChanged: (index){
            },
            itemCount: data_suggest.length,
            itemBuilder: (BuildContext contexting,int index){
              return item(data_suggest[index],showPrice:true ,);
            },
          ),
        );
      }
      default : {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:20,bottom:20,left:10,right:10),
                child: Column(
                  children: [
                    Text("Not found any event in "+homepage.city,style: TextStyle( color: Colors.deepPurple,fontSize: 14,fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.all(6)),
                    Row(
                      children: [
                            Column(
                              children: [
                                    Text("Genres :",style: TextStyle(color: Colors.black.withOpacity(.5),fontSize: 13),),

                              ]
                            ),
                            Expanded(child: Column(children: [Text(homepage.DataTOPage['genre_names'],style: TextStyle(color: Colors.black,fontSize: 13))]))
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    Row(

                      children: [
                        Column(
                          children: [
                            Text("Venues :",style: TextStyle(color: Colors.black.withOpacity(.5),fontSize: 13)),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(homepage.DataTOPage['venue_names'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 13)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: 90, child: Image.asset("assets/nodata.png",fit: BoxFit.fill,)),
            ),
          ],
        );




      }
    }
  }
  Future<void> getsuggestdata() async {
    await api.getEvents({"uid":homepage.DataTOPage['uid'],'nexts':1,'city':homepage.city,'genres':homepage.DataTOPage['ugenres'],'venues':homepage.DataTOPage['uvenues'],'page':page}).then((value){
      if(value['result']==true){
        if(value['data']['total']>0) {
          step_suggest = steps.hasdata;
          data_suggest = value['data']['data'];
          homepage.DataTOPage['suggest']= data_suggest;
        }
        else
          step_suggest = steps.nodata;
        if (mounted)
          setState(() {});
      }
    });
  }
  Widget nextwidget() {
    switch(step_nexting){
      case steps.loading : {
        return Column(children: [CircularProgressIndicator(strokeWidth: 2)]);
      }
      case steps.hasdata : {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          //controller: new ScrollController(),
          //controller: scrollController,
          itemCount: data_nexting.length,
          itemBuilder: (context, index) {
            return item2(
              data_nexting[index],
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => showevent(data_nexting[index],"home")),).then((value){
                        setState(() {});
                });
              }
              ,
            );
          },
        );
      }
      default : {
        return Container(
          alignment: Alignment.center,
          child:Column(
            children: [
              Image.asset("assets/nodata.png",width: 120),
              Padding(padding: EdgeInsets.all(10),),
              Text("Sorry ! no data found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Padding(padding: EdgeInsets.all(3),),
              Text("You may not have set any event yet",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black.withOpacity(.5)),)
            ],
          )
        );
      }
    }
  }

  void setStatus() {
    if(homepage.changedcity==false) {
      step_suggest = data_suggest.length > 0 ? steps.hasdata : steps.nodata;
      step_nexting = data_nexting.length > 0 ? steps.hasdata : steps.nodata;
      step_upcoming = data_upcoming.length > 0 ? steps.hasdata : steps.nodata;
    }
  }
}
