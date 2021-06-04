part of 'service.dart';

class AuthServices{
  static Future<Map> loginAndGetData(
    simpleAuth.InstagramApi _igApi
  ) async {

    Map _userData;
    UserDataSharedUtility userModel = UserDataSharedUtility();

    await _igApi.authenticate().then(
      (simpleAuth.Account _user) async {
        simpleAuth.OAuthAccount user = _user;

        var refreshResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/access_token',
          queryParameters: {
            "grant_type": "ig_exchange_token",
            "client_secret": Constants.igClientSecret,
            "access_token": user.token,
          },
        );

        var igUserResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me',
          queryParameters: {
            "fields": "username,id,account_type,media_count,media",
            "access_token": refreshResponse.data['access_token'],
          },
        );

        userModel.setUserDataJSON(json.encode(igUserResponse.data));
        userModel.setUserToken(refreshResponse.data['access_token']);
        userModel.setUserTokenExpiration(refreshResponse.data['expires_in'].toString());

        Get.offAndToNamed('/homepage');
      },
    ).catchError(
      (Object e) {
        print(e);
      },
    );

    return _userData;
  }
}