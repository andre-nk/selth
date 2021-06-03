part of 'provider.dart';

final mediaProvider = FutureProvider.family<List<MediaModel>, String>((ref, userToken){
  return MediaServices.fetchUserPost(userToken);
});