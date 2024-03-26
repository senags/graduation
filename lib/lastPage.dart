import 'package:flutter/material.dart';

class lastPage extends StatelessWidget {
  const lastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 6 / 10,
            child: Image.asset('assets/images/logo2.png',fit: BoxFit.cover,)),
          SizedBox(height: 40),
          Text('Thank you for using MotoPhoty!',
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold))
        ],
      )),
    );
  }
}
