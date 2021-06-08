part of 'pages.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key key, this.previewImage}) : super(key: key);

  final Widget previewImage; 
  final double iconHeight = 30;
  final PageController bottomPageController = PageController(viewportFraction: .2);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController _controller;
  Future<void> _controllerInizializer;
  double cameraHorizontalPosition = 0;

  Future<CameraDescription> getCamera() async {
    final c = await availableCameras();
    return c.first;
  }

  @override
  void initState() {
    super.initState();

    getCamera().then((camera) {
      if (camera == null) return;
      setState(() {
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
        );
        _controllerInizializer = _controller.initialize();
      });
    });
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
            future: _controllerInizializer,
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
              leading: Icon(Icons.settings),
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
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                )
              ],
            ),
            body: Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top:  MediaQuery.of(context).size.height * 0.125
                    ),
                    child: Center(
                      child: GridView.builder(
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
                  Positioned(
                    bottom: 50,
                    right: 40,
                    left: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          onTap: (){
                            Get.back();
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
                              child: widget.previewImage
                            )
                          ),
                        ),
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(35),
                            ),
                            border: Border.all(
                              width: 10,
                              color: Colors.white.withOpacity(.5),
                            ),
                          ),
                        ),
                        Container(
                          height: widget.iconHeight,
                          child: IconButton(
                            onPressed: (){
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