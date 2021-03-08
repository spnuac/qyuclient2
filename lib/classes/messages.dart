library messages;
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

enum msgtype { success, error, warning, info }
void show(BuildContext context,{String title='',String content='',msgtype type=msgtype.success}){
  CoolAlert.show(
    context: context,
    type: type==msgtype.success?CoolAlertType.success:
            (type==msgtype.error?CoolAlertType.error:
            (type==msgtype.warning?CoolAlertType.warning:CoolAlertType.info)),
    title: title,
    text: content,
  );
}
void confirm(BuildContext context,{String title='',String content='',void oncancelBtnTap(),void onconfirmBtnTap()}){
  CoolAlert.show(
    context: context,
    type: CoolAlertType.confirm,
    title: title,
    text: content,
    showCancelBtn: true,
    onCancelBtnTap: (){oncancelBtnTap();},
    onConfirmBtnTap: (){onconfirmBtnTap();},
  );
}
void waiting(BuildContext context,{void oncancelBtnTap(),title:"Loading..."}){
  CoolAlert.show(
    context: context,
    barrierDismissible:false,
    type: CoolAlertType.loading,
    title: title,
    text:  title,
  ).then((value) {if(oncancelBtnTap!=null) oncancelBtnTap();});
}
void closeWaiting(BuildContext context){
  Navigator.pop(context);
}

void toast(title,{Widget img:null,autoclose:true,duration:8,subtitle:'',showInTop:false}){
  showSimpleNotification(
    Padding(padding: EdgeInsets.only(bottom:8),child: Text(title,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
    background: Colors.black,
    contentPadding: EdgeInsets.only(top:10,bottom:10,left:15,right:10),
    leading: SizedBox( width: 60, child:img),
    slideDismiss: true,
    foreground: Colors.amberAccent,
    position:showInTop?NotificationPosition.top: NotificationPosition.bottom,
    autoDismiss: autoclose,
    duration: Duration(seconds: duration),
    subtitle: Text(subtitle,style: TextStyle(color:Colors.white60,fontSize: 13)),
    trailing: Builder(builder: (context) {
      return FlatButton(
          textColor: Colors.yellow,
          onPressed: () {
            OverlaySupportEntry.of(context).dismiss();
          },
          child: Icon(Icons.close,color: Colors.white70,));
    }),
  );
}