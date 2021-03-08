library menubar;
import 'package:flutter/material.dart';
import '../home_page.dart';
enum items{home,search,upcoming,insight,mysets}
typedef ClickItems = void Function(items item);
items selecteditem=items.home;
_menubarState menubarcontext ;


class menubar extends StatefulWidget {
  dynamic DataTOPage;
  ClickItems onClickItems;
  menubar({this.onClickItems,this.DataTOPage,});

  @override
  _menubarState createState(){
    menubarcontext = _menubarState(onClickItems: this.onClickItems,DataTOPage:this.DataTOPage  );
    return menubarcontext;
  }
}
class _menubarState extends State<StatefulWidget> {
  dynamic DataTOPage;
  ClickItems onClickItems;
  _menubarState({ this.onClickItems,this.DataTOPage});
  @override
  Widget build(BuildContext context) {
    print(selecteditem);
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,

      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, ),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    selecteditem = items.home;
                    onClickItems(selecteditem);
                    setState(() {});
                  },
                  padding: EdgeInsets.only(left:0,right:0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard,size: 28, color: selecteditem ==items.home? Colors.black:Colors.black.withOpacity(.5)),
                        Text("Home",style: TextStyle(fontSize: 12, color: selecteditem ==items.home? Colors.black:Colors.black.withOpacity(.5)))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    selecteditem = items.search;
                    onClickItems(selecteditem);
                  },
                  padding: EdgeInsets.only(left:0,right:0),
                  child: SizedBox(width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon( Icons.search,size: 28,  color: selecteditem ==items.search? Colors.black:Colors.black.withOpacity(.5)),
                        Text("Search",style: TextStyle(fontSize: 12,color: selecteditem ==items.search? Colors.black:Colors.black.withOpacity(.5)))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child:Text("Q'it")
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    selecteditem = items.insight;
                    onClickItems(selecteditem);
                    setState(() {});
                  },
                  padding: EdgeInsets.only(left:0,right:0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_chart_outlined,size: 28,  color: selecteditem ==items.insight? Colors.black:Colors.black.withOpacity(.5)),
                        Text("Insights",style: TextStyle(fontSize: 12,color: selecteditem ==items.insight? Colors.black:Colors.black.withOpacity(.5)))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    selecteditem = items.mysets;
                    onClickItems(selecteditem);
                    setState(() {});
                  },
                  padding: EdgeInsets.only(left:0,right:0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.my_library_music_sharp,size: 28,  color: selecteditem ==items.mysets? Colors.black:Colors.black.withOpacity(.5)),
                        Text("My Sets",style: TextStyle(fontSize: 12,color: selecteditem ==items.mysets? Colors.black:Colors.black.withOpacity(.5)))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
