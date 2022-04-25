import 'package:dio/dio.dart';

_cascade(){
  /// Kotlinでいうapplyのような記法
  /// ..の前に実行された関数の返り値が最終的は変数として代入される
     final Dio cascadeDio = Dio()..interceptors.add(LogInterceptor(responseBody: true));
}