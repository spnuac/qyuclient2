library home_page;
import '../classes/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splashscreen.dart';
import 'modules/sidemenu.dart';
import 'modules/bottombar.dart' as buttombar;
import 'modules/home.dart'  ;
import 'modules/search.dart';
import 'modules/insights.dart';
import 'modules/mysets.dart';
import 'modules/upcoming.dart';
import 'Policy_Page.dart';
import 'Help_Page.dart';
import '../classes/Tools.dart' as tools;
import '../classes/Api.dart' as api;
import 'cardsadd.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:async';

dynamic DataTOPage;
String city='';
bool changedcity=false;

_HomePageState homecontext;

class HomePage extends StatefulWidget {
  dynamic data;
  HomePage(this.data);
  @override
  _HomePageState createState(){
    homecontext = _HomePageState(this.data);
    return homecontext;
  }
}
class _HomePageState extends State<HomePage> {
  dynamic data;
  bool signedOut = false;
  final _SwiperController = new SwiperController();
  _HomePageState(this.data);

  @override
  void initState() {
    super.initState();
    if(DataTOPage==null) {
      DataTOPage = this.data;
      if(city=='')
        city = DataTOPage['preffered_city'];
    }
    getdata();
  }

  void getdata() {
    if(DataTOPage!=null && DataTOPage['uid'].toString().length>0) {
      api.getuser(DataTOPage['uid'],city).then((value){
        if(value!=false){
          if(city=='')
            city = DataTOPage['preffered_city'];
          changedcity = false;
          DataTOPage = value;
          Timer(Duration(seconds:10),(){
            getdata();
          });
        }
        else
          Timer(Duration(seconds:10),(){
            getdata();
          });
      });
    }
    else
      Timer(Duration(seconds:10),(){
        getdata();
      });
    //else
     // context.read<AuthenticationProvider>().signOut().then((value){setState(() {signedOut=true;});});
  }



  @override
  Widget build(BuildContext context) {
    return signedOut
        ? splashscreen()
        : Scaffold(
            backgroundColor: Color(0xfff3f3f3),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.only(right:25),
                  child:Image.asset("assets/logo_whte.png",width: 30,))
              ],
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color.fromRGBO(117, 125, 249, 1.0),
                          Color.fromRGBO(214, 145, 236, 1),])),
              ),
            ),
            drawer: sidemenu(
                OnclickItems: (module){
                  switch(module){
                    case "Help":{tools.GotoPage(context,Help_Page());};break;
                    case "Terms":{tools.GotoPage(context,Policy_Page());};break;
                    case "card":{tools.GotoPage(context,cardsadd());};break;
                  }
                },
                OnsignedOut: (){
                  context.read<AuthenticationProvider>().signOut().then((value){setState(() {signedOut=true;});});
                },
                onchangeData: (Func) {
                      Func(context).then((value){
                        setState(() {DataTOPage = value;});
                      });
                }),
            extendBodyBehindAppBar: false,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(117, 125, 249, 1.0),
                      Color.fromRGBO(214, 145, 236, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                boxShadow: [BoxShadow(color: Colors.deepPurpleAccent.withOpacity(buttombar.selecteditem==buttombar.items.upcoming?0.4:0),blurRadius: 0,spreadRadius: 4)],
                borderRadius: BorderRadius.all( Radius.circular(30))
              ),
              child: FloatingActionButton(
                focusColor: buttombar.selecteditem==buttombar.items.upcoming? Color.fromRGBO(167, 135, 143, 1): Color.fromRGBO(267, 235, 243, 1),
                backgroundColor: buttombar.selecteditem==buttombar.items.upcoming?Colors.deepPurple: Color.fromRGBO(167, 135, 243, 1),
                tooltip: 'Upcoming event',
                child: Icon(Icons.multitrack_audio_sharp,size:30),
                splashColor: Colors.red,
                onPressed: (){
                  //buttombar.selecteditem = buttombar.items.upcoming;
                  //buttombar.menubarcontext.setState(() {});
                  //setState(() {});
                  //setState(() {
                    //selecteditem = items.upcoming;
                    _SwiperController.move(2,animation: false);
                  //});
                },

              ),
            ),
            floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: buttombar.menubar(onClickItems: (item){
              switch(item){
                case buttombar.items.mysets:  _SwiperController.move(4,animation: false); break;
                case buttombar.items.search:  _SwiperController.move(1,animation: false); break;
                case buttombar.items.insight:  _SwiperController.move(3,animation: false); break;
                case buttombar.items.upcoming:  _SwiperController.move(2,animation: false); break;
                default:
                  _SwiperController.move(0,animation: false);
              }
            }),
            body:WillPopScope(
              onWillPop: onWillPop,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Swiper(
                  fade: .3,
                  loop: true ,
                  onIndexChanged: (index){
                    switch(index){
                      case 1: buttombar.selecteditem = buttombar.items.search;break;
                      case 2: buttombar.selecteditem = buttombar.items.upcoming;break;
                      case 3: buttombar.selecteditem = buttombar.items.insight;break;
                      case 4: buttombar.selecteditem = buttombar.items.mysets;break;
                      default: buttombar.selecteditem = buttombar.items.home;break;
                    }
                    homecontext.setState(() {});
                    buttombar.menubarcontext.setState(() {});
                  },
                  itemCount: 5,

                  controller:_SwiperController ,

                  pagination: null,//new SwiperPagination(),
                  //control: new SwiperControl(),


                  itemBuilder: (BuildContext contexting,int index){
                    switch(index){
                      case 1:return search();break;
                      case 2:return upcoming();break;
                      case 3:return insights();break;
                      case 4:return mysets();break;
                      default :
                        return home();break;
                    }
                  },
                ),
              ),
            )
          );
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (Navigator.canPop(context)==false && (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2))) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text( "press again back to exit",textAlign: TextAlign.center,),backgroundColor: Color(
          0x9f7b7b7b),elevation: .3,behavior: SnackBarBehavior.floating,));
      return Future.value(false);
    }
    return Future.value(true);
  }
}
