import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:todo_flutter_app/util/memoize.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    final data = [
      new OrdinalSales('Todo', 5),
      new OrdinalSales('Done', 25),
    ];
    return new SimpleBarChart(
      _createSeriesData(data),
      // Disable animations for image tests.
      animate: true,
    );
  }

  static final withData = memoize((int done, int todo) {
    final data = [
      new OrdinalSales('Todo', todo),
      new OrdinalSales('Done', done),
    ];
    return new SimpleBarChart(
      _createSeriesData(data),
      // Disable animations for image tests.
      animate: true,
    );
  });

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultInteractions: true,
      vertical: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSeriesData(data) {
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
