import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:first_run/data/models/isp.dart';
import 'package:first_run/utils/consts.dart';
import 'package:flutter_web/widgets.dart';
import 'package:http/http.dart' as http;

class MainBloc extends Bloc<MainEvent, AsyncSnapshot<List<Isp>>> {
  @override
  AsyncSnapshot<List<Isp>> get initialState => AsyncSnapshot.nothing();

  @override
  Stream<AsyncSnapshot<List<Isp>>> mapEventToState(MainEvent event) async* {
    print("getting index");
    if (event is RefreshEvent) {
//      Response response;
      yield AsyncSnapshot.withData(ConnectionState.active, null);
      try {
//        response = await dioRepo.get('index');

        print("getting from web");
        var response = await http
            .get(Links.API_URL, headers: {"Content-Type": "application/json"});
        print("got from web ${response.body}");
        var isps = (json.decode(response.body) as List).map((t) {
//          print(t.runtimeType);
          return Isp.fromJson(t);
        }).toList();

        yield AsyncSnapshot.withData(ConnectionState.done, isps);
//      } on DioError catch (dioError) {
//        yield AsyncSnapshot.withError(ConnectionState.done, dioError.message);
      } catch (error) {
        print("got from web ${error}");
        yield AsyncSnapshot.withError(ConnectionState.done, error.toString());
      }
    }
  }
}

class MainEvent {}

class RefreshEvent extends MainEvent {
  RefreshEvent() {
    print("event created");
  }
}
