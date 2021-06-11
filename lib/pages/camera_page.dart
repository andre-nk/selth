part of 'pages.dart';

enum CameraType {front, back}

class CameraPage extends StatefulWidget {
  CameraPage(this.isStory, {Key key, this.previewImage}) : super(key: key);

  final bool isStory;
  final AssetEntity previewImage; 
  final double iconHeight = 30;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController _controller;
  CameraType currentType = CameraType.front;
  Future<void> _controllerInitializer;
  double cameraHorizontalPosition = 0;
  bool isRecording = false;
  int recordingMinute = 0;
  int recordingSecond = 0;
  StopWatchTimer stopWatchTimer;

  Future<CameraDescription> getCamera(CameraType type) async {
    final cameras = await availableCameras();
    CameraDescription output;
    type == CameraType.front
      ? output = cameras.first
      : output = cameras[1];

    return output;
  }

  @override
  void initState() {
    super.initState();
    getCamera(CameraType.front).then((camera) {
      if (camera == null) return;
      setState(() {
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
        );
        _controllerInitializer = _controller.initialize();
      });
    });
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChangeRawSecond: (value){
        setState(() {
          recordingSecond = value;
        });
      },
      onChangeRawMinute: (value){
        setState(() {
          recordingMinute = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          left: cameraHorizontalPosition,
          right: cameraHorizontalPosition,
          child: FutureBuilder(
            future: _controllerInitializer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: SizedBox(),
              centerTitle: true,
              title: IconButton(
                icon: Icon(_controller.value.flashMode == FlashMode.off
                  ? Icons.flash_off
                  : _controller.value.flashMode == FlashMode.auto
                    ? Icons.flash_auto
                    : Icons.flash_on),
                onPressed: (){
                  _controller.value.flashMode == FlashMode.off
                  ? setState((){
                      _controller.setFlashMode(FlashMode.auto);
                    })
                  : _controller.value.flashMode == FlashMode.auto
                    ? setState((){
                      _controller.setFlashMode(FlashMode.always);
                      })
                    : setState((){
                      _controller.setFlashMode(FlashMode.off);
                     });
                },
                color: Colors.white
              ),
            ),
            body: Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  
                  Padding(
                    padding: EdgeInsets.only(
                      top:  MediaQuery.of(context).size.height * 0.125
                    ),
                    child: GestureDetector(
                      onTap: (){
                        _controller.setFocusMode(FocusMode.auto);
                      },
                      child: Center(
                        child: widget.isStory
                        ? SizedBox()
                        : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                            childAspectRatio: 1/1,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index){
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.white
                                )
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 25,
                    left: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          onTap: (){
                            widget.isStory
                            ? Get.to(() => AddItemPage(true), transition: Transition.downToUp)
                            : Get.back();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              child: widget.previewImage == null
                              ? Icon(Icons.photo_outlined, color: Colors.white, size: 18)
                              : FutureBuilder(
                                future: widget.previewImage.thumbDataWithSize(800, 800),
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
                                      ],
                                    );
                                  return Container();
                                },
                              ),
                            )
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          onTap: (){
                            if(isRecording == false){
                              _controller.takePicture().then((value) async {
                                if(Platform.isAndroid){
                                  InstagramShare.share(value.path.toString(), "image");
                                } else if (Platform.isIOS){
                                  Instashare.shareToFeedInstagram('image/*', value.path.toString());
                                }
                              });
                            } else {
                              setState(() {
                                isRecording = false;
                                stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                _controller.stopVideoRecording().then((value){
                                  if(Platform.isAndroid){
                                    InstagramShare.share(value.path.toString(), "video");
                                  } else if (Platform.isIOS){
                                    Instashare.shareToFeedInstagram('video/*', value.path.toString());
                                  }
                                });
                              });
                            }
                          },
                          onLongPress: (){
                            if(isRecording == false){
                              setState(() {
                                isRecording = true;
                                _controller.startVideoRecording();
                                stopWatchTimer.onExecute.add(StopWatchExecute.start);
                              });
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              isRecording
                              ? Positioned(
                                  bottom: MediaQuery.of(context).size.height * 0.12,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.175,
                                    height: MediaQuery.of(context).size.width * 0.08,
                                    child: Center(
                                      child: Text(
                                        "$recordingMinute : ${
                                            recordingSecond < 10
                                            ? '0' + recordingSecond.toString()
                                            : recordingSecond
                                          }",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey[900].withOpacity(0.5)
                                    ),
                                  )
                                )
                              : SizedBox(),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: isRecording ? Colors.red : Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(isRecording ? 30 : 25),
                                    ),
                                  ),
                                ),
                                height: isRecording ? 75 : 70,
                                width: isRecording ? 75 : 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(isRecording ? 40 : 35),
                                  ),
                                  border: Border.all(
                                    width: 10,
                                    color: Colors.white.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: widget.iconHeight,
                          child: IconButton(
                            onPressed: (){
                              getCamera(
                                currentType == CameraType.front
                                  ? CameraType.back
                                  : CameraType.front
                              ).then((camera) {
                                if (camera == null) return;
                                setState(() {
                                  currentType == CameraType.front
                                    ? currentType = CameraType.back
                                    : currentType = CameraType.front;
                                  _controller = CameraController(
                                    camera,
                                    ResolutionPreset.high,
                                  );
                                  _controllerInitializer = _controller.initialize();
                                });
                              });
                            },
                            icon: Icon(Icons.cached),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}