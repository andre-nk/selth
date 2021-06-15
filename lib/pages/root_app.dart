part of 'pages.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int indexPage = 0;
  var spreferences;

  @override
  void initState(){ 
    super.initState();
    spreferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot){

        if(snapshot.data!.getString('userTokenExpiration') == '0'){
          spreferences.remove('userData');
          Get.offAndToNamed('/auth');
        }

        return Scaffold(
          body: IndexedStack(
            index: indexPage,
            children: [
              AccountPage(
                userData: jsonDecode(snapshot.data!.getString("userData") ?? ""),
                userToken: snapshot.data!.getString('userToken') ?? "",
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: bgDark.withOpacity(0.3))),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: IconButton(
                onPressed: () async {
                  Get.bottomSheet(
                    getBottomSheet(context, MediaQuery.of(context).size)
                  );
                },
                icon: SvgPicture.asset(
                  icons.last["inactive"] ?? "",
                  color: Theme.of(context).accentColor, 
                  width: 25, 
                  height: 25,
                ),
              )
            )
          ),
        );
      }
    );
  }

  Widget getBottomSheet(BuildContext context, Size size){
    return BottomSheet(
      enableDrag: true,
      backgroundColor: Theme.of(context).primaryColor == Colors.white ? Colors.white : HexColor("262626"),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      builder: (context){
        return Container(
          height: size.height * 0.2,
          padding: EdgeInsets.all(
            size.height * 0.02
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.125,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor == Colors.white ? Colors.grey[400] : HexColor("747474"),
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
              ),
              ListTile(
                minLeadingWidth: 30,
                contentPadding: EdgeInsets.only(
                  top: size.height * 0.01,
                  bottom: size.height * 0,
                ),
                title: Text("New post"),    
                onTap: (){
                  Navigator.pop(context);
                  Get.to(() => AddItemPage(false), transition: Transition.downToUp);
                },       
              ),
              ListTile(
                minLeadingWidth: 30,
                contentPadding: EdgeInsets.only(
                  top: size.height * 0,
                  bottom: size.height * 0.01,
                ),
                title: Text("New story"),
                onTap: (){
                  Navigator.pop(context);
                  Get.to(() => CameraPage(true), transition: Transition.downToUp);
                },   
              )
            ],
          )
        );
      },
      onClosing: (){},
    );
  }
}