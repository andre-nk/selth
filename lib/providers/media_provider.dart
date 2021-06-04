part of 'provider.dart';

final mediaProvider = FutureProvider.family<List<MediaModel>, String>((ref, userToken){
  return MediaServices.fetchUserPost(userToken);
});

final userProfileProvider = FutureProvider.family<InstaProfileData, String>((ref, username){
    FlutterInsta insta = FlutterInsta();
    return insta.getProfileData(username);
});