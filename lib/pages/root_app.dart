part of 'pages.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: indexPage,
      children: [
        AccountPage(),
      ],
    );
  }

  Widget getBottomNavigationBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: bgDark.withOpacity(0.3))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: IconButton(
          onPressed: () async {
            var _sharedPreferences = await SharedPreferences.getInstance();
            print(jsonDecode(_sharedPreferences.getString("userData")));
          },
          icon: SvgPicture.asset(
            icons.last["inactive"],
            color: Theme.of(context).accentColor, 
            width: 25, 
            height: 25,
          ),
        )
      )
    );
  }
}