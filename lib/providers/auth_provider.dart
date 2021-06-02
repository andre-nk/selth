part of 'provider.dart';

final authProvider = FutureProvider.family<Map, simpleAuth.InstagramApi>((ref, igApi) async {
  return AuthServices.loginAndGetData(igApi);
});