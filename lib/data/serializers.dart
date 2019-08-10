import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:first_run/data/models/isp.dart';

part 'serializers.g.dart';

@SerializersFor([Isp])
final Serializers serializers =
(_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();