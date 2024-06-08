
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:oauth_dio/oauth_dio.dart';
import 'package:sapride/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService{

  static final Dio dio = Dio();


  final OAuth oauth = OAuth(
      tokenUrl: Constants.tokenURL,
      clientId: Constants.clientID,
      clientSecret: Constants.clientSecret,
  );



  Future<bool> refreshToken() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String refToken = sharedPreferences.getString("refToken")??'';
    log(refToken,name: 'refToken');
    if(refToken.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime expDate = DateTime.parse(sharedPreferences.getString('tokenExp')??'');
      if(now.isAtSameMomentAs(expDate) || now.isAfter(expDate)){
        try {
          OAuthToken oAuthToken = await oauth.requestTokenAndSave(
              RefreshTokenGrant(
                refreshToken: refToken,
              )
          );

          if(oAuthToken.accessToken == null){
            sharedPreferences.setString('accToken', '');
            sharedPreferences.setString('refToken', '');
            sharedPreferences.setString('tokenExp', '');
            return false;
          }

            sharedPreferences.setString('accToken', oAuthToken.accessToken.toString());
            sharedPreferences.setString('refToken', oAuthToken.refreshToken.toString());
            sharedPreferences.setString('tokenExp', oAuthToken.expiration.toString());
        }  catch (e) {
          // TODO
          log(e.toString(),name: 'error');
          sharedPreferences.setString('accToken', '');
          sharedPreferences.setString('refToken', '');
          sharedPreferences.setString('tokenExp', '');
          return false;
        }
      }
      return true;
    }
    return false;
  }


  Future<bool> getToken({required String userName,required String password}) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String token = sharedPreferences.getString("accToken")??'';

    log(token);
    if(token.isEmpty){
      OAuthToken oAuthToken;
      log(userName);

      try {
        oAuthToken = await oauth.requestTokenAndSave(
            PasswordGrant(
                username: userName,
                password: password
            )
        ).timeout(const Duration(seconds: 30));
      } catch (e) {
        log(e.toString());
        return false;
      }
      log(oAuthToken.accessToken.toString(),name: 'accToken');
      log(oAuthToken.refreshToken.toString(),name: 'refToken');
      log(oAuthToken.expiration.toString(),name: 'exp');

      sharedPreferences.setString('accToken', oAuthToken.accessToken.toString());
      sharedPreferences.setString('refToken', oAuthToken.refreshToken.toString());
      sharedPreferences.setString('tokenExp', oAuthToken.expiration.toString());
      return true;

    }
    return false;
  }

  static Future<dynamic> getData({required String endPoint})async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("accToken")??'';
    String url = "${Constants.baseURL}$endPoint";
    log(url,name: 'URL');
    final Response response;
    try {
      response = await dio.getUri(Uri.parse(url),options: Options(
          contentType: 'application/json',
          headers: {
            'Authorization':'Bearer $token'
          }
      ));
      log(response.requestOptions.path.toString());
      return response.data;
    }  catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<dynamic> postData({required String endPoint,required Map<String,dynamic> data})async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("accToken")??'';
    String url = '${Constants.baseURL}$endPoint';
    log(url,name: 'URL');
    log(jsonEncode(data),name: 'Data');
    final Response response = await dio.post(url,data: jsonEncode(data),options: Options(
        contentType: 'application/json',
        headers: {
          'Authorization':'Bearer $token'
        }
    ));
    return response.data;
  }

  static Future<dynamic> patchData({required String endPoint,required Map<String,dynamic> data})async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("accToken")??'';
    String url = '${Constants.baseURL}$endPoint';
    log(url,name: 'URL');
    log(jsonEncode(data),name: 'Data');
    final Response response = await dio.patch(url,data: jsonEncode(data),options: Options(
        contentType: 'application/json',
        headers: {
          'Authorization':'Bearer $token'
        }
    ));
    return response.data;
  }

  static Future<dynamic> deleteData({required String endPoint})async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("accToken")??'';
    String url = "${Constants.baseURL}$endPoint";
    log(url,name: 'URL');
    final Response response;
    try {
      response = await dio.deleteUri(Uri.parse(url),options: Options(
          contentType: 'application/json',
          headers: {
            'Authorization':'Bearer $token'
          }
      ));
      log(response.requestOptions.path.toString());
      return response.data;
    }  catch (e) {
      log(e.toString());
    }
    return null;
  }

}