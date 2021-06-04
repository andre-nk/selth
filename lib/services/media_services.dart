part of "service.dart";

class MediaServices{
  static Future<List<MediaModel>> fetchUserPost(String userToken) async {

    List<MediaModel> mediaModelList = [];

    MediaModel().getUserMediasJSON().then((value) async {

      print(value);

      if(value == null){

        var igUserResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me/media',
          queryParameters: {
            // Get the fields you need.
            // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
            "fields": "caption,id,media_type,media_url,thumbnail_url,timestamp",
            "access_token": userToken,
          },
        );

        MediaModel().setUserMediasJSON(jsonEncode(igUserResponse.data));

        igUserResponse.data['data'].forEach((value){
          mediaModelList.add(MediaModel(
            caption: value['caption'],
            id: value['id'],
            mediaType: value['media_type'],
            thumbnail: value['thumbnail_url'] ?? "",
            timeStamp: value['timestamp'],
            mediaURL: value['media_url']
          ));
        });
      } else {
        Map igUserResponse = jsonDecode(value);

        igUserResponse['data'].forEach((value){
          mediaModelList.add(MediaModel(
            caption: value['caption'],
            id: value['id'],
            mediaType: value['media_type'],
            thumbnail: value['thumbnail_url'] ?? "",
            timeStamp: value['timestamp'],
            mediaURL: value['media_url']
          ));
        });
      }
    });

    return mediaModelList;
  } 
}