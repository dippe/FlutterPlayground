import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoState.dart';
import 'package:todo_flutter_app/util/memoize.dart';

// simple bar chart example
// Details here: https://google.github.io/charts/flutter/gallery.html
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  static renderProgressChart() => ImmutableView<TodoState>.readOnly(builder: (context, state) {
        return _withData(state.todos.lengthDone(), state.todos.lengthTodo());
      });

  static final _withData = memoize((int done, int todo) {
    final data = [
      new TodoStatus('Todo', todo),
      new TodoStatus('Done', done),
    ];
    return SizedBox(
      height: 100.0,
      width: 100.0,
      child: SimpleBarChart(
        _createSeriesData(data),
        // Disable animations for image tests.
        animate: true,
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultInteractions: true,
      vertical: false,
      // Optionally Set a bar label decorator.
      //          barRendererDecorator: new charts.BarLabelDecorator<String>(
      //            outsideLabelStyleSpec: new charts.TextStyleSpec(color: charts.MaterialPalette.white),
      //          ),
      // configure the text before the bars:
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 8, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(color: charts.MaterialPalette.white))),

      /// Assign a custom style for the measure axis.
      /* optionally set :
          primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.GridlineRendererSpec(

                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 8, // size in Pts.
                      color: charts.MaterialPalette.white),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(color: charts.MaterialPalette.white))),
          */
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TodoStatus, String>> _createSeriesData(data) {
    return [
      new charts.Series<TodoStatus, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TodoStatus todo, _) => todo.stateName,
        measureFn: (TodoStatus todo, _) => todo.number,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class TodoStatus {
  final String stateName;
  final int number;

  TodoStatus(this.stateName, this.number);
}
