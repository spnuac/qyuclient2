library api;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Tools.dart' as tools;
import 'dart:io';


String ApiUrl = 'https://qyu.grub24.co.uk/Api/';
String FCM_id = '';
bool isLoggedIn = false;
String apikey = 'Gyi5wj2jflsloknbbz87wye873eqyqey82';
String title = '';
bool LoginWithUserPass = false;
bool LoginWithPhone = false;
String PolicyPageId = '';
String LogoUrl = null;
bool LoginEmailWithPassword = false;
String splashLogoUrl = null;
String default_timezone =null;
List genres =[];
List venues  =[];
List votes = [];
String GoogleApi = "AIzaSyCRdiytSaBSYcsqu9tnUgBaOpakEW2-6nM";
String city_picker_type = 'overlay';
dynamic UserIpInfo =false;
/********* SharedPreferences ***************************/

SharedPreferences instancePreferences=null;
Future<void> initPreferences() async {
  SharedPreferences.setMockInitialValues({});
  if(instancePreferences==null)
      instancePreferences = await SharedPreferences.getInstance();
}
void setLocalData(String name,dynamic value){
  initPreferences();
  instancePreferences.setString(name, value );
}
dynamic getLocalData(String name)  {
  initPreferences();
  return instancePreferences.get(name);
}

/********* API FUNCTIONS ***************************/

String getLogo() {
  if (LogoUrl != null)
    return LogoUrl;
  else if (splashLogoUrl != null) return splashLogoUrl;
  return '';
}

