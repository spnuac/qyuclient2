import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qyuclient/classes/Api.dart' as api;
import 'package:qyuclient/classes/Tools.dart' as tools;
class Help_Page extends StatefulWidget {
  @override
  _Help_PageState createState() => _Help_PageState();
}
enum steps{loading,loaded,error}
class _Help_PageState extends State<Help_Page> {
  String Title='Loading ...';
  String html='';
  steps step = steps.loading;



  @override
  Widget build(BuildContext context) {
    if(step==steps.loading) {
      api.getHelp().then((value) {
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
          title: Text("Help",style: TextStyle(color: Colors.white)),
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
