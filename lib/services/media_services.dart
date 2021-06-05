part of "service.dart";

class MediaServices{
  static Future<List<MediaModel>> fetchUserPost(String userToken) async {

    List<MediaModel> mediaModelList = [];

    MediaModel().getUserMediasJSON().then((value) async {
      if(value == null){

        print("online");

        var igUserResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me/media',
          queryParameters: {
            "fields": "caption,id,media_type,media_url,thumbnail_url,timestamp",
            "access_token": userToken,
          },
        );

        MediaModel().setUserMediasJSON(jsonEncode(igUserResponse.data));

        igUserResponse.data['data'].forEach((value) async {
          if(value['media_type'] == 'CAROUSEL_ALBUM'){
            var carouselMediaResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
              '/${value['id']}/children',
              queryParameters: {
                "access_token": userToken,
                "fields": "media_type, media_url, thumbnail",
              },
            );

            MediaModel().setUserCarouselChildrenJSON(value['id'], jsonEncode(carouselMediaResponse.data));
          } else {
            mediaModelList.add(MediaModel(
              caption: value['caption'],
              id: value['id'],
              mediaType: value['media_type'],
              thumbnail: value['thumbnail_url'] ?? "",
              timeStamp: value['timestamp'],
              mediaURL: value['media_url']
            ));
          }
        });

      } else {

        print(value);
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

  static Future<List<MediaModel>> overrideFetchUserMedias(String userToken) async {
    List<MediaModel> mediaModelList = [];

    var igUserResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
      '/me/media',
      queryParameters: {
        "fields": "caption,id,media_type,media_url,thumbnail_url,timestamp",
        "access_token": userToken,
      },
    );

    MediaModel().setUserMediasJSON(jsonEncode(igUserResponse.data));

    igUserResponse.data['data'].forEach((value) async {
      if(value['media_type'] == 'CAROUSEL_ALBUM'){
        var carouselMediaResponse = await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/${value['id']}/children',
          queryParameters: {
            "access_token": userToken,
            "fields": "media_type, media_url, thumbnail",
          },
        );

        MediaModel().setUserCarouselChildrenJSON(value['id'], jsonEncode(carouselMediaResponse.data));
      } else {
        mediaModelList.add(MediaModel(
          caption: value['caption'],
          id: value['id'],
          mediaType: value['media_type'],
          thumbnail: value['thumbnail_url'] ?? "",
          timeStamp: value['timestamp'],
          mediaURL: value['media_url']
        ));
      }
    });

    return mediaModelList;
  } 
}