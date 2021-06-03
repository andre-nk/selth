part of "pages.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({Key key }) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  void initState() { 
    super.initState();
    SimpleAuthFlutter.init(context);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(size.height * 0.035),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/selthiconnew.svg",
                height: size.height * 0.08,
                color: Theme.of(context).accentColor
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                "Selth",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).accentColor, height: 1.25, fontSize: 32, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                height: size.height * 0.07,
                width: size.width,
                child: Consumer(
                  builder: (context, watch, _){
                    final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
                      "instagram",
                      Constants.igClientId,
                      Constants.igClientSecret,
                      Constants.igRedirectURL,
                      scopes: [
                        'user_profile', // For getting username, account type, etc.
                        'user_media', // For accessing media count & data like posts, videos etc.
                      ],
                    );

                    return ElevatedButton(
                      onPressed: () async {
                        watch(authProvider(_igApi));
                      },
                      child: Text(
                        "Sign In with Instagram",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: HexColor("0195F7")
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                "Please sign in with your Instagram account to continue",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.5), height: 1.25, fontSize: 16, fontWeight: FontWeight.normal)
              ),
            ],
          )
        ),
      )
    );
  }
}