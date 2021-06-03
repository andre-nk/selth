part of "pages.dart";

class PostPage extends StatefulWidget {

  final int index;
  final int length;
  final String photoURL;
  final List<MediaModel> medias;

  const PostPage({Key key, this.index, this.length, this.medias, this.photoURL}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;  
    // TextStyle headlineTextStyle = Theme.of(context).textTheme.headline6;
    // TextStyle subtitleTextStyle = Theme.of(context).textTheme.subtitle1;
    TextStyle subtitleBoldTextStyle = Theme.of(context).textTheme.subtitle2;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(
        widget.index * (size.width + size.height * 0.1),
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
      body: Container(
        height: size.height,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          itemCount: widget.medias.length,
          itemBuilder: (context, index){
            return Container(
              height: size.width + size.height * 0.1,
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
                            border: Border.all(width: 1, color: bgGrey),
                            image: DecorationImage(
                              image: NetworkImage(widget.photoURL),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        SizedBox(width: size.width * 0.025),
                        Text(username, style: subtitleBoldTextStyle),
                      ],
                    ),
                  ),
                  Container(
                    height: size.width,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.medias[index].mediaURL),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    );
  } 
}