part of 'pages.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot){

        print(snapshot.data.getString('userToken'));
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
                  print(snapshot.data.getString('userTokenExpiration'));
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