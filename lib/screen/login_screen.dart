import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webcodetricks/blocs/login_bloc.dart';
import 'package:webcodetricks/widgets/input_field.dart';
import 'package:webcodetricks/screen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String usuarioFinal = "";
void receberID(usuario) {
  print(usuario + "dentro do login_screen");
  usuarioFinal = usuario;
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(usuario: usuarioFinal)));

          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<LoginState>(
          initialData: LoginState.LOADING,
          stream: _loginBloc.outState,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.yellow),
                  ),
                );
              case LoginState.FAIL:
              case LoginState.IDLE:
              case LoginState.SUCCESS:
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                              Color.fromRGBO(99, 101, 107, 0.8),
                              Color.fromRGBO(71, 74, 81, 0.7),
                            ])),
                        child: Container(
                          height: 600,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Autor ",
                                          style:
                                              GoogleFonts.roboto(fontSize: 50),
                                        ),
                                        Text(
                                          "WebCodeTricks",
                                          style: GoogleFonts.lilitaOne(
                                              fontSize: 42),
                                        )
                                      ]),
                                ),
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(253, 211, 29, 0.9),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                    )),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                  margin: EdgeInsets.all(12),
                                  child: Column(children: <Widget>[
                                    InputField(
                                      icon: Icons.person_outline,
                                      hint: "Usuário",
                                      obscure: false,
                                      stream: _loginBloc.outEmail,
                                      onChanged: _loginBloc.changeEmail,
                                    ),
                                    InputField(
                                      icon: Icons.lock_outline,
                                      hint: "Senha",
                                      obscure: true,
                                      stream: _loginBloc.outPassword,
                                      onChanged: _loginBloc.changePassword,
                                    ),
                                    SizedBox(
                                      height: 32,
                                    ),
                                    StreamBuilder<bool>(
                                        stream: _loginBloc.outSubmitValid,
                                        builder: (context, snapshot) {
                                          return SizedBox(
                                            height: 50,
                                            child: RaisedButton(
                                              color: Color.fromRGBO(
                                                  253, 211, 29, 0.9),
                                              child: Text(
                                                "Entrar",
                                                style: GoogleFonts.patuaOne(
                                                    fontSize: 30),
                                              ),
                                              onPressed: snapshot.hasData
                                                  ? _loginBloc.submit
                                                  : null,
                                              textColor: Colors.black,
                                              disabledColor:
                                                  Colors.yellow.withAlpha(140),
                                            ),
                                          );
                                        })
                                  ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }
}
