import 'package:flutter/material.dart';

class lastPage extends StatelessWidget {
  const lastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ?
        //縦向きのUI
        PopScope(
          canPop: false,
          child: Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 6 / 10,
                      child: Image.asset(
                        'assets/images/logo2.png',
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: 40),
                  Text('Thank you for using MotoPhoty!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                ],
              )),
            ),
        )
        :
        //横向きのUI
        PopScope(
          canPop: false,
          child: SafeArea(
            child: Scaffold(
                body: Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 10,
                      child: Image.asset('assets/images/logo2.png'),
                    ),
                    Text('Thank you for using MotoPhoty!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ],
                              ),
                )),
          ),
        );
  }
}
