import 'package:flutter/material.dart';
import '../classes/Api.dart' as api;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:qyuclient/pages/citypicker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../classes/messages.dart' as messages;
import "home_page.dart";
import 'dart:io' as Io;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../classes/authentication_provider.dart';
import 'package:provider/provider.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:api.GoogleApi);
class genreform extends StatefulWidget {
  dynamic DataTOPage= null;
  genreform(this.DataTOPage);
  @override
  _genreformState createState() => _genreformState(this.DataTOPage);
}

class _genreformState extends State<genreform> with CodeAutoFill {

  dynamic DataTOPage= null;
  int selectedtab = 0;
  bool gotohome=false;
  final _formKey = GlobalKey<FormState>();
  String dropdownValue='Male';
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController bday = TextEditingController();
  final TextEditingController pcity = TextEditingController();
  final TextEditingController gendr = TextEditingController();
  final TextEditingController password = TextEditingController();
  Map<String,List> selected={"genres":[],"venues":[]};
  final _SwiperController = new SwiperController();
  String Phone='';
  String Fullnumber ='';
  String isocode = 'UK';
  String appSignature;
  String otpCode;
  bool phoneverified=false;

  _genreformState(this.DataTOPage);

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
    });
  }

  @override
  void initState() {
    super.initState();
    fname.text = ["", null].contains(DataTOPage['data']['fname'])?'':DataTOPage['data']['fname'];
    lname.text = ["", null].contains(DataTOPage['data']['lname'])?'':DataTOPage['data']['lname'];
    pcity.text = ["", null].contains(DataTOPage['data']['preffered_city'])?'':DataTOPage['data']['preffered_city'];
    dropdownValue = ["", null].contains(DataTOPage['data']['gender'])?'Male':DataTOPage['data']['gender'];
    email.text = ["", null].contains(DataTOPage['data']['email'])?'':DataTOPage['data']['email'];
    selected['genres'] = ["", null].contains(DataTOPage['data']['ugenres'])?[]: DataTOPage['data']['ugenres'].toString().split(",").cast<String>();
    selected['venues'] = ["", null].contains(DataTOPage['data']['uvenues'])?[]:DataTOPage['data']['uvenues'].toString().split(",").cast<String>();
    bday.text = ["", null].contains(DataTOPage['data']['birthday'])?'':DataTOPage['data']['birthday'];
    phonenumber.text = ["", null].contains(DataTOPage['data']['phone'])?'':DataTOPage['data']['phone'];
    phoneverified = phonenumber.text.length>0?true:false;
    if(api.UserIpInfo!=false && (api.UserIpInfo as Map).containsKey("countryCode"))
      isocode = api.UserIpInfo['countryCode'];
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return gotohome?HomePage(DataTOPage['data']): Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            shadowColor: Colors.deepPurpleAccent,
            leading: MaterialButton(
              onPressed: selectedtab==0 && DataTOPage['next_step']!='backtohome'?null:(){
                if(selectedtab>0)
                  _SwiperController.previous();
                else
                    Navigator.pop(context);
                },
                child:Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: selectedtab==0 && DataTOPage['next_step']!='backtohome'?Colors.white24: Colors.white,
                )
            ),
            title: Text("Update preference",style:TextStyle(color:Colors.white)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Swiper(
                      fade: .3,
                      loop: false ,
                      onIndexChanged: (index){selectedtab = index;setState(() {});},
                      itemCount: 3,
                      controller:_SwiperController ,

                      pagination: new SwiperPagination(),
                      //control: new SwiperControl(),

                      itemBuilder: (BuildContext contexting,int index){
                        if(index==0){
                          return formprofile();
                        }
                        else if(index==1){
                          return FacoriteList(api.genres,'genres');
                        }
                        return FacoriteList(api.venues,'venues');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:0,bottom:40,left:30,right:30),
                    child: Container(
                      decoration: BoxDecoration(
                      ),
                      width: double.infinity,
                      child: RaisedButton(
                       // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed:isDisableButton()?null: (){
                            if(selectedtab==0 || selectedtab==1)
                              _SwiperController.next();
                            else
                                saveprofile();

                          },
                        child: Ink(
                          decoration: BoxDecoration(
                            color:Colors.black,
                            gradient: selectedtab<2?null: LinearGradient(
                              colors: [
                                isDisableButton()?Color.fromRGBO(167, 135, 243, .6):Color.fromRGBO(167, 135, 243, 1),
                                isDisableButton()?Color.fromRGBO(209, 145, 238, .6): Color.fromRGBO(209, 145, 238, 1.0)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            border: selectedtab==2?null:Border.all(color: Colors.white.withOpacity(isDisableButton()?0.6:1),width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                            alignment:  Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedtab<2? 'Continue':'Done',
                                    textAlign: TextAlign.center,
                                    style:TextStyle(color:isDisableButton()?Colors.white.withOpacity(.6):Colors.white)
                                  ),
                                ),
                                Icon(selectedtab<2?Icons.navigate_next:Icons.check,color: Colors.white.withOpacity(isDisableButton()?0.6:1)),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ),
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
  Widget formprofile(){
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Let us know more about you",style:TextStyle(color:Colors.white,fontSize: 18)),
            Divider(color: Colors.white.withOpacity(.5),height: 30,),
            Expanded(
              child:Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom:40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:MainAxisAlignment.center ,
                    children: [
                      Row(
                          children:[
                            Expanded( child:DrawInput(context,fname,"First Name",TextInputType.text)),
                            Expanded(child:DrawInput(context,lname,"Last Name",TextInputType.text)),
                          ]
                      ),
                      if([null,''].contains( DataTOPage['data']['phone']))
                        Row(
                            children:[
                              Expanded( child:DrawInput(context,phonenumber,"Phone Number",TextInputType.phone)),
                              // DrawInput(lname,"Last Name",TextInputType.text)
                            ]
                        ),
                      if(['',null].contains(DataTOPage['data']['email']))
                        Row(
                            children:[
                              Expanded( child:DrawInput(context,email,"Email Address",TextInputType.emailAddress)),
                              // DrawInput(lname,"Last Name",TextInputType.text)
                            ]
                        ),
                      if(['',null].contains(DataTOPage['data']['email']) && api.LoginEmailWithPassword)
                        Row(
                            children:[
                              Expanded( child:DrawInput(context,password,"Password",TextInputType.visiblePassword,obscuretext: true)),
                              // DrawInput(lname,"Last Name",TextInputType.text)
                            ]
                        ),
                      Row(
                          children:[
                            Expanded( child:DrawInput(context,bday,"Select Date of Birth",TextInputType.text)),
                            // DrawInput(lname,"Last Name",TextInputType.text)
                          ]
                      ),
                      Row(
                          children:[
                            Expanded( child:DrawInput(context,pcity,"Preferred city",TextInputType.text)),
                            // DrawInput(lname,"Last Name",TextInputType.text)
                          ]
                      ),
                      Row(
                          children:[
                            Expanded( child:DrawInput(context,gendr,"Gender",TextInputType.text)),
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
    );
  }
  Widget DrawInput(context ,controller,title,keyboardtype,{obscuretext:false}){
    return new Padding(
        padding: const EdgeInsets.only(top:15,left:8),
        child:Container(
      color: Colors.purple.withOpacity(.3),
      padding: const EdgeInsets.only(top:0,left:8,bottom:2),
      child: SizedBox(
        height: 55,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if(controller==phonenumber)
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  Fullnumber = number.phoneNumber;
                },
                onInputValidated: (bool value) {
                  if(value==true) {
                    proccessPhoneNumber(Fullnumber);
                  }
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                autoFocusSearch: true,
                locale: '',
                scrollPadding: EdgeInsets.all(50),
                spaceBetweenSelectorAndTextField: 0,
                textAlignVertical: TextAlignVertical.top,

                inputDecoration: InputDecoration( border: InputBorder.none, hintText: 'Phone Number', hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),


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
            if(controller==gendr)
              DropdownButton<String>(
                value: dropdownValue,
                //icon: Icon(Icons.arrow_circle_down),

                iconSize: 24,
                elevation: 16,
                style: TextStyle( color: Colors.white),
                focusColor: Colors.white,
                dropdownColor: Colors.purple,


                underline: null,//Container(height: 2,color: Colors.deepPurpleAccent,),
                onChanged: (String newValue) {setState(() {dropdownValue = newValue;});},
                items: <String>['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            if(controller!=gendr && controller!=phonenumber)
            TextFormField(
              onTap: controller!=bday && controller!=pcity?null:() async {
                  if(controller==bday)
                      DatePicker.showDatePicker(context,initialDateTime:bday.text.isEmpty?null:DateTime.tryParse(bday.text) ,pickerMode: DateTimePickerMode.date,dateFormat: 'dd MMMM yyyy',onConfirm: (d,i){bday.text=DateFormat('dd MMMM yyyy').format(d); setState(() {});});
                  else if(controller == pcity){
                    if(api.city_picker_type!='overlay') {
                          final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => citypicker()),
                        );
                        if(result!=null && (result is Map) && result.containsKey('city')) {
                          pcity.text = result['city'];
                          setState(() {});
                        }
                    }
                    else {
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
                          pcity.text =
                              detail.result.addressComponents[0].longName;
                          messages.closeWaiting(context);
                          setState(() {});
                        });
                      }).catchError((error) {
                        messages.closeWaiting(context);
                      });
                    }
                  }
              },
              obscureText:obscuretext ,
              cursorColor: Colors.white,
              onChanged: (e){ setState(() {});},
              controller: controller,
              readOnly: controller==bday || controller==pcity? true:false,
              style: TextStyle(color:Colors.white,fontSize: 18),
              decoration: InputDecoration(
                labelText: title,
                contentPadding: EdgeInsets.only(left:0,right:30,top:5,bottom: 3),
                hintStyle: TextStyle(color:Colors.white.withOpacity(.8)),
                labelStyle: TextStyle(color:Colors.white.withOpacity(.5),fontSize: 15),
                enabledBorder: InputBorder.none,// UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(.4),width: 2),),
                focusedBorder: InputBorder.none,//UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(1),width: 2),),
                border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.red,width: 0

                      )
                  )
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
                  child:Icon(Icons.close_outlined,color:Colors.white,size: 13,)
                ),
              ),
            )

          ],
        ),
      ),
    )
    );
  }
  Widget FacoriteList(List data,String titlepage){
    return new Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:18.0,bottom: 0,left:20,right:20),
          child: Text(
            titlepage=='genres'?"Your favourite music genre...":
                "Your favourite venue type...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        Expanded(
          child: Container(
              padding: EdgeInsets.all(20),
              child:GridView.count(
                shrinkWrap: true,
                // crossAxisCount is the number of columns
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                // This creates two columns with two items in each column
                children: List.generate(data.length, (indexing) {
                  String val = data[indexing]['id'].toString();
                  bool  checked = selected[titlepage].indexOf(val)>=0;
                  return InkWell(
                    onTap: (){
                      if(checked)
                        selected[titlepage].remove(val);
                      else
                        selected[titlepage].add(val);
                      setState(() {
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,

                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [BoxShadow(color: Colors.white12,blurRadius: 2,spreadRadius: 2)]
                        ),
                        child: Stack(
                            fit: StackFit.expand,
                            children:[
                              Image.file(
                                   new Io.File(data[indexing]['img']),
                                  fit: BoxFit.cover
                              ),

                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(checked?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined,color: Colors.white60.withOpacity(checked?1:.3),),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(checked?0:0.6),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data[indexing]['name'],
                                      style: TextStyle(
                                          color: checked? Colors.white:Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          shadows: [Shadow(color: Colors.black,blurRadius: 5)]
                                      ),
                                    ),
                                    if((data[indexing] as Map).containsKey("desc"))
                                      Text(
                                        data[indexing]['desc'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            shadows: [Shadow(color: Colors.black,blurRadius: 3)]
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  );
                }),
              )
          ),
        )
      ],
    );
  }

  bool allowformnext(){
    if ( fname.text.isNotEmpty && lname.text.isNotEmpty && pcity.text.isNotEmpty && bday.text.isNotEmpty &&
        (DataTOPage['data']['email']!=null || email.text.isNotEmpty) &&
        (!['',null].contains(DataTOPage['data']['email']) || (password.text.isNotEmpty || api.LoginEmailWithPassword==false )) &&
        (!['',null].contains(DataTOPage['data']['phone']) || phonenumber.text.isNotEmpty)
    )
      return true;
    return false;
  }

  bool allowSave(){
    if(selectedtab==2 && (selected['genres'].length==0 || selected['venues'].length==0 || !allowformnext()))
      return false;
    return true;
  }

  bool isDisableButton(){
    return (selectedtab==0 && !allowformnext()) || (selectedtab==1 && selected['genres'].length==0) || (selectedtab==2 && !allowSave());
  }


  void saveprofile(){

    messages.waiting(context, title: 'Proccess data ... ');
    api.saveProfile({
      "uid": DataTOPage['data']['uid'],
      "genres": selected['genres'].join(","),
      "venues": selected['venues'].join(","),
      "fname": fname.text,
      "lname": lname.text,
      "bdate": bday.text,
      'phone':['',null].contains(DataTOPage['data']['phone'])? Fullnumber: null,
      "pcity": pcity.text,
      "email": [null,''].contains(DataTOPage['data']['email'] )?email.text: null,
      "pass": [null,''].contains(DataTOPage['data']['email'] ) && api.LoginEmailWithPassword? password.text: null,
      'gender': dropdownValue,
      'timezone':api.UserIpInfo!=false? api.UserIpInfo['timezone']:api.default_timezone,
    }).then((value) {
      messages.closeWaiting(context);
      if (value['result'] == true) {
        DataTOPage['data'] = value['data'];
        if (DataTOPage['next_step'] != 'backtohome') {
          setState(() {
            gotohome = true;
          });
        }
        else
          Navigator.pop(context,value['data']);
      }
      else {
        messages.show(context, title: "Error",type: messages.msgtype.error,content: value['msg']);
        if(value['code']==10)
          context.read<AuthenticationProvider>().signOut().then((v) {
            Navigator.popUntil(context,ModalRoute.withName('/'));
          });
      }
    });
  }

}
