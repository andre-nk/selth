part of 'model.dart';

class MediaModel{
  String caption;
  String id;
  String mediaType;
  String mediaURL;
  String thumbnail;
  String timeStamp;

  MediaModel({this.caption, this.id, this.mediaType, this.mediaURL, this.thumbnail, this.timeStamp}){
    this.caption = caption ?? "";
    this.id = id ?? "";
    this.mediaType = mediaType ?? "";
    this.mediaURL = mediaURL ?? "";
    this.thumbnail = thumbnail ?? "";
    this.timeStamp = timeStamp ?? "";
  }

  Future<bool> setUserMediasJSON(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('userMedias', value);
  }

  Future<String> getUserMediasJSON() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('userMedias');
  }

  Future<bool> setUserCarouselChildrenJSON(String id, String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString(id, value);
  }

  Future<String> getUserCarouselChildrenJSON(String id) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString(id);
  }
}