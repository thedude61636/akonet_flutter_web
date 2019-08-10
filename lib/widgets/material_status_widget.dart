import 'package:flutter_web/material.dart';
import 'package:first_run/strings.dart';

typedef void Retry();

class StatusWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;

  final Retry action;

  final IconData icon;

  final String actionText;

  final String statusText;

  const StatusWidget(
      {Key key,
      @required this.snapshot,
      this.action,
      this.statusText,
      this.icon = Icons.sentiment_dissatisfied,
      this.actionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget finalWidget = Container();

    if (snapshot.connectionState == ConnectionState.active) {
      finalWidget = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      print("error is = ${snapshot.error.toString()} context is ${context}");
      finalWidget = ListView(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        children: <Widget>[
          Icon(
            this.icon,
          ),
          Text(
            action == null ? statusText ?? "" : LocalStrings.try_again,
            textAlign: TextAlign.center,
          ),
          Text(
            snapshot.error.toString().contains("DioError")
                ? LocalStrings.error_no_network
                : snapshot.error.toString(),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: action != null,
            child: OutlineButton(
              onPressed: action,
              child: Text(this.actionText ?? LocalStrings.retry),
            ),
          )
        ],
      );
    }

//    Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[CircularProgressIndicator()],
//    )
    return Center(
      child: finalWidget,
    );
  }
}
