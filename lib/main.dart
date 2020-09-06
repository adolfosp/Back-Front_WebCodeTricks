import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webcodetricks/pageInicial.dart';
import 'package:webcodetricks/screen/login_screen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPageWidget(),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => LoginPageWidget(),
      },
    ));

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();

    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: AssetImage("images/Logo.png"),
          fit: BoxFit.cover,
        )),
        padding: EdgeInsets.all(50),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  onGoogleSignIn(context);
                },
                color: isUserSignedIn ? Colors.green : Colors.blueAccent,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                            isUserSignedIn
                                ? 'Você já está logado'
                                : 'Logar com Google',
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                color: isUserSignedIn ? Colors.green : Colors.blueAccent,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Logar como Dev",
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }
    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();

    var userSignedIn = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => WelcomeUserWidget(user, _googleSignIn)),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }
}
