import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motophoty/inputPage.dart';
import 'package:motophoty/loginPage.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  String? errorMessage;

  String _email = '';
  String _password = '';

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
                          child: Image.asset(
                            'assets/images/titlelogo2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
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
                                onChanged: (String value) {
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
                                onChanged: (String value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
                              try {
                                final User? user = (await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email, password: _password))
                                    .user;
          
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (builder) {
                                  return inputPage();
                                }));
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (builder) {
                                final camera = availableCameras();
                                return loginPage(camera: camera);
                              }));
                            },
                            child: Text(
                              'Already have account?',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey,
                                  color: Colors.grey),
                            )),
                      ],
                    ),
                  ))
                ],
              ),
            ),
        )
        : //横向きのUI
        PopScope(
          canPop: false,
          child: Scaffold(
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
                                onChanged: (String value) {
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
                                onChanged: (String value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
                              try {
                                final User? user = (await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email, password: _password))
                                    .user;
          
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (builder) {
                                  return inputPage();
                                }));
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ))
                  ],
                ),
              ),
            ),
        );
  }
}
