import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qyuclient/classes/Api.dart' as api;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../classes/authentication_provider.dart';
import 'package:provider/provider.dart';
import '../classes/messages.dart' as messages;
class Auth_phone extends StatefulWidget {
  @override
  _Auth_phoneState createState() => _Auth_phoneState();
}



class _Auth_phoneState extends State<Auth_phone> with CodeAutoFill {
  final TextEditingController phonenumber = TextEditingController();
  String Phone='';
  String Fullnumber ='';
  String isocode = 'UK';
  String appSignature;
  String otpCode;
  bool isButtonEnabled = false;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
    });
  }

  @override
  void initState() {
    super.initState();
    if(api.UserIpInfo!=false && (api.UserIpInfo as Map).containsKey("countryCode"))
      isocode = api.UserIpInfo['countryCode'];
    
    isButtonEnabled = false;
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }
  void proccessPhoneNumber(String value){
    Fullnumber = value;
    PhoneNumber.getRegionInfoFromPhoneNumber(value).then((valuephone){
      isocode = valuephone.isoCode;
      Phone = value.replaceAll("+"+valuephone.dialCode, "");
      setState(() {
        isButtonEnabled = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    //final mq = MediaQuery.of(context);
    //final Map args = ModalRoute.of(context).settings.arguments;
    phonenumber.text=Phone;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset:true,
        body:
        Stack(

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
                  alignment:Alignment.center ,
                  child: SingleChildScrollView(
                      padding: EdgeInsets.only(left:40,right:40),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(.8),
                            radius: 50,
                            child: Icon(Icons.phone,size: 45,color: Colors.purple,),
                          ),
                          Padding(padding:EdgeInsets.all(20)),
                          Text("Join us now !",style: TextStyle(fontSize: 24,color:Colors.white,fontWeight: FontWeight.w700)),
                          Padding(padding:EdgeInsets.all(20)),
                          Container(
                            padding: EdgeInsets.only(top:2,bottom:2,left:8,right:20),
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              //boxShadow: [BoxShadow(color: Colors.purple.withOpacity(.6),blurRadius: 15,spreadRadius: 5)],
                              border:Border.all(color: Colors.deepPurple.withOpacity(.3),width: 4),

                              //color: Color(0xff000000),
                            ),
                            child:InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                Fullnumber = number.phoneNumber;
                              },
                              onInputValidated: (bool value) {
                                  isButtonEnabled = value;
                                  if(value==true) {
                                    proccessPhoneNumber(Fullnumber);
                                  }
                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              //autoFocusSearch: true,
                              locale: '',
                              scrollPadding: EdgeInsets.all(50),
                              spaceBetweenSelectorAndTextField: 0,
                              textAlignVertical: TextAlignVertical.top,

                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.white),
                              textStyle: TextStyle(color:  Colors.white),
                              textAlign: TextAlign.left,
                              initialValue: PhoneNumber(isoCode: isocode),
                              textFieldController: phonenumber,
                              autoFocus: false,
                              formatInput: false,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputBorder: InputBorder.none ,
                            ),
                          ),
                          Container(
                                alignment: Alignment.center,
                                child:OutlineButton(
                                  borderSide: BorderSide.none,
                                  onPressed: (){
                                    final SmsAutoFill _autoFill = SmsAutoFill();
                                    _autoFill.hint.then((value)  {
                                      proccessPhoneNumber(value);
                                    }).catchError((e){isButtonEnabled=false;});
                                  },
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.phone,color:Colors.white,size: 12),
                                      Text(" Current Phone Number Device",style:TextStyle(fontSize: 11,color:Colors.white))
                                    ],
                                  ),
                                )
                          ),Divider(color: Colors.white.withOpacity(.2),thickness: 2,height:50),
                          //Padding(padding:EdgeInsets.all(30)),
                          RaisedButton(
                            splashColor:  Colors.purple,
                            color: isButtonEnabled? Colors.black : Colors.black45,

                            onPressed:
                            !isButtonEnabled?null: (){
                              sendsms(context);
                            },
                            padding: EdgeInsets.only(left:40,top:15,bottom:15,right:40),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center ,
                              children: [
                                Icon(Icons.login,size: 18,color: Colors.white.withOpacity(isButtonEnabled?1:.5)),
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Text(" Login",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w600,color: Colors.white.withOpacity(isButtonEnabled?1:.5))),
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
        )
    );
  }

  final TextEditingController c1 = TextEditingController();
  showAlertDialog(BuildContext pcontext) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("Verify Code",style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold)),
      onPressed: () {
        submitcode(pcontext);
      },
    );

    // set up the AlertDialog
    c1.text= '';
    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: Text("Please Enter Verify Code"),
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PinFieldAutoFill(
                codeLength: 6,
                autofocus: true,
                controller: c1,
                onCodeChanged: (e){
                  if(e.length==6)
                    submitcode(pcontext);
                },

                keyboardType: TextInputType.number,
                onCodeSubmitted: (smscode){
                 /// submitcode();
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
      ],

    );

    // show the dialog
    showDialog(
      context: pcontext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void submitcode(pcontext){
    messages.waiting(pcontext,title:"Waiting to Verify Phone");
    context.read<AuthenticationProvider>().signInwithVerificationId(c1.text.trim(),
        afterLogin: (uid){
          Future.delayed(const Duration(milliseconds: 1200), () {
            Navigator.popUntil(pcontext,ModalRoute.withName('/'));
          });
        },
        failedLogin: (msg){
          Navigator.pop(pcontext);
          c1.text = '';
          messages.toast("Invalid Code",subtitle: "Please check your sms verify code and retry...",showInTop: true,duration: 4);
        });
  }
  void sendsms(pcontext){
    void errormanage(String msg) {
      isButtonEnabled = true;
      messages.closeWaiting(pcontext);
      messages.show(pcontext,title: "Error",content: msg,type: messages.msgtype.error );
    };
    void sendedmsg(String verifationid) {
      messages.closeWaiting(pcontext);
      showAlertDialog(pcontext);
    };
    void errorTimeout(String verifationid) {
      isButtonEnabled = true;
      messages.closeWaiting(pcontext);
      messages.show(pcontext,title: "Error",content: "Timeout",type: messages.msgtype.error );
    };
    context.read<AuthenticationProvider>().signUpwithphone(pcontext,Fullnumber,errormanage, sendedmsg,errorTimeout);
    messages.waiting(pcontext,title:"Waiting to send verify sms ...");
    isButtonEnabled = false;
  }
}
