import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qyuclient/classes/Api.dart' as api;
import 'package:qyuclient/classes/Tools.dart' as tools;
class Policy_Page extends StatefulWidget {
  @override
  _Policy_PageState createState() => _Policy_PageState();
}
enum steps{loading,loaded,error}
class _Policy_PageState extends State<Policy_Page> {
  String Title='Loading ...';
  String html='';
  steps step = steps.loading;



  @override
  Widget build(BuildContext context) {
    if(step==steps.loading) {
      api.getPolicy().then((value) {
        if (value != false) {
          step = steps.loaded;
          Title = value['data']['title'];
          html = value['data']['html'];
        }
        else {
          step = steps.error;
          Title = "Error 404 !";
          html = "Not found page ...";
        }
        setState(() {});
      });
    }
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset:true,
        appBar: AppBar(
          title: Text("TC & Privacy Policy",style: TextStyle(color: Colors.white)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.black,

        ),
        body:Container(
              padding: EdgeInsets.all(0),
              alignment:step==steps.loading?Alignment.center:Alignment.topCenter,
              child:
              SingleChildScrollView(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Container(
                        child:
                              step==steps.loading?
                              Column(
                                children: [
                                  CircularProgressIndicator(strokeWidth: 2),
                                  Padding(padding:EdgeInsets.all(10)),
                                  Text("Loading...")
                                ],
                              )
                              :
                              Text(Title,style:TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color:Colors.black),textAlign: TextAlign.center)
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Html(data:html,onLinkTap: (url){
                        tools.ViewURL(url);
                      })
                    ],
                  )
              ),
        )
    );
  }
}
