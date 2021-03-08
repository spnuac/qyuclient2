import 'package:flutter/material.dart';
import '../../classes/Api.dart' as api;
import '../genreform.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:typed_data';
import '../../classes/messages.dart' as messages;
import '../../classes/Tools.dart' as tools;
import '../home_page.dart' as home;
import '../cardsadd.dart';
import '../fav.dart';

typedef changeData = dynamic Function(Function a);
typedef signedout = void Function();
typedef itemclick = void Function(String module);

class sidemenu extends StatefulWidget {
  changeData onchangeData;
  signedout OnsignedOut;
  itemclick OnclickItems;
  sidemenu({this.onchangeData,this.OnsignedOut,this.OnclickItems});
  @override
  _sidemenuState createState() => _sidemenuState(this.onchangeData,this.OnclickItems,this.OnsignedOut);
}

class _sidemenuState extends State<sidemenu> {
  changeData onchangeData;
  signedout OnsignedOut;
  itemclick OnclickItems;
  bool signedOut = false;
  final _picker = ImagePicker();
  Io.File _image;
  _sidemenuState(this.onchangeData,this.OnclickItems,this.OnsignedOut);

  @override
  Widget build(BuildContext context) {

    String avatar = api.getLocalData('avatar');
    Uint8List bytesavatar ;
    if([null,'',false].contains(avatar)==false){
      bytesavatar = base64Decode(avatar);
    }
    return Drawer(


      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
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
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                Stack(
                                alignment: Alignment.center,
                                fit: StackFit.loose,
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(Radius.circular(110)),
                                        boxShadow: [BoxShadow(color: Colors.white,blurRadius: 0,spreadRadius: 3)]
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        openmagepicker();
                                      },
                                      child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: _image!=null?Image.file( _image,fit: BoxFit.cover): (bytesavatar!=null?Image.memory(bytesavatar,fit: BoxFit.cover ):(![null,''].contains( home.DataTOPage['img'])? Image.network(home.DataTOPage['img'],fit: BoxFit.cover,): Image.asset('assets/logo.png',fit: BoxFit.cover ,)))),
                                    ),
                                  ),
                                ],
                              ),
                                Positioned(
                                  bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          boxShadow: [BoxShadow(color: Color.fromRGBO(209, 145, 238, 1.0),blurRadius: 0,spreadRadius: 2)]
                                      ),
                                      child: Icon(Icons.camera_alt,color: Colors.purple,size: 15,),
                                    )
                                )
                              ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top:15),
                              child: Text(home.DataTOPage['fname']+" "+home.DataTOPage['lname'],style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),)
                          )
                        ],
                      )
                  ),
                ),
                item("My Account",
                    closeMenuOnclick: false,
                    onclick: (){
                      onchangeData((pcontext) async {
                        dynamic data = await Navigator.push(
                          pcontext,
                          MaterialPageRoute(builder: (context) => genreform({"data":home.DataTOPage,"next_step":"backtohome"})),
                        );
                        if(data!=null)
                            home.DataTOPage = data;
                        return home.DataTOPage;
                      });
                    }
                    ,color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1),icon: Icons.arrow_forward_ios ),
                //item("Tickets",onclick: (){OnclickItems("Tickets");},color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1) ,icon: Icons.arrow_forward_ios),
                item("Favorite musics",onclick: (){
                   Navigator.push(context,MaterialPageRoute(builder: (context) => fav()),);
                },color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1) ,icon: Icons.arrow_forward_ios),
                item("Payment Cards",onclick: (){
                  opencardsheet(context);
                  },color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1),icon: Icons.arrow_forward_ios ),
                item("Help",onclick: (){OnclickItems("Help");},color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1),icon: Icons.arrow_forward_ios ),
                item("Terms & Conditions",onclick: (){OnclickItems("Terms");},color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1),icon: Icons.arrow_forward_ios ),

              ],
            ),
          ),
          Column(
            children: [
              item("Sign Out",
                  onclick: (){
                    OnsignedOut();
                  },
                  margin: EdgeInsets.only(top:0),color: Colors.white,divide: BorderSide(color: Colors.black.withOpacity(.1),width: 1),icon: Icons.logout ),
              //item("Delete Account",padding: EdgeInsets.only(bottom:10),align:TextAlign.center,margin: EdgeInsets.only(top:15),style: TextStyle(color: Colors.red),color: Colors.transparent ),

            ],
          )
        ],
      ),
    );
  }

  Widget item(text,{onclick=null,margin=null,align=null,closeMenuOnclick=false,padding=null,color:Colors.black12,BorderSide divide:BorderSide.none,TextStyle style=null,IconData icon=null}){
    return FlatButton(
      color:color ,
      onPressed: (){
        if(closeMenuOnclick)
          Navigator.pop(context);
        if(onclick!=null)
          onclick();
      },
      child: Container(
        margin:margin,
        padding: padding==null?EdgeInsets.only(left:20,right:20,top:20,bottom:20):padding,
        decoration: BoxDecoration(
          border: Border(bottom:divide,top:divide)
        ),
        child: Row(
          children: [
            Expanded(child: Text(text,textAlign: align,style: style==null?TextStyle(fontSize: 16):style,)),
            if(icon!=null)
              Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Icon(icon,color: Colors.black.withOpacity(.4),size: 15,)
              ),
          ],
        )
      ),
    );
  }
  void openmagepicker(){
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {

        return
          SizedBox(
            height: 130,
            width: double.infinity,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 10,blurRadius: 8)]
              ),
              child: ListView(

                children: [
                  Container(
                    padding: EdgeInsets.only(left:20,right:20,top:10,bottom:10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.black12))
                    ),
                    child: FlatButton(
                      onPressed: (){Navigator.pop(context);_imgFromGallery();},
                      child: Row(
                        children: [
                          Expanded(child: Text("From Gallery",style: TextStyle(fontSize: 16),)),
                          Icon(Icons.image_search_outlined),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:20,right:20,top:10,bottom:10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color: Colors.black12))
                    ),
                    child: FlatButton(
                      onPressed: (){Navigator.pop(context);_imgFromCamera();},
                      child: Row(
                        children: [
                          Expanded(child: Text("From Camera",style: TextStyle(fontSize: 16),)),
                          Icon(Icons.camera_alt),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  _imgFromCamera() async {
    PickedFile  pickedFile = await _picker.getImage(
        source: ImageSource.camera, imageQuality: 100
    );

    setState(() {
      _image = Io.File(pickedFile.path);
      uploadimg();
    });
  }

  _imgFromGallery() async {
    PickedFile pickedFile = await  _picker.getImage(source: ImageSource.gallery, imageQuality: 100 );

    setState(() {
      _image = Io.File(pickedFile.path);
      uploadimg();
    });
  }

  void uploadimg(){
    messages.waiting(context,title: "Upload file ...");
    home.DataTOPage['imgupload'] = base64Encode(tools.resizeImage(_image,width: 200));
    home.DataTOPage['imgName'] = 'client_'+home.DataTOPage['uid'].toString()+'.png';
    api.saveProfile(home.DataTOPage).then((value){
      messages.closeWaiting(context);
      if(value['result']==true){
        api.setLocalData('avatar', home.DataTOPage['imgupload']);
        setState(() { home.DataTOPage = value['data'];});
      }
      else
        messages.toast("Error upload !",autoclose: true,duration: 4,subtitle: value['msg'],img: Icon(Icons.dangerous,size: 25,color: Colors.redAccent));

    });
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
                borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 10,blurRadius: 8)]
            ),
            child: SizedBox.expand(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Payment Cards",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),)),
                      SizedBox(
                        width: 55,
                        child: OutlineButton(
                          padding: EdgeInsets.only(left:10,right:10),
                          onPressed: (){
                            OnclickItems("card");
                          },
                          color: Colors.green,
                          child: Row(
                            children: [
                              Icon(Icons.add,color: Colors.black,size: 12,),
                              Text("Add",style: TextStyle(color: Colors.black,fontSize: 12),),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                  Divider(),
                  if( home.DataTOPage['cards'].length==0)
                    Container(
                      padding:EdgeInsets.only(top:20,bottom: 15),
                      child:Text("Not found any card",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.1)),),
                    ),
                  if(home.DataTOPage['cards'].length>0)
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    itemCount: home.DataTOPage['cards'].length,
                    itemBuilder: (context, index) {
                      final item = home.DataTOPage['cards'][index];
                      return Container(
                        padding: EdgeInsets.only(bottom:5,top:5),
                        margin:  EdgeInsets.only(bottom:5,top:5),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black.withOpacity(.1),width: 1))
                        ),
                        child:Row(
                          children: [
                            Expanded(
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
                            InkWell(
                              onTap: (){
                                Navigator.pop(pcontext);
                                messages.confirm(pcontext,title: "Delete Card ...",content: "Are you sure?",oncancelBtnTap: (){Navigator.pop(pcontext); opencardsheet(pcontext);},onconfirmBtnTap: (){
                                  Navigator.pop(pcontext);
                                  messages.waiting(pcontext);
                                  api.DeleteCard(item['cc_id'],home.DataTOPage['uid']).then((value){
                                      messages.closeWaiting(pcontext);
                                      if(value['code']=="1"){
                                        (home.DataTOPage['cards'] as List).removeAt(index);
                                        messages.toast("Notification!",subtitle: value['msg'],duration: 3,autoclose: true,img: Icon(Icons.check_circle,size:35,color: Colors.lightGreen,));
                                      }
                                      else
                                        messages.toast("Error",subtitle: value['msg'],duration: 3,autoclose: true,img: Icon(Icons.dangerous,size:35,color: Colors.red,));
                                  });
                                });
                              },
                              child: SizedBox(
                                width: 35,
                                child: OutlineButton(
                                  padding: EdgeInsets.zero,
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  child: Icon(Icons.delete_sharp,size: 20,color: Colors.black.withOpacity(.6)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                            ),
                            InkWell(
                              onTap: (){
                                onchangeData((pcontext) async {
                                  dynamic data = await Navigator.push(
                                    pcontext,
                                    MaterialPageRoute(builder: (context) => cardsadd(id:index.toString(),)),
                                  );
                                  return home.DataTOPage;
                                });
                              }
                              ,
                              child: SizedBox(
                                width: 35,
                                child: OutlineButton(
                                  padding: EdgeInsets.zero,
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  child: Icon(Icons.edit,size: 20,color: Colors.black.withOpacity(.6),),
                                ),
                              ),
                            )
                          ],
                        )
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
