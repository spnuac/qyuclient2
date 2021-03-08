import 'package:flutter/material.dart';
import '../classes/Api.dart' as api;

class venueform extends StatefulWidget {
  dynamic DataTOPage= null;
  venueform(this.DataTOPage);
  @override
  _venueformState createState() => _venueformState(this.DataTOPage);
}

class _venueformState extends State<venueform> {

  dynamic DataTOPage= null;
  _venueformState(this.DataTOPage);

  @override
  Widget build(BuildContext context) {
    print(this.DataTOPage);
    List data = api.venues;
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child:GridView.count(
              // crossAxisCount is the number of columns
              crossAxisCount: 2,
              // This creates two columns with two items in each column
              children: List.generate(1, (index) {
                return Center(
                  child: Text(
                    data[index]['name'],
                    style: Theme.of(context).textTheme.headline,
                  ),
                );
              }),
            )
        )
    );
  }
}
