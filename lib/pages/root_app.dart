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

        if(snapshot.data.getString('userTokenExpiration') == '0'){
          spreferences.remove('userData');
          Get.offAndToNamed('/auth');
        }

        return Scaffold(
          body: IndexedStack(
            index: indexPage,
            children: [
              AccountPage(
                userData: jsonDecode(snapshot.data.getString("userData")),
                userToken: snapshot.data.getString('userToken'),
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
                  Get.to(() => AddItemPage(), transition: Transition.downToUp);
                },
                icon: SvgPicture.asset(
                  icons.last["inactive"],
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
}