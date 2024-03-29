import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editPage extends StatefulWidget {
  const editPage({super.key});

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> {
  late String userId;

  final picker = ImagePicker();

  String? _motoName;
  File? _image;

  bool caution = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? currentuser) {
      if (currentuser != null) {
        setState(() {
          userId = currentuser.uid;
        });
      }
    });

    return MediaQuery.of(context).orientation == Orientation.portrait
        ?
        //縦向きのUI
        Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Edit profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                              Icons.bike_scooter,
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              initialValue: _motoName,
                              onChanged: (value) {
                                setState(() {
                                  _motoName = value;
                                });
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  labelText: 'Motorcycle name.(e.g. Ninja250)'),
                            ),
                          ),
                          SizedBox(width: 50)
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Icon(
                              Icons.photo,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _image = File(pickedFile.path);
                                  });
                                }
                              },
                              child: Text(
                                'Select cover photo. (Tap here)',
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.grey),
                              ))
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 8 / 10,
                        child: _image != null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                            : Container(),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () async {
                            if (_image == null || _motoName == null) {
                              caution = true;
                              return null;
                            } else {
                              loading = true;
                              caution = false;
                              final task = await FirebaseStorage.instance
                                  .ref()
                                  .child(userId)
                                  .putFile(_image!);

                              final String imageURL =
                                  await task.ref.getDownloadURL();
                              final String imagePath = task.ref.fullPath;

                              final profData = await <String, String>{
                                'motoName': _motoName!,
                                'coverImageURL': imageURL,
                                'coverImagePath': imagePath
                              };
                              await FirebaseFirestore.instance
                                  .collection('test')
                                  .doc(userId)
                                  .collection('profileData')
                                  .doc('profile')
                                  .set(profData);

                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(height: 20),
                      Visibility(
                          visible: caution,
                          child: Text(
                            'Enter motorcycle name and select cover photo.',
                            style: const TextStyle(color: Colors.red),
                          )),
                      Visibility(
                          visible: loading,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            )),
          )
        : //横向きのUI
        Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
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
                                  Icons.bike_scooter,
                                  color: Colors.white,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _motoName = value;
                                    });
                                  },
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                      labelText:
                                          'Motorcycle name.(e.g. Ninja250)'),
                                ),
                              ),
                              SizedBox(width: 50)
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(width: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        _image = File(pickedFile.path);
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Select cover photo. (Tap here)',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.grey),
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                if (_image == null || _motoName == null) {
                                  caution = true;
                                  return null;
                                } else {
                                  loading = true;
                                  caution = false;
                                  final task = await FirebaseStorage.instance
                                      .ref()
                                      .child(userId)
                                      .putFile(_image!);

                                  final String imageURL =
                                      await task.ref.getDownloadURL();
                                  final String imagePath = task.ref.fullPath;

                                  final profData = await <String, String>{
                                    'motoName': _motoName!,
                                    'coverImageURL': imageURL,
                                    'coverImagePath': imagePath
                                  };
                                  await FirebaseFirestore.instance
                                      .collection('test')
                                      .doc(userId)
                                      .collection('profileData')
                                      .doc('profile')
                                      .set(profData);

                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.black),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                              visible: caution,
                              child: const Text(
                                'Enter motorcycle name and select cover photo.',
                                style: TextStyle(color: Colors.red),
                              )),
                          Visibility(
                              visible: loading,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ))
                        ],
                      )),
                      Expanded(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 8 / 10,
                        child: _image != null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                            : Container(),
                      ))
                    ],
                  ))
                ],
              ),
            ),
          );
  }
}
