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
}