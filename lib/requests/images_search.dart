import 'package:dio/dio.dart';

class ImagesSearch {
  //AIzaSyDldVVUF55rieRk1REpqlDunnIxbYD7-eI 13f2e18ab420f4997 - vlados
  //AIzaSyAH_93iDyGdaNy3MCyV1iOlrIpSc3ng7Ks 8475b061c8325422b
  final _appid = "AIzaSyDldVVUF55rieRk1REpqlDunnIxbYD7-eI" ;
  final _cx = "13f2e18ab420f4997";
  String _cityImageURL = "https://static.tildacdn.com/tild3732-3662-4936-b839-323833633632/0_8d787_5c38e2ad_ori.jpg";

  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  void setCityImageURL(newCityImageUrl) {
    _cityImageURL = newCityImageUrl ?? _cityImageURL;
  }

  String getCityImageURL() {
    return _cityImageURL;
  }

  Future<String> getImage(String str) async {
    Dio dio = Dio(options);
    try {
      Response response = await dio.request(
        'https://www.googleapis.com/customsearch/v1',
        options: Options(method: 'GET'),
        queryParameters: <String, String>{
          'searchType': 'image',
          'q': "$str красивое  фото",
          'key': _appid,
          'cx': _cx,
          'safe': 'active',
        },
      );
      return response.data['items'][0]['link'];
    } on DioError  { return "https://ringtons.ru/wp-content/uploads/2021/04/oshibka.png";}
  }
}