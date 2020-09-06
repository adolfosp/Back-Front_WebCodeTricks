import 'package:flutter/material.dart';
import 'package:webcodetricks/screen/addExercise.dart';
import 'package:webcodetricks/screen/home_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Lista de Exercícios",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center)),
            BottomNavigationBarItem(
              icon: Icon(Icons.input),
              title: Text(
                "Cadastro de Exercícios",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("NULL"))
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            children: <Widget>[
              HomePageExercise(),
              AddExercise(),
              Container(
                color: Colors.green,
              ),
            ]),
      ),
    );
  }
}
