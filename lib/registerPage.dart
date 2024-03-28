import 'dart:isolate';

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

  String? _email;
  String? _password;

  bool alreadyUserError = false;
  bool lowSecurityError = false;
  bool inputError = false;
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
                                decoration: const InputDecoration(
                                    labelText: 'password'),
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
                              if (_email == null || _password == null) {
                                setState(() {
                                  inputError = true;
                                });
                              } else {
                                try {
                                  setState(() {
                                    inputError = false;
                                    alreadyUserError = false;
                                    lowSecurityError = false;
                                    _isLoading = true;
                                  });
                                  final User? user = (await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: _email!,
                                              password: _password!))
                                      .user;

                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (builder) {
                                    return inputPage();
                                  }));
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    setState(() {
                                      lowSecurityError = true;
                                      _isLoading = false;
                                    });
                                  } else if (e.code == 'email-already-in-use') {
                                    setState(() {
                                      alreadyUserError = true;
                                      _isLoading = false;
                                    });
                                  }
                                }
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
                        Visibility(
                            visible: alreadyUserError,
                            child: const Text(
                              'This E-mail address is already used.',
                              style: TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: inputError,
                            child: const Text(
                              'Enter E-mail address and password.',
                              style: const TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: lowSecurityError,
                            child: const Text(
                              'Stronger password is needed.',
                              style: const TextStyle(color: Colors.red),
                            )),
                        SizedBox(height: 10),
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
                        SizedBox(height: 20),
                        Visibility(
                            visible: _isLoading,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
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
                                decoration: const InputDecoration(
                                    labelText: 'password'),
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
                              if (_email == null || _password == null) {
                                setState(() {
                                  inputError = true;
                                });
                              } else {
                                try {
                                  setState(() {
                                    inputError = false;
                                    alreadyUserError = false;
                                    lowSecurityError = false;
                                    _isLoading = true;
                                  });
                                  final User? user = (await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: _email!,
                                              password: _password!))
                                      .user;

                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (builder) {
                                    return inputPage();
                                  }));
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    setState(() {
                                      _isLoading = false;
                                      lowSecurityError = true;
                                    });
                                  } else if (e.code == 'email-already-in-use') {
                                    setState(() {
                                      _isLoading = false;
                                      alreadyUserError = true;
                                    });
                                  }
                                }
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
                        Visibility(
                            visible: alreadyUserError,
                            child: const Text(
                              'This E-mail address is already used.',
                              style: TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: inputError,
                            child: const Text(
                              'Enter E-mail address and password.',
                              style: const TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: lowSecurityError,
                            child: const Text(
                              'Stronger password is needed.',
                              style: const TextStyle(color: Colors.red),
                            )),
                        Visibility(
                            visible: _isLoading,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
  }
}
