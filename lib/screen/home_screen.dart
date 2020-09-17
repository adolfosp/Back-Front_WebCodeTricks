import 'package:flutter/material.dart';
import 'package:webcodetricks/main.dart';
import 'package:webcodetricks/screen/addExercise.dart';
import 'package:webcodetricks/screen/home_page.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key, this.usuario }) : super(key: key);
    final String usuario;

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
            canvasColor: Colors.grey[850],
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
              icon: Icon(Icons.exit_to_app),
              title: Text(
                "SAIR",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          
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
            children: <Widget>[HomePageExercise(usuarioF:widget.usuario), AddExercise(usuarioF:widget.usuario),
            AlertDialog(
            content: Text("Deseja realmente sair?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Sim"),
                 onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPageWidget()),
                        );
                      },
              ),
              FlatButton(
                color: Colors.red,
                child: Text("Não"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          )
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            ],
         
      ),
    ));
    
  }

 
}


