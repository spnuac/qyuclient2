import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class chartbar_audience extends StatelessWidget {
  final List<dynamic> seriesList;
  final bool animate;

  chartbar_audience(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.



  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: new charts.BarChart(
        dataToSeries(this.seriesList),
        animate: animate,
        defaultRenderer: new charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30),

        ),

      ),
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF757DF9), Color(0xFFD691EC)],
          stops: [
            0.0,
            1.0,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
    );
  }
  List<charts.Series<Audiencedata, String>> dataToSeries(data){

    List<Audiencedata> list = List<Audiencedata>.from(data.map((model)=> Audiencedata.fromJson(model)));

    return [
      new charts.Series<Audiencedata, String>(
        id: 'audience',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Audiencedata audience, _) => audience.title,
        measureFn: (Audiencedata audience, _) => audience.percent,
        data: list,
      )
    ];
  }
}

class Audiencedata {
  final String title;
  final int percent;

  Audiencedata(this.title, this.percent);

  static Audiencedata fromJson(json)  {
  Audiencedata p = new Audiencedata(json['title'],json['percent']);
  return p;
  }
}