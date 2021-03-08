import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class chartpie_audience extends StatelessWidget {
  final List<dynamic> seriesList;
  final bool animate;

  chartpie_audience(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.



  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      dataToSeries(this.seriesList),
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
        new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.auto,showLeaderLines: true),
      ],
      ),


    );
  }
  List<charts.Series<Audiencedatapie, String>> dataToSeries(data){

    List<Audiencedatapie> list = List<Audiencedatapie>.from(data.map((model)=> Audiencedatapie.fromJson(model)));

    return [
      new charts.Series<Audiencedatapie, String>(
        id: 'audience',
        domainFn: (Audiencedatapie audience, _) => audience.title,
        measureFn: (Audiencedatapie audience, _) => audience.percent,
        colorFn: (Audiencedatapie segment, _) => segment.color,
        data: list,
        labelAccessorFn: (Audiencedatapie row, _) => '${row.title}\r\n${row.percent} vote',
      )
    ];
  }
}

class Audiencedatapie {
  final String title;
  final int percent;
  final charts.Color color;

  Audiencedatapie(this.title, this.percent,this.color);

  static Audiencedatapie fromJson(json)  {
    charts.Color color ;
    switch(json['color']){
      case 'violet':color =charts.MaterialPalette.purple.shadeDefault.darker;break;
      case 'black':color =charts.MaterialPalette.black;break;
      default:
        color = charts.MaterialPalette.blue.shadeDefault.darker;
    }
    Audiencedatapie p = new Audiencedatapie(json['title'],json['percent'],color);
    return p;
  }
}