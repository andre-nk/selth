part of 'service.dart';

class AuthServices{
  static Future<Map> loginAndGetData(simpleAuth.InstagramApi _igApi) async {

    Map _userData;

    _igApi.authenticate().then(
      (simpleAuth.Account _user) async {
        simpleAuth.OAuthAccount user = _user;

        var igUserResponse =
            await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me',
          queryParameters: {
            // Get the fields you need.
            // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
            "fields": "username,id,account_type,media_count,media",
            "access_token": user.token,
          },
        );

        _userData = igUserResponse.data;
      },
    ).catchError(
      (Object e) {
        print(e);
      },
    );

    return _userData;
  }
}