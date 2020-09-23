import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:webcodetricks/chat/back/chat_screenback.dart';
import 'package:webcodetricks/chat/front/chat_screenfront.dart';
import 'package:webcodetricks/screen/home_screen_google.dart';
import 'package:webcodetricks/tabs/home_tab.dart';

class WelcomeUserWidget extends StatelessWidget {
  GoogleSignIn googleSignIn;
  FirebaseUser _user;
  final _pageController = PageController();

  WelcomeUserWidget(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    googleSignIn = signIn;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: MultiLevelDrawer(
          backgroundColor: Colors.white,
          rippleColor: Colors.white,
          subMenuBackgroundColor: Colors.grey.shade100,
          divisionColor: Colors.white10,
          header: Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/fundo.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(100, 30),
                  bottomRight: Radius.elliptical(100, 30),
                ),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(71, 74, 81, 0.9),
                      Color.fromRGBO(99, 101, 107, 0.9)
                    ])),
            height: size.height * 0.25,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  child: ClipOval(
                      child: Image.network(
                          _user.photoUrl == null
                              ? Image.asset("images/user.png")
                              : _user.photoUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )),
          ),
          children: [
            MLMenuItem(
                leading: new Icon(
                  Icons.chat_bubble_outline,
                  size: 40,
                ),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "    Chats",
                ),
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                      submenuContent: Text("Back-End")),
                  MLSubmenu(
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreenFront()),
                        );
                      },
                      submenuContent: Text("Front-End")),
                ],
                onClick: () {}),
            MLMenuItem(
              leading: new Image.asset("images/exercise.png"),
              content: Text("    Exercícios"),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            MLMenuItem(
              content: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    googleSignIn.signOut();
                    Navigator.popAndPushNamed(context, '/homepage');
                  },
                  color: Colors.redAccent,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Log out ',
                              style: TextStyle(color: Colors.white))
                        ],
                      ))),
              onClick: () {},
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[HomeTab(text: _user.displayName)],
        ),
      ),
    );
  }
}
