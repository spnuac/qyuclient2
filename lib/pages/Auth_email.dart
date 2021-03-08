import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qyuclient/classes/Api.dart' as api;
import '../classes/messages.dart' as messages;
import '../classes/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Auth_email extends StatefulWidget {
  @override
  _Auth_emailState createState() => _Auth_emailState();
}

class _Auth_emailState extends State<Auth_email> with WidgetsBindingObserver {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset:true,
        body:
        Builder(
          builder: (context) =>Form(
            key: _formKey,
            child: Stack(

                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(

                      image: DecorationImage(

                          image: AssetImage('assets/login.png'),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                  Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        actions: [
                          Padding(
                            padding:EdgeInsets.only(right:20),
                            child: Opacity(
                              opacity: .3,
                              child: SizedBox(
                                  width:50,
                                  height:50,
                                  child:Image(fit: BoxFit.cover,image: CachedNetworkImageProvider(api.getLogo()))
                              ),
                            ),
                          )
                        ],
                      ),
                      body:
                      Container(
                        padding: EdgeInsets.only(bottom:30),
                        alignment:Alignment.center ,
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(left:40,right:40),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(.8),
                                  radius: 50,
                                  child: Icon(Icons.email_outlined,size: 45,color: Colors.purple,),
                                ),
                                Padding(padding:EdgeInsets.all(20)),
                                Text("Let's get started ?",style: TextStyle(fontSize: 24,color:Colors.white,fontWeight: FontWeight.w700)),
                                Padding(padding:EdgeInsets.all(20)),
                                Container(
                                  padding: EdgeInsets.only(top:0,bottom:5,left:8,right:20),
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:Border.all(color: Colors.deepPurple.withOpacity(.3),width: 4),
                                  ),
                                  child:Row(
                                    children: [
                                      SizedBox(width:30,child:Icon(Icons.email_outlined,size:20,color:Colors.white)),
                                      Expanded(
                                          child:TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter email address';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            controller: emailController,
                                            style: TextStyle(color: Colors.white,) ,
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorStyle: TextStyle(color: Colors.lime,fontWeight: FontWeight.bold),
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                hintText: 'eq, example@mail.com',
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                                                contentPadding: EdgeInsets.only(left:10)
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                if(api.LoginEmailWithPassword)
                                    Padding(padding:EdgeInsets.all(8)),
                                if(api.LoginEmailWithPassword)
                                  Container(
                                  padding: EdgeInsets.only(top:0,bottom:5,left:8,right:20),
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:Border.all(color: Colors.deepPurple.withOpacity(.3),width: 4),
                                  ),
                                  child:Row(

                                    children: [
                                      SizedBox(width:30,child:Icon(Icons.ac_unit,size:20,color:Colors.white)),
                                      Expanded(
                                          child:TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter password';
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            obscureText: _obscureText,
                                            style: TextStyle(color: Colors.white,) ,
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              errorStyle: TextStyle(color: Colors.lime,fontWeight: FontWeight.bold),
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'Password',
                                              hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                                              contentPadding: EdgeInsets.only(left:10)
                                            ),
                                          )
                                      ),
                                      SizedBox(
                                          width:40,
                                          child:OutlineButton(

                                              borderSide: BorderSide.none,
                                              onPressed: (){
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                              child: Icon( _obscureText?Icons.remove_red_eye_outlined :Icons.remove_red_eye,size:20,color: !_obscureText?Colors.white:Colors.deepPurple)
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                if(api.LoginEmailWithPassword)
                                  Container(
                                    alignment: Alignment.center,
                                    child:OutlineButton(
                                      borderSide: BorderSide.none,
                                      onPressed: (){
                                        if(emailController.text.length>0){
                                          messages.waiting(context,title: "Sending password recovery email...");
                                            context.read<AuthenticationProvider>().sendforgetpass(emailController.text).then((value) {
                                              messages.closeWaiting(context);
                                              if(value==true)
                                                  messages.toast("Recovery email sent ",img: Icon(Icons.check_circle,color: Colors.green,size: 35,),showInTop: true,duration: 2,autoclose: true);
                                              else
                                                messages.toast("Error",subtitle: value,img: Icon(Icons.dangerous,color: Colors.red,size:35),showInTop: true,duration: 4,autoclose: true);

                                            });
                                        }
                                        else
                                          messages.toast("Error",subtitle: "Please enter email address!",img: Icon(Icons.dangerous,color: Colors.red,size:35),showInTop: true,duration: 4,autoclose: true);

                                      },
                                      color: Colors.white,
                                      child: Align(alignment: Alignment.topRight, child: Text(" Forgget Password?",style:TextStyle(fontSize: 11,color:Colors.white))),
                                    )
                                ),
                                Divider(color: Colors.white.withOpacity(.2),thickness: 2,height:50),
                                //Padding(padding:EdgeInsets.all(30)),
                                RaisedButton(
                                  splashColor:  Colors.purple,
                                  color: Colors.black,

                                  onPressed: (){
                                      if (_formKey.currentState.validate()) {
                                        messages.waiting(context);
                                        //Scaffold
                                         //   .of(context)
                                          //  .showSnackBar(SnackBar(content: Text('Processing Data')));
                                        if(api.LoginEmailWithPassword) {
                                          context.read<AuthenticationProvider>()
                                              .signUp(
                                            email: emailController.text.trim(),
                                            password: passwordController.text
                                                .trim(),
                                          )
                                              .then((result) {
                                            messages.closeWaiting(context);
                                            if (result == true)
                                              Navigator.pop(context);
                                            else
                                              messages.show(context,
                                                  type: messages.msgtype.info,
                                                  content: result);
                                          });
                                        }
                                        else{
                                          context.read<AuthenticationProvider>().signInWithEmailAndLink(emailController.text.trim()).then((v) {
                                            messages.closeWaiting(context);
                                            if(v==false)
                                                messages.show(context,type: messages.msgtype.error,title: "Error",content: "Can't send verification Link to your email address");
                                            else
                                              messages.show(context,type: messages.msgtype.success,content: "An verification email has been sent to you, Click on the login link in the sent email ");


                                          });

                                        }
                                      }
                                  },
                                  padding: EdgeInsets.only(left:40,top:15,bottom:15,right:40),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center ,
                                    children: [
                                      Icon(Icons.login,size: 18),
                                      Padding(
                                        padding: const EdgeInsets.only(left:10),
                                        child: Text(" Login",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                      )
                  ),
                ]
            ),
          ),
        )
    );
  }
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    emailController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      if( data?.link != null ) {
        handleLink(data?.link);
      }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            final Uri deepLink = dynamicLink?.link;
            handleLink(deepLink);
          }, onError: (OnLinkErrorException e) async {
      });
    }
  }
  void handleLink(Uri link) async {
    if (link != null) {
    final user = await context.read<AuthenticationProvider>().signInWithEmailLink(emailController.text.trim(),link.toString());

      if (user != null) {
      } else {
      }
    } else {
    }
  }
}
