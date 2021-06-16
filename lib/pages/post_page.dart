part of "pages.dart";

class PostPage extends StatefulWidget {

  final int index;
  final int length;
  final String photoURL;
  final String username;
  final List<MediaModel> medias;

  const PostPage({Key key, this.username, this.index, this.length, this.medias, this.photoURL}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  ScrollController scrollController = ScrollController();
  FlickMultiManager flickMultiManager;

  @override
  void initState() { 
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;  
    TextStyle subtitleTextStyle = Theme.of(context).textTheme.subtitle1;
    TextStyle subtitleBoldTextStyle = Theme.of(context).textTheme.subtitle2;
    DateFormat _dateFormat = DateFormat('MMMM dd, yyyy');
    DateFormat _sameYearDateFormat = DateFormat('MMMM dd');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(
        widget.index * (size.width + size.height * 0.2),
      );
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).accentColor,
          onPressed: (){
            Get.back();
          },
        ),
        title: Text(
          "Posts",
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: VisibilityDetector(
        key: ObjectKey(flickMultiManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            flickMultiManager.pause();
          }
        },
        child: Container(
          height: size.height,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: widget.medias.length,
            itemBuilder: (context, index){

              TransformationController _transformationController = TransformationController();
              Matrix4 initialControllerValue;

              return Container(
                height: size.width + size.height * 0.2,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        size.height * 0.015
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(widget.photoURL),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          Text(widget.username, style: subtitleBoldTextStyle),
                        ],
                      ),
                    ),
                    InteractiveViewer(
                      transformationController: _transformationController,
                      onInteractionStart: (details){
                        initialControllerValue = _transformationController.value;
                      },
                      onInteractionEnd: (details){
                        _transformationController.value = initialControllerValue;
                      },
                      maxScale: 1.5,
                      clipBehavior: Clip.none,
                      child: Container(
                        height: size.width,
                        width: size.width,
                        child: widget.medias[index].mediaType == "IMAGE"
                          ? Image(
                              image: NetworkImage(widget.medias[index].mediaURL),
                              fit: BoxFit.cover
                            )
                          : widget.medias[index].mediaType == "VIDEO"
                            ? FlickMultiPlayer(
                                url: widget.medias[index].mediaURL,
                                flickMultiManager: flickMultiManager,
                                image: widget.medias[index].thumbnail,
                              )
                            : FutureBuilder(
                                future: MediaModel().getUserCarouselChildrenJSON(widget.medias[index].id),
                                builder: (context, response){
                                  List carouselChildren = jsonDecode(response.data)['data'];
                                  List<MediaModel> carouselChildrenList = [];
                    
                                  carouselChildren.forEach((media) {
                                    carouselChildrenList.add(MediaModel(
                                      mediaType: media['media_type'],
                                      thumbnail: media['thumbnail_url'] ?? "",
                                      mediaURL: media['media_url']
                                    ));
                                  });
                    
                                  return Column(
                                    children: [
                                      Container(
                                        height: size.width,
                                        width: size.width,
                                        child: PageView(
                                          physics: PageScrollPhysics(),
                                          pageSnapping: true,
                                          children: List.generate(carouselChildrenList.length, (index){
                                            return carouselChildrenList[index].mediaType == "IMAGE"
                                            ? Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Image(
                                                    image: NetworkImage(carouselChildrenList[index].mediaURL),
                                                    fit: BoxFit.cover
                                                  ),
                                                  Container(
                                                    height: (size.width) / 12.5,
                                                    width: (size.width) / 8,
                                                    margin: EdgeInsets.only(
                                                      right: (size.width / 24),
                                                      top: (size.width / 24),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(50)
                                                      ),
                                                      color: Colors.black.withOpacity(0.8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${index + 1}/${carouselChildrenList.length}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              )
                                            : Container(
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  FlickMultiPlayer(
                                                      url: carouselChildrenList[index].mediaURL,
                                                      flickMultiManager: flickMultiManager,
                                                      image: carouselChildrenList[index].thumbnail,
                                                  ),
                                                  Container(
                                                    height: (size.width) / 12.5,
                                                    width: (size.width) / 8,
                                                    margin: EdgeInsets.only(
                                                      right: (size.width / 24),
                                                      top: (size.width / 24),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(50)
                                                      ),
                                                      color: Colors.black.withOpacity(0.8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${index + 1}/${carouselChildrenList.length}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.0175,
                        horizontal: size.height * 0.015
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "",
                              style: subtitleTextStyle,
                              children: <TextSpan>[
                                TextSpan(text: widget.username + " ", style: subtitleBoldTextStyle),
                                TextSpan(text: widget.medias[index].caption),
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          Text(
                            DateTime.parse(widget.medias[index].timeStamp).year == DateTime.now().year
                            ? _sameYearDateFormat.format(DateTime.parse(widget.medias[index].timeStamp))
                            : _dateFormat.format(DateTime.parse(widget.medias[index].timeStamp)),
                            style: TextStyle(
                              color: Theme.of(context).accentColor.withOpacity(0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  } 
}