Future<dynamic> getvoteEvent(datapost) async {
  dynamic getvoteEvent = await apiRequest('getvoteEvent',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getvoteEvent != false && getvoteEvent['code'] == 1)
    return result = {"result":true,"msg":getvoteEvent['msg'],"data":getvoteEvent['data']};
  else if(getvoteEvent!= false )
    return result = {"result":false,"msg":getvoteEvent['msg'],"data":null};
  return result;
}
Future<dynamic> getvoteTrack(datapost) async {
  dynamic getvoteTrack = await apiRequest('getvoteTrack',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getvoteTrack != false && getvoteTrack['code'] == 1)
    return result = {"result":true,"msg":getvoteTrack['msg'],"data":getvoteTrack['data']};
  else if(getvoteTrack!= false )
    return result = {"result":false,"msg":getvoteTrack['msg'],"data":null};
  return result;
}
Future<dynamic> getEventData(datapost) async {
  dynamic getEventData = await apiRequest('getEventData',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getEventData != false && getEventData['code'] == 1)
    return result = {"result":true,"msg":getEventData['msg'],"data":getEventData['data']};
  else if(getEventData!= false )
    return result = {"result":false,"msg":getEventData['msg'],"data":null};
  return result;
}
Future<dynamic> Checkout(datapost) async {
  dynamic Checkout = await apiRequest('Checkout',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (Checkout != false && Checkout['code'] == 1)
    return result = {"result":true,"msg":Checkout['msg'],"data":Checkout['data']};
  else if(Checkout!= false )
    return result = {"result":false,"msg":Checkout['msg'],"data":null};
  return result;
}
Future<dynamic> getAllEventUser(datapost) async {
  dynamic getAllEventUser = await apiRequest('getAllEventUser',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getAllEventUser != false && getAllEventUser['code'] == 1)
    return result = {"result":true,"msg":"OK","data":getAllEventUser['data']};
  else if(getAllEventUser!= false )
    return result = {"result":false,"msg":getAllEventUser['msg'],'data':null};
  return result;
}
Future<dynamic> getFavorite(datapost) async {
  dynamic getFavorite = await apiRequest('getFavorite',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getFavorite != false && getFavorite['code'] == 1)
    return result = {"result":true,"msg":"OK","data":getFavorite['data']};
  else if(getFavorite!= false )
    return result = {"result":false,"msg":getFavorite['msg'],'data':null};
  return result;
}
Future<dynamic> getEvents(datapost) async {
  dynamic getEvents = await apiRequest('getEvents',datapost);
  Map result = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (getEvents != false && getEvents['code'] == 1)
    return result = {"result":true,"msg":"OK","data":getEvents['data']};
  else if(getEvents!= false )
    return result = {"result":false,"msg":getEvents['msg'],'data':null};
  return result;
}
Future<dynamic> checkPhonenumber(phonenumber,uid) async {
  dynamic checkPhonenumber = await apiRequest('checkPhonenumber', {"phone":phonenumber,"uid":uid});
  Map nextstep = {"result":false,"msg":"Can't connect to server !\r\nplease check your internet connection."};
  if (checkPhonenumber != false && checkPhonenumber['code'] == 1)
    return nextstep = {"result":true,"msg":"OK"};
  else if(checkPhonenumber!= false )
    return nextstep = {"result":false,"msg":checkPhonenumber['msg']};
  return nextstep;
}
Future<dynamic> saveProfile(userdata) async {
  dynamic saveprofile = await apiRequest('saveProfiledata', userdata);
  Map nextstep = {"code":"0","result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (saveprofile != false && saveprofile['code'] == 1)
    return {"code":"1","result":true,"msg":saveprofile['msg'],"data":saveprofile['data']};
  else if(saveprofile!= false )
    return {"code":saveprofile['code'],"result":false,"msg":saveprofile['msg'],"data":null};
  return nextstep;
}

Future<dynamic> DeleteCard(cid,uid) async {
  dynamic deleteCard = await apiRequest('deleteCard',{"uid":uid,"id":cid} );
  Map nextstep = {"code":"0","msg":"Can't connect to server !\r\nplease check your internet connection."};
  if (deleteCard != false && deleteCard['code'] == 1)
    return {"code":"1","msg":deleteCard['msg']};
  else if(deleteCard!= false )
    return {"code":deleteCard['code'],"msg":deleteCard['msg']};
  return nextstep;
}
Future<dynamic> addRemoveFavorite(uid,id) async {
  dynamic addRemoveFavorite = await apiRequest('addRemoveFavorite', {"uid":uid,"id":id});
  Map nextstep = {"code":"0","result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (addRemoveFavorite != false && addRemoveFavorite['code'] == 1)
    return {"code":"1","result":true,"msg":addRemoveFavorite['msg'],"data":addRemoveFavorite['data']};
  else if(addRemoveFavorite!= false )
    return {"code":addRemoveFavorite['code'],"result":false,"msg":addRemoveFavorite['msg'],"data":null};
  return nextstep;
}
Future<dynamic> AddCard(userdata) async {
  dynamic AddCard = await apiRequest('AddCard', userdata);
  Map nextstep = {"code":"0","result":false,"msg":"Can't connect to server !\r\nplease check your internet connection.","data":null};
  if (AddCard != false && AddCard['code'] == 1)
    return {"code":"1","result":true,"msg":AddCard['msg'],"data":AddCard['data']};
  else if(AddCard!= false )
    return {"code":AddCard['code'],"result":false,"msg":AddCard['msg'],"data":null};
  return nextstep;
}
Future<Map> proccessUser(userdata) async {
    dynamic proccessUser = await apiRequest('proccessUser', userdata);
    Map nextstep = {"next_step":"blocked","msg":"Your account suspended , please contact with administrator !","data":null};
    if (proccessUser != false && proccessUser['data'] !='' && (proccessUser['data'] as Map).containsKey("next_step"))
      nextstep =  {"next_step":proccessUser['data']['next_step'],"msg":proccessUser['msg'],"data":proccessUser['data']['user']};
    return nextstep;
}
Future<dynamic> getReport(id) async {
  dynamic getPolicydata = await apiRequest('reportAudience', {"eid":id});
  if (getPolicydata != false && getPolicydata['code'] == 1) {
    return getPolicydata['data'];
  }
  return false;
}
Future<dynamic> getuser(id,city) async {
  dynamic getuser = await apiRequest('getuser', {"uid":id,'city':city});
  if (getuser != false && getuser['code'] == 1) {
    return getuser['data'];
  }
  return false;
}
Future<dynamic> getPolicy() async {
  dynamic getPolicydata = await apiRequest('getPolicy', {});
  if (getPolicydata != false && getPolicydata['code'] == 1) {
    return getPolicydata;
  }
  return false;
}
Future<dynamic> getHelp() async {
  dynamic getPolicydata = await apiRequest('gethelp', {});
  if (getPolicydata != false && getPolicydata['code'] == 1) {
    return getPolicydata;
  }
  return false;
}
Future<dynamic> setting() async {
  dynamic settings = await apiRequest('setting', {});
  if (settings != false && settings['code'] == 1) {
    UserIpInfo = settings['data']['ipinfo'];
    title = settings['data']['titleSite'];
    LoginWithPhone = settings['data']['LoginWithPhone'];
    LoginWithUserPass = settings['data']['LoginWithUserPass'];
    PolicyPageId = settings['data']['PolicyPageId'];
    LogoUrl = settings['data']['LogoUrl'];
    default_timezone = settings['data']['default_timezone'];
    GoogleApi = settings['data']['googleplaceapp_api_key'];
    splashLogoUrl = settings['data']['splashlogo'];
    city_picker_type = settings['data']['city_picker_type'];
    LoginEmailWithPassword = settings['data']['LoginEmailWithPassword']=="1";

    if((settings['data']['list_vote_names'] as List).length>0){
      votes = settings['data']['list_vote_names'];
    }
    if((settings['data']['venues'] as List).length>0){
      for(dynamic item in settings['data']['venues']){

        item['img'] = await tools.getImageNetwork(item['img']);
      }
      venues = settings['data']['venues'];
    }
    if((settings['data']['genres'] as List).length>0){
      for(dynamic item in settings['data']['genres']){
        item['img'] =  await tools.getImageNetwork(item['img']);
      }
      genres = settings['data']['genres'];
    }
    return settings;
  }
  return false;
}

/********* API REQUESTS ***************************/

dynamic Get(String url, Map<String, dynamic> jsonMap) async {
  try {
    http.Response response = await http.get(url, headers: {
      // "Content-Type": "application/jsonp; charset=utf-8",
    }).timeout(Duration(seconds: 30));
    return json.decode(response.body);
  } catch (e) {
    return false;
  }
}
dynamic apiRequest(String url, Map<String, dynamic> jsonMap) async {
  jsonMap['apikey'] = apikey;
  try {
    http.Response response = await http
        .post(
          ApiUrl + url,
          headers: {
            "Content-Type": "application/json; charset=utf-8",
          },
          body: json.encode(jsonMap),
        )
        .timeout(Duration(seconds: 30));
    return json.decode(response.body);
  } catch (e) {
    return false;
  }
}
