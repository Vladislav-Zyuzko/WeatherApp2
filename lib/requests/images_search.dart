import 'package:dio/dio.dart';
import 'dart:math';

class ImagesSearch {
  //AIzaSyDldVVUF55rieRk1REpqlDunnIxbYD7-eI 13f2e18ab420f4997 - vlados
  //AIzaSyAH_93iDyGdaNy3MCyV1iOlrIpSc3ng7Ks 8475b061c8325422b
  final _appid = "AIzaSyAH_93iDyGdaNy3MCyV1iOlrIpSc3ng7Ks" ;
  final _cx = "8475b061c8325422b";

  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  Future<String> getImage(String str) async {
    print(str);
    Dio dio = Dio(options);
    try {
      Response response = await dio.request(
        'https://www.googleapis.com/customsearch/v1',
        options: Options(method: 'GET'),
        queryParameters: <String, String>{
          'searchType': 'image',
          'q': str,
          'key': _appid,
          'cx': _cx
        },
      );
      Random random = Random();
      print(response.data['items'][0]['link']);
      return response.data['items'][0]['link'];
    } on DioError  { return "https://ringtons.ru/wp-content/uploads/2021/04/oshibka.png";}
  }
}