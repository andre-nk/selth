part of 'provider.dart';

final mediaProvider = FutureProvider.family<List<MediaModel>, String>((ref, userToken){
  return MediaServices.fetchUserPost(userToken);
});

final overrideMediaProvider = FutureProvider.family<List<MediaModel>, String>((ref, userToken){
  return MediaServices.overrideFetchUserMedias(userToken);
});

final userProfileProvider = FutureProvider.family<InstaProfileData, String>((ref, username){
    FlutterInsta insta = FlutterInsta();
    return insta.getProfileData(username);
});