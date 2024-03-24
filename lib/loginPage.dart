import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motophoty/registerPage.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key, required camera});

  late CameraDescription camera;

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String? errorMessage;

  String _email = '';
  String _password = '';

  //インジケーター用
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ?
        //縦向きのUI
        PopScope(
          canPop: false,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  Expanded(
                      child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 7 / 10,
                            child: Image.asset('assets/images/titlelogo2.png',
                                fit: BoxFit.cover)),
                        SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                    labelText: 'E-mail address'),
                              ),
                            ),
                            SizedBox(width: 30)
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                obscureText: true,
                                decoration:
                                    const InputDecoration(labelText: 'password'),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              wait();
                              try {
                                final User? user = (await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _email, password: _password))
                                    .user;
                                if (user != null) {}
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        // TextButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       'Forget the password.',
                        //       style: TextStyle(
                        //           decoration: TextDecoration.underline,
                        //           decorationColor: Colors.grey,
                        //           color: Colors.grey),
                        //     )),
                        TextButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (builder) {
                                return registerPage();
                              }));
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey,
                                  color: Colors.grey),
                            )),
                        SizedBox(height: 20),
                        Visibility(
                            visible: _isLoading,
                            child: CircularProgressIndicator(color: Colors.white))
                      ],
                    ),
                  ))
                ],
              ),
            ),
        )
        : //横向きのUI
        Scaffold(
           resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    child: Image.asset(
                      'assets/images/titlelogo2.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
                  SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  labelText: 'E-mail address'),
                            ),
                          ),
                          SizedBox(width: 30)
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.key,
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: 'password'),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () async {
                            wait();
                            try {
                              final User? user = (await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _email, password: _password))
                                  .user;
                              if (user != null) {}
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(height: 20),
                      Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(color: Colors.white))
                    ],
                  ))
                ],
              ),
            ),
          );
  }

  Future<void> wait() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }
}
