import 'package:flutter/material.dart';
import 'home_page.dart' as home;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import '../classes/messages.dart' as messages;
import '../classes/Api.dart' as api;

class cardsadd extends StatefulWidget {
  String id;
  cardsadd({this.id});
  @override
  _cardsaddState createState() => _cardsaddState(this.id);
}

class _cardsaddState extends State<cardsadd> {
  String id;
  final TextEditingController cardname = TextEditingController();
  final TextEditingController credit_card_number = TextEditingController();
  final TextEditingController cvv = TextEditingController();
  final TextEditingController exmonth = TextEditingController();
  final TextEditingController exyear = TextEditingController();
  final TextEditingController billingadress = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController owner_card = TextEditingController();
  final TextEditingController zipcode = TextEditingController();
  final TextEditingController street = TextEditingController();
  int editid = null;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(this.id!=null ) {
      Map Editrow = home.DataTOPage['cards'][int.parse(this.id)];
      cardname.text = Editrow['card_name'];
      credit_card_number.text = Editrow['credit_card_number'];
      exmonth.text = Editrow['expiration_month'];
      exyear.text = Editrow['expiration_yr'];
      cvv.text = Editrow['cvv'];
      owner_card.text = Editrow['owner_card'];
      state.text = Editrow['billing_state'];
      city.text = Editrow['billing_city'];
      street.text = Editrow['billing_street'];
      zipcode.text = Editrow['billing_postcode'];
      editid =  Editrow['cc_id'];
    }
  }


  _cardsaddState(this.id);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,

        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Payment Card",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(.6)),),
        actions: [
          FlatButton(
            onPressed: (){
              messages.waiting(context,title:"Proccess card ..." );
              if(_formKey.currentState.validate() && allowsave()){
                api.AddCard({
                  "uid":home.DataTOPage['uid'],
                  "id":editid,
                  "credit_card_number": credit_card_number.text,
                  "expiration_month": exmonth.text,
                  "expiration_yr":exyear.text,
                  "cvv":cvv.text,
                  "owner_card":owner_card.text,
                  "billing_state":state.text,
                  "billing_city":city.text,
                  "billing_street":street.text,
                  "billing_postcode":zipcode.text,
                  "card_name":cardname.text,
                }).then((value){
                  messages.closeWaiting(context);
                  if(value['result']==true){
                    if(editid==null)
                      (home.DataTOPage['cards'] as List).add(value['data']);
                    else
                      home.DataTOPage['cards'][int.parse( this.id)] = value['data'];
                    Navigator.pop(context);
                    Navigator.pop(context);
                    messages.toast('Notification',subtitle:value['msg'] ,autoclose: true,duration: 3,img: Icon(Icons.check_circle,size: 35,color: Colors.lightGreen,));
                  }
                  else{
                    messages.show(context,title: "Error",content: value['msg'],type: messages.msgtype.error);
                  }
                });
              }
              else
                  messages.toast('',subtitle:"Please fill all fields!" ,autoclose: true,duration: 3,img: Icon(Icons.dangerous,size: 35,color: Colors.red,));
            },
            child:Row(
              children: [
                Icon(Icons.save,color: Colors.black,),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text((editid==null?"Add":"Update"),style: TextStyle(color: Colors.black),),
                ),
              ],
            )
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left:20,right:20,bottom:25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child:Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:MainAxisAlignment.center ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          Container(
                            padding: EdgeInsets.only(top:10,left:10,right:20,bottom:30),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(209, 145, 238, 1.0),
                                    Color.fromRGBO(167, 135, 243, 1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [BoxShadow(color: Colors.black,blurRadius: 10,spreadRadius: 0,offset: Offset(0,0))],
                              border: Border.all( color: Colors.white.withOpacity(.2))
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Text("Payment card",style: TextStyle(color: Colors.white.withOpacity(.6),fontWeight: FontWeight.w900,fontSize: 18),),
                                Row(
                                    children:[
                                      Expanded( child:DrawInput(context,credit_card_number,"Card Number",TextInputType.number)),
                                      // DrawInput(lname,"Last Name",TextInputType.text)
                                    ]
                                ),
                                Row(
                                  children: [
                                    Expanded(child:DrawInput(context,cvv,"cvc",TextInputType.number)),
                                    Expanded( child:DrawInput(context,exyear,"Year",TextInputType.number)),
                                    Expanded(child:DrawInput(context,exmonth,"Month",TextInputType.number)),
                                  ],
                                ),
                              ],
                            )

                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                              children:[
                                Expanded( child:DrawInput(context,cardname,"Title (optional)",TextInputType.name)),
                                // DrawInput(lname,"Last Name",TextInputType.text)
                              ]
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text("Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 18),),
                          Row(
                              children:[
                                Expanded( child:DrawInput(context,owner_card,"Name on Card",TextInputType.name)),
                                // DrawInput(lname,"Last Name",TextInputType.text)
                              ]
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text(" Billing Address ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("PLEASE ENTER THE ADDRESS THAT THE CARD IS REGISTERED TO. ",style: TextStyle(color: Colors.black.withOpacity(.5),fontSize: 12),),
                          ),
                          Row(
                              children:[
                                Expanded( child:DrawInput(context,street,"Street",TextInputType.streetAddress)),
                                // DrawInput(lname,"Last Name",TextInputType.text)
                              ]
                          ),
                          Row(
                              children:[
                                Expanded( child:DrawInput(context,zipcode,"ZipCode",TextInputType.text)),
                                // DrawInput(lname,"Last Name",TextInputType.text)
                              ]
                          ),
                          Row(
                              children:[
                                Expanded( child:DrawInput(context,city,"City",TextInputType.text)),
                                Expanded( child:DrawInput(context,state,"State",TextInputType.text)),
                                // DrawInput(lname,"Last Name",TextInputType.text)
                              ]
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget DrawInput(context ,controller,title,keyboardtype,{obscuretext:false}){
    return new Padding(
        padding: const EdgeInsets.only(top:15,left:8),
        child:Container(
          decoration: BoxDecoration(
              //color: ,
            borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 2,color: iscardfield(controller)? Colors.white.withOpacity(.7): Colors.black.withOpacity(.2))
          ),
          padding: const EdgeInsets.only(top:0,left:8,bottom:2),
          child: SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                  TextFormField(
                    onTap: controller!=exyear && controller!=exmonth?null:() async {
                      if(controller==exyear)
                        DatePicker.showDatePicker(context,initialDateTime:exyear.text.isEmpty?null:DateTime.tryParse(exyear.text) ,pickerMode: DateTimePickerMode.date,dateFormat: 'yyyy',onConfirm: (d,i){exyear.text=DateFormat('yyyy').format(d);});
                      if(controller==exmonth)
                        DatePicker.showDatePicker(context,initialDateTime:exmonth.text.isEmpty?null:DateTime.tryParse(exmonth.text) ,pickerMode: DateTimePickerMode.date,dateFormat: 'MMMM',onConfirm: (d,i){exmonth.text=DateFormat('MM').format(d);});

                    },
                    validator: (e){
                        if(controller==credit_card_number && credit_card_number.text.length!=16){
                          messages.toast("Credit card number must be 16 digits",img: Icon(Icons.dangerous,size: 40,));
                          return "";
                        }
                        return null;
                    },
                    obscureText:obscuretext ,
                    cursorColor: Colors.deepPurple,
                    onChanged: (e){ setState(() {});},
                    controller: controller,
                    readOnly: controller==exyear || controller==exmonth? true:false,
                    style: TextStyle(fontWeight: iscardfield(controller)?FontWeight.w900:null ,color:iscardfield(controller)?Colors.white: Colors.black,fontSize: 18),
                    decoration: InputDecoration(
                        labelText: title,
                        contentPadding: EdgeInsets.only(left:0,right:30,top:5,bottom: 3),
                        hintStyle: TextStyle(color:Colors.black.withOpacity(.8)),
                        labelStyle: TextStyle(color:iscardfield(controller)?Colors.white.withOpacity(.6):Colors.black.withOpacity(.5),fontSize: 15),
                        enabledBorder: InputBorder.none,// UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(.4),width: 2),),
                        focusedBorder: InputBorder.none,//UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(1),width: 2),),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.red,width: 0

                            )
                        ),
                      errorStyle: TextStyle(height: 0),
                      errorBorder: InputBorder.none,
                    ),
                    keyboardType: keyboardtype,
                  ),
                if(controller.text.length>0)
                  Align(
                    alignment: Alignment.centerRight,

                    child: SizedBox(
                      width: 40,
                      height:40,
                      child: FlatButton(
                          onPressed: (){controller.text = '';setState(() {});},
                          child:Icon(Icons.close_outlined,color:Colors.black,size: 13,)
                      ),
                    ),
                  )

              ],
            ),
          ),
        )
    );
  }

  bool allowsave() {
    return exyear.text.length==4 && exmonth.text.length==2 && owner_card.text.length>0 && street.text.length>0 && city.text.length>0 && state.text.length>0 && zipcode.text.length>0;
  }
  bool iscardfield(field){
    return [credit_card_number,cvv,exmonth,exyear].contains(field) ;
  }
}
