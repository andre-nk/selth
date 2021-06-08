part of 'pages.dart';

class AddItemPage extends StatefulWidget {
  AddItemPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.04
            ),
            child: Icon(Icons.arrow_forward, color: HexColor("0195F7")),
          )
        ],
      ),
      body: MediaGrid(),
    );
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<Widget> _mediaList = [];
  Widget selectedMedia;
  List<AssetPathEntity> allPath;
  AssetPathEntity selectedPath;
  int currentPage = 0;
  int lastPage;
  String dropdownPath;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: false);
      List<AssetEntity> media = await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];

      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(1000, 1000),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              return Container();
            },
          ),
        );
      }

      setState(() {
        selectedPath == null 
        ? _mediaList.addAll(temp)
        : _mediaList = temp;
        currentPage++;
      });

    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double midBar = 55;

    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return;
        },
        child: Container(
          height: size.height,
          child: Column(
            children: [
              Container(
                height: size.width,
                width: size.width,
                child: selectedMedia != null
                  ? selectedMedia
                  : _mediaList.isEmpty
                    ? SizedBox()
                    : _mediaList.first
              ),
              Container(
                width: size.width,
                height: midBar,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.025,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Recent",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                      )
                    ),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      onTap: (){
                        Get.to(() => CameraPage(
                          previewImage: _mediaList.first,
                        ), transition: Transition.leftToRight);
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.5)
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    )
                    // DropdownButton<String>(
                    //   dropdownColor: Theme.of(context).primaryColor,
                    //   value: dropdownPath == null ? allPath.first.name : dropdownPath,
                    //   icon: const Icon(CupertinoIcons.chevron_down),
                    //   iconSize: 20,
                    //   elevation: 0,
                    //   style: TextStyle(
                    //     color: Theme.of(context).accentColor,
                    //     fontSize: 16,
                    //   ),
                    //   underline: Container(
                    //     height: 0,
                    //     color: Colors.deepPurpleAccent,
                    //   ),
                    //   onChanged: (String newValue) {
                    //     setState(() {
                    //       selectedMedia = null;
                    //       dropdownPath = newValue;
                    //       selectedPath = allPath.firstWhere((element) => element.name == newValue);
                    //     });
                    //     _fetchNewMedia();
                    //   },
                    //   items: uniqueDropdownValue.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                  ]
                )
              ),
              Container(
                height: size.height - size.width - 100 - midBar,
                width: size.width,
                child: _mediaList == []
                  ? SizedBox()
                  : GridView.builder(
                  itemCount: _mediaList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedMedia = _mediaList[index];
                        });
                      },
                      child: _mediaList[index]
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
