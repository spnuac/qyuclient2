import 'package:flutter/material.dart';
import '../home_page.dart' as home;
import '../../classes/Api.dart' as api;
import '../../classes/messages.dart' as messages;
import 'dart:async';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:qyuclient/pages/citypicker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../items/item.dart';
import '../showevent.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

int page=1;
String city = '';
List Genre = [];
String dt ='';
List resultsearch= [];
bool endlist = false;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:api.GoogleApi);
class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  bool hasresult =false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    if(city==''){
      city = home.DataTOPage['preffered_city'];
    }
  }
  void _onLoading() async{
    // monitor network fetch
    if(endlist==false) {
      page++;
      search(context);
      if (mounted)
        setState(() {

        });
    }
    _refreshController.loadComplete();
  }

  void search(context){
        api.getEvents({"uid":home.DataTOPage['uid'],"page":page,"city":city,"fromdt":dt,"nexts":(dt.isEmpty?"0":"1"),'genres':Genre.join(",")}).then((value) {
          if(value['result']==true){
              if((value['data']['data'] as List).isEmpty)
                endlist = true;
              if(page==1)
                  resultsearch = value['data']['data'];
              else
                resultsearch.addAll(value['data']['data']);
            }
            else
              resultsearch = [];
            setState(() {});
        });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child:Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.only(top:10,left:20,right:20,bottom:10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(width: 1,color:Color(0xffdbdbdb)),
            ),
            child: InkWell(
              onTap: (){openfiltersheet(context);},
              child: Row(
                children: [
                  Expanded(child: Text("London - Genre ["+Genre.length.toString()+"]" +([null,''].contains(dt)?"":"\r\n"+dt),style: TextStyle(color:Colors.black,fontSize: 18,fontWeight: FontWeight.w900),)),
                  Align(
                    child: Image.asset("assets/filter.png",width:30),
                  )
                ],
              ),
            ),
          ),
          resultsearch.length==0?

          Expanded(
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center ,
                  children: [
                    Image.asset("assets/nodata.png",width: 120),
                    Padding(padding: EdgeInsets.all(10),),
                    Text("Sorry! No event found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    Padding(padding: EdgeInsets.all(3),),
                    Text("please change filter and try again...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black.withOpacity(.5)),)
                  ],
                )
            ),
          )

              :
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom:10,right:5,left:5),
              child: SmartRefresher(
                enablePullDown: false,
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
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,

                  //controller: new ScrollController(),
                  //controller: scrollController,
                  itemCount: resultsearch.length,
                  itemBuilder: (context, index) {
                    return InkWell(

                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => showevent(resultsearch[index],"search")),).then((value){

                          });
                        },
                      child: Padding(
                        padding: const EdgeInsets.only(top:10),
                        child: item(
                          resultsearch[index],showPrice: true,
                        ),
                      ),
                    );
                  },
                ),
              )
            ),
          )
        ],
      ),
    );
  }
  void openfiltersheet(pcontext){
    showModalBottomSheet<void>(
      context: pcontext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context, StateSetter mystate)
              {
                return Container(
                  margin: EdgeInsets.only(
                      left: 10, right: 10, bottom: 0, top: 50),
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12,
                            spreadRadius: 10,
                            blurRadius: 8)
                      ]
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("Search Filter", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),)),
                              SizedBox(
                                width: 55,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(pcontext);
                                  },
                                  child: Icon(Icons.close, color: Colors.black,
                                    size: 22,),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffb6b6b6), width: 2,),
                              borderRadius: BorderRadius.all(Radius.circular(4))

                          ),
                          child: InkWell(
                            onTap: () {
                              PlacesAutocomplete.show(
                                  context: pcontext,
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
                                messages.waiting(pcontext);
                                _places.getDetailsByPlaceId(value.placeId).then((
                                    detail) {
                                  final lat = detail.result.geometry.location.lat;
                                  final lng = detail.result.geometry.location.lng;
                                  city =detail.result.addressComponents[0].longName;
                                  messages.closeWaiting(pcontext);
                                  mystate(() {});
                                  setState(() {});
                                });
                              }).catchError((error) {
                                messages.closeWaiting(pcontext);
                                mystate(() {});
                                setState(() {});
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(child: Text(city, style: TextStyle(
                                    color: Colors.black.withOpacity(.5)))),
                                SizedBox(width: 40, child: Icon(
                                    Icons.location_pin, size: 28,
                                    color: Colors.black.withOpacity(.5)))
                              ],
                            ),
                          ),

                        ),
                        Padding(padding: EdgeInsets.all(25),),
                        Text("Genre", style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(1))),
                        Padding(padding: EdgeInsets.all(5),),
                        Container(
                            child: GridView.count(
                              shrinkWrap: true,
                              // crossAxisCount is the number of columns
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3,
                              crossAxisSpacing: 5,
                              // This creates two columns with two items in each column
                              children: List.generate(api.genres.length, (indexing) {
                                String val = api.genres[indexing]['id'].toString();
                                bool checked = Genre.indexOf(val) >= 0;
                                return Container(
                                  decoration: BoxDecoration(
                                      color: checked ? Colors.green : Colors
                                          .transparent,
                                      border: Border.all(
                                        color: checked ? Colors.green : Color(
                                            0xffb6b6b6), width: 2,),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4))
                                  ),
                                  child: SizedBox.expand(
                                    child: OutlineButton(
                                      onPressed: (){
                                        if (checked)
                                          Genre.remove(val);
                                        else
                                          Genre.add(val);
                                        mystate(() {});
                                      },
                                      child: Text(api.genres[indexing]['name'],
                                          style: TextStyle(fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(
                                                  checked ? 1 : .6))),
                                    ),
                                  ),
                                );
                              }),
                            )
                        ),
                        Padding(padding: EdgeInsets.all(25),),
                        Text("From Date", style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(1))),
                        Padding(padding: EdgeInsets.all(5),),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffb6b6b6), width: 2,),
                              borderRadius: BorderRadius.all(Radius.circular(4))

                          ),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,initialDateTime:dt.isEmpty?null:DateTime.tryParse(dt) ,pickerMode: DateTimePickerMode.date,dateFormat: 'dd MMMM yyyy',onConfirm: (d,i){dt=DateFormat('dd MMMM yyyy').format(d);});
                                mystate(() {});
                              },
                            child: Row(
                              children: [
                                Expanded(child: Text(dt, style: TextStyle(
                                    color: Colors.black.withOpacity(.5)))),
                                SizedBox(width: 40, child: Icon(
                                    Icons.calendar_today_outlined, size: 28,
                                    color: Colors.black.withOpacity(.5)))
                              ],
                            ),
                          ),

                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Container(
                            width: double.infinity,
                            child: FlatButton(
                              color: Colors.transparent,
                              onPressed: (){
                                Genre = [];
                                dt ="";
                                mystate(() {});
                              },
                              child: Text('Clear All',style: TextStyle(color:Colors.black.withOpacity(.5),fontWeight: FontWeight.bold),),
                            )
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                            child: FlatButton(
                              height: 40,
                              padding: EdgeInsets.all(10),
                              color: Colors.green,
                              onPressed: (){
                                Navigator.pop(pcontext);
                                page=1;
                                endlist=false;
                                search(pcontext);
                              },
                              child: Text('Search',style: TextStyle(color:Colors.white.withOpacity(1),fontWeight: FontWeight.bold),),
                            )
                        )
                      ],
                    ),
                  ),
                );
              });
      },
    );
  }
}
