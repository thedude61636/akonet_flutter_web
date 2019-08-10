import 'package:first_run/data/models/isp.dart';

import 'package:first_run/screens/main_screen/main_bloc.dart';
import 'package:first_run/strings.dart';
import 'package:first_run/widgets/material_status_widget.dart';
import 'package:flutter_web/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc();
    bloc.dispatch(RefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalStrings.app_name),
      ),
      body: StreamBuilder<AsyncSnapshot<List<Isp>>>(
        stream: bloc.state,
        builder: (BuildContext context,
            AsyncSnapshot<AsyncSnapshot<List<Isp>>> state) {
          if (state.hasData) {
            print("has data");
            if (state.data.hasData) {
              var ispList = state.data.data;
              return RefreshIndicator(
                  child: ListView.builder(
                    itemCount: ispList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Isp isp = ispList[index];
                      return IspWidget(
                        isp: isp,
                      );
                    },
                  ),
                  onRefresh: () async {
                    bloc.dispatch(RefreshEvent());
                    return;
                  });
            }
            return StatusWidget(
              snapshot: state.data,
              action: () {

                bloc.dispatch(RefreshEvent());
              },
            );
          }
          return StatusWidget(
            snapshot: state,
            action: () {
              bloc.dispatch(RefreshEvent());
            },
          );
        },
      ),
    );
  }
}

typedef OnTap(Isp isp);

class IspWidget extends StatelessWidget {
  final OnTap onTap;

  const IspWidget({
    Key key,
    @required this.isp,
    this.onTap,
  }) : super(key: key);

  final Isp isp;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (onTap != null) this.onTap(isp);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: Image.network(
                  isp.getLogo,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isp.name ?? "",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Text((isp.ping ?? "") == "0"
                          ? LocalStrings.ping_unkown
                          : LocalStrings.ping_value(isp.ping)),
                      Text(LocalStrings.last_down_value(isp.lastDown)),
                      Text(LocalStrings.last_up_value(isp.lastUp)),
                    ],
                  ),
                ),
              ),
              Center(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(isp.status == "1" ? "Up" : "Down"),
                    ),
                    Visibility(
                      visible: isp.status == "0",
                      child: Icon(
                        Icons.info,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
