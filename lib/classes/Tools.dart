import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as Io;
import 'package:image/image.dart';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'Api.dart' as api;
import 'package:crypto/crypto.dart' ;
import 'dart:convert';
import 'package:image/image.dart';
import 'dart:typed_data';

String MD5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
Future<String> getImageNetwork(String url) async {
  if(url!=null && url!=''){
    String hashname = MD5(url);
    String basename = url.split('/').last;
    String NewName = hashname+"-"+basename;
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    String fullpath = path.join(appDir.path, NewName);
    if(await Io.File(fullpath).exists()==false)
      return await SaveImage(url,newName: NewName);
    else
        return fullpath;
  }
  else
      return null;
}

void GotoPage(BuildContext context,Widget page,{double x=1,double y=0}) {
  Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(x, y);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      )
  );
}
Future<String> SaveImage(_url,{newName:false}) async {
  final imageName =  path.basename(_url);
  final appDir = await pathProvider.getApplicationDocumentsDirectory();
  final localPath = path.join(appDir.path, imageName);
  http.get(_url).then((response){
    final imageFile = Io.File(localPath);
    imageFile.writeAsBytes(response.bodyBytes).then((value) => null);
  });
  return localPath;
}
ViewURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
List<int> resizeImage(Io.File file,{width=120}){
  return encodePng(copyResize(decodeImage(file.readAsBytesSync()), width: width));
}