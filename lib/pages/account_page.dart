part of "pages.dart";
class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  int selectedIndex = 0;
  bool drawerOpened = false;
  PageController _controller = new PageController();
  String uName, followers = " ", following, bio, website, profileimage;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: false,
        children: [
          drawerOpened
            ? GestureDetector(
                onTap: (){
                  _controller.animateTo(0, curve: Curves.ease, duration: Duration(milliseconds: 300));
                  setState(() {
                    drawerOpened = !drawerOpened;
                  });
                },
                child: getBody(size)
              )
            : getBody(size),
          getSideBar(size)
        ],
      )
    );
  }

  Widget getSideBar(Size size){
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 0.5, color: Theme.of(context).accentColor.withOpacity(0.25))
          )
        ),
        height: size.height,
        padding: EdgeInsets.only(
          left: size.width * 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              elevation: 0,
              title: Text(
                username,
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(height: 0.5, color: Theme.of(context).accentColor.withOpacity(0.25)),
            Container(
              height: size.height * 0.8,
              padding: EdgeInsets.only(
                top: size.height * 0.05
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: (size.width * 0.65 / 2.45)
                    ),
                    child: SvgPicture.asset("assets/images/selthiconnew.svg",
                      height: size.height * 0.05,
                      color: Theme.of(context).accentColor
                    )
                  ),
                  SizedBox(height: size.height * 0.03),
                  Consumer(
                    builder: (context, watch, _){

                      final _appThemeStateProvider = watch(appThemeStateProvider.notifier);

                      return ListTile(
                        onTap: (){
                          _appThemeStateProvider.toggleAppTheme(context);
                        },
                        horizontalTitleGap: 0,
                        leading: Theme.of(context).accentColor == HexColor("000000")
                          ? Icon(Icons.light_mode_rounded)
                          : Icon(Icons.dark_mode_rounded, color: Theme.of(context).accentColor),
                        title: Theme.of(context).accentColor == HexColor("000000")
                          ? Text(
                              "Light theme",
                              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, fontWeight: FontWeight.normal)
                            )
                          : Text(
                              "Dark theme",
                              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, fontWeight: FontWeight.normal)
                            ),
                      );
                    } 
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget getAppBar(size) {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            username,
            style: TextStyle(color: Theme.of(context).accentColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.bars),
            color: Theme.of(context).accentColor,
            onPressed: (){
              if(drawerOpened){
                _controller.animateTo(0, curve: Curves.ease, duration: Duration(milliseconds: 300));
                setState(() {
                  drawerOpened = !drawerOpened;
                });
              } else {
                _controller.animateTo(size.width * 0.65, curve: Curves.ease, duration: Duration(milliseconds: 300));
                setState(() {
                  drawerOpened = !drawerOpened;
                });
              }
            },
          )
        ],
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0,

    );
  }

  Widget getBody(size) {

    TextStyle headlineTextStyle = Theme.of(context).textTheme.headline6;
    TextStyle subtitleTextStyle = Theme.of(context).textTheme.subtitle1;
    TextStyle subtitleBoldTextStyle = Theme.of(context).textTheme.subtitle2;

    return Scaffold(
      appBar: getAppBar(size),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(height: 0.5, color: Theme.of(context).accentColor.withOpacity(0.25)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.height * 0.02,
              vertical: size.height * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: bgGrey),
                          image: DecorationImage(
                            image: NetworkImage(profile),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: size.height * 0.01),
                      Container(
                        width: size.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "61",
                                  style: headlineTextStyle,
                                ),
                                SizedBox(height: (size.height - 10) * 0.01),
                                Text(
                                  "Posts",
                                  style: subtitleTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "1,058",
                                  style: headlineTextStyle
                                ),
                                SizedBox(height: (size.height - 10) * 0.01),
                                Text(
                                  "Followers",
                                  style: subtitleTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "173",
                                  style: headlineTextStyle
                                ),
                                SizedBox(height: (size.height - 10) * 0.01),
                                Text(
                                  "Following",
                                  style: subtitleTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(instagramName, style: subtitleBoldTextStyle),
                SizedBox(height: 10),
                Text(instagramBio, style: subtitleTextStyle),    
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: (size.width * 0.5),
                  child: IconButton(
                    splashRadius: 20,
                    icon: Icon(FontAwesome.th, color: selectedIndex == 0 ? Theme.of(context).accentColor : Theme.of(context).accentColor.withOpacity(0.5),),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                ),
                Container(
                  width: (size.width * 0.5),
                  child: IconButton(
                    splashRadius: 20,
                    icon: Icon(FontAwesome.id_badge, color: selectedIndex == 1 ? Theme.of(context).accentColor : Theme.of(context).accentColor.withOpacity(0.5),),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 1,
                    width: (size.width * 0.5),
                    decoration: BoxDecoration(color: selectedIndex == 0 ? bgDark : Colors.transparent),
                  ),
                  Container(
                    height: 1,
                    width: (size.width * 0.5),
                    decoration: BoxDecoration(color: selectedIndex == 1 ? bgDark : Colors.transparent),
                  ),
                ],
              ),
              Container(
                height: 0.5,
                width: size.width,
                decoration: BoxDecoration(color: bgGrey.withOpacity(0.8)),
              ),
            ],
          ),
          SizedBox(height: 3),
          IndexedStack(
            index: selectedIndex,
            children: [
              getImages(size),
              getImageWithTags(size),
            ],
          ),
        ],
      ),
    );
  }

  Widget getImages(size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(images.length, (index) {
        return GestureDetector(
          onTap: (){
            Get.to(() => PostPage(
              index: index,
              images: images
            ), transition: Transition.cupertino);
          },
          child: Container(
            height: (size.width - 6) / 3,
            width: (size.width - 6) / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover
              )
            ),
          ),
        );
      })
    );
  }

  Widget getImageWithTags(size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(imageWithTags.length, (index) {
        return Container(
          height: (size.width - 6) / 3,
          width: (size.width - 6) / 3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageWithTags[index]),
              fit: BoxFit.cover
            )
          ),
        );
      })
    );
  }
}