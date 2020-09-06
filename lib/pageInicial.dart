import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:webcodetricks/chat/back/chat_screenback.dart';
import 'package:webcodetricks/chat/front/chat_screenfront.dart';
import 'package:webcodetricks/screen/home_screen_google.dart';

class WelcomeUserWidget extends StatelessWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;

  WelcomeUserWidget(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
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
          divisionColor: Colors.grey,
          header: Container(
            height: size.height * 0.25,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                    child: Image.network(_user.photoUrl,
                        width: 100, height: 100, fit: BoxFit.cover)),
                SizedBox(
                  height: 10,
                ),
                Text("${_user.displayName}")
              ],
            )),
          ),
          children: [
            MLMenuItem(
                leading: new Image.asset('images/hashtag.png'),
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
                leading: new Image.asset('images/exercise.png'),
                trailing: Icon(Icons.arrow_right),
                content: Text("    Exercícios"),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      submenuContent: Text("Option 1")),
                ]),
            MLMenuItem(
              leading: Icon(Icons.notifications),
              content: Text("Usuários"),
              onClick: () {},
            ),
            MLMenuItem(
                leading: Icon(Icons.payment),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "Payments",
                ),
                subMenuItems: [
                  MLSubmenu(onClick: () {}, submenuContent: Text("Option 1")),
                  MLSubmenu(onClick: () {}, submenuContent: Text("Option 2")),
                  MLSubmenu(onClick: () {}, submenuContent: Text("Option 3")),
                  MLSubmenu(onClick: () {}, submenuContent: Text("Option 4")),
                ],
                onClick: () {}),
            MLMenuItem(
              content: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    _googleSignIn.signOut();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "<Web Code Tricks/>",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 65, 108, 1.0),
                    Color.fromRGBO(255, 75, 43, 1.0),
                  ]),
            ),
            child: Center()),
      ),
    );
  }
}
