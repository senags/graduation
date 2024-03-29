import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motophoty/cameraRoll.dart';
import 'package:motophoty/myPage.dart';

class homePage extends StatefulWidget {
  const homePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  //UserProfileを渡す用
  String motoName = '';
  String coverURL = '';
  String userID = '';

  //firestorageの設定
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final db = FirebaseFirestore.instance;

  //選択フラグ
  bool sliderIsVisible = false;
  bool img1IsSelected = false;
  bool img2IsSelected = false;
  bool img3IsSelected = false;
  bool img4IsSelected = false;

  //ペインターの指定
  selectedPaint() {
    if (img1IsSelected == true) {
      return painter1();
    } else if (img2IsSelected == true) {
      return painter2();
    } else if (img3IsSelected == true) {
      return painter3();
    } else if (img4IsSelected == true) {
      return painter4();
    }
  }

  //写真に枠線をつけるための準備
  Color? border1Color() {
    if (img1IsSelected == true) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Color? border2Color() {
    if (img2IsSelected == true) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Color? border3Color() {
    if (img3IsSelected == true) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Color? border4Color() {
    if (img4IsSelected == true) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  //カメラの初期化
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      img3IsSelected = false;
      img4IsSelected = false;
    }

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      img1IsSelected = false;
      img2IsSelected = false;
    }

    return MediaQuery.of(context).orientation == Orientation.portrait
        ? //縦向きのUI
        PopScope(
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                toolbarHeight: 75,
                title: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('MOTO Photy',
                      style: GoogleFonts.blackOpsOne(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.white),
                      )),
                ),
                actions: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                            onTap: () async {
                              String? motoName;
                              String? coverURL;

                              final auth = FirebaseAuth.instance;
                              final uid = auth.currentUser?.uid.toString();

                              final docRef = await FirebaseFirestore.instance
                                  .collection('test')
                                  .doc(uid)
                                  .collection('profileData')
                                  .doc('profile');

                              await docRef.get().then(
                                (value) async {
                                  final data = await value.data()
                                      as Map<String, dynamic>;
                                  motoName = data['motoName'];
                                  coverURL = data['coverImageURL'];
                                },
                              );

                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (builder) {
                                return myPage(
                                    motoName: motoName!, coverURL: coverURL!);
                              }));
                            },
                            child: const Icon(
                              Icons.account_circle,
                            )),
                      ),
                    ],
                  )
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: FutureBuilder<void>(
                            future: _initializeControllerFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.white, width: 60),
                                        left: BorderSide(
                                            color: Colors.white, width: 15),
                                        right: BorderSide(
                                            color: Colors.white, width: 15),
                                        top: BorderSide(
                                            color: Colors.white, width: 15))),
                                child: CameraPreview(
                                  _controller,
                                  child: CustomPaint(painter: selectedPaint()),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //テンプレ選択のアイコン
                              Visibility(
                                visible: !sliderIsVisible,
                                child: Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 35),
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              sliderIsVisible = true;
                                            });
                                          },
                                          child: const Icon(Icons.aspect_ratio,
                                              color: Colors.white, size: 40)),
                                    )),
                              ),
                              Visibility(
                                  visible: sliderIsVisible,
                                  child: const SizedBox(width: 10)),
                              Visibility(
                                  visible: sliderIsVisible,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    //戻るボタン
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            sliderIsVisible = false;
                                          });
                                        },
                                        child: const Icon(Icons.reply,
                                            color: Colors.white, size: 40)),
                                  )),
                              Visibility(
                                visible: sliderIsVisible,
                                child: Expanded(
                                    flex: 3,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          //テンプレ一覧のスライダー
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: border1Color()!,
                                                      width: 5)),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (img1IsSelected ==
                                                          true) {
                                                        img1IsSelected = false;
                                                      } else {
                                                        img1IsSelected = true;
                                                        img2IsSelected = false;
                                                        img3IsSelected = false;
                                                        img4IsSelected = false;
                                                      }
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero)),
                                                  child: Image.asset(
                                                      'assets/images/sample1.jpg'))),
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: border2Color()!,
                                                      width: 5)),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (img2IsSelected ==
                                                          true) {
                                                        img2IsSelected = false;
                                                      } else {
                                                        img1IsSelected = false;
                                                        img2IsSelected = true;
                                                        img3IsSelected = false;
                                                        img4IsSelected = false;
                                                      }
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero)),
                                                  child: Image.asset(
                                                      'assets/images/sample2.jpg'))),
                                        ],
                                      ),
                                    )),
                              ),
                              Expanded(
                                  //写真撮影のボタン
                                  flex: 2,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          //写真データの準備
                                          await _initializeControllerFuture;
                                          final image =
                                              await _controller.takePicture();
                                          if (!context.mounted) return;

                                          //storeとstorageの連携
                                          final now = DateTime.now();
                                          String path =
                                              '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';

                                          //firestorageに保存
                                          final File file = File(image.path);
                                          final task = await storageRef
                                              .child(path)
                                              .putFile(file);

                                          final auth = FirebaseAuth.instance;
                                          final uid =
                                              auth.currentUser?.uid.toString();

                                          //firestore用のデータ
                                          final String imageURL =
                                              await task.ref.getDownloadURL();
                                          final String imagePath =
                                              task.ref.fullPath;
                                          final data = {
                                            'imageURL': imageURL,
                                            'imagePath': imagePath,
                                            'createdAt': Timestamp.now()
                                          };

                                          await db
                                              .collection('test')
                                              .doc(uid)
                                              .collection('photoData')
                                              .doc()
                                              .set(data);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(65, 65),
                                          shape: const CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.white))),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.black, size: 30))),
                              Visibility(
                                visible: !sliderIsVisible,
                                child: Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (builder) {
                                                return cameraRoll();
                                              }));
                                            },
                                            child: const Icon(
                                              Icons.photo,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )
        : //<<  横向きのUI  >>
        PopScope(
            canPop: false,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  return Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.white,
                                                  width: 15),
                                              left: BorderSide(
                                                  color: Colors.white,
                                                  width: 15),
                                              right: BorderSide(
                                                  color: Colors.white,
                                                  width: 15),
                                              top: BorderSide(
                                                  color: Colors.white,
                                                  width: 15))),
                                      child: CameraPreview(_controller,
                                          child: CustomPaint(
                                              painter: selectedPaint())));
                                },
                              )),
                          const SizedBox(width: 5),
                          //右側のツールバー
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !sliderIsVisible,
                                  child: Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (builder) {
                                                  return cameraRoll();
                                                }));
                                              },
                                              child: const Icon(
                                                Icons.photo,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                Visibility(
                                    visible: !sliderIsVisible,
                                    child: const SizedBox(
                                      height: 20,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            //写真データの準備
                                            await _initializeControllerFuture;
                                            final image =
                                                await _controller.takePicture();
                                            if (!context.mounted) return;

                                            //storeとstorageの連携
                                            final now = DateTime.now();
                                            String path =
                                                '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';

                                            //firestorageに保存
                                            final File file = File(image.path);
                                            final task = await storageRef
                                                .child(path)
                                                .putFile(file);

                                            final auth = FirebaseAuth.instance;
                                            final uid = auth.currentUser?.uid
                                                .toString();

                                            //firestore用のデータ
                                            final String imageURL =
                                                await task.ref.getDownloadURL();
                                            final String imagePath =
                                                task.ref.fullPath;
                                            final data = {
                                              'imageURL': imageURL,
                                              'imagePath': imagePath,
                                              'createdAt': Timestamp.now()
                                            };

                                            await db
                                                .collection('test')
                                                .doc(uid)
                                                .collection('photoData')
                                                .doc()
                                                .set(data);
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(65, 65),
                                            shape: const CircleBorder(
                                                side: BorderSide(
                                                    width: 5,
                                                    color: Colors.white))),
                                        child: const Icon(Icons.camera_alt,
                                            color: Colors.black, size: 30))),
                                Visibility(
                                    visible: !sliderIsVisible,
                                    child: const SizedBox(
                                      height: 20,
                                    )),
                                Visibility(
                                  visible: !sliderIsVisible,
                                  child: Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  sliderIsVisible = true;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.aspect_ratio,
                                                  color: Colors.white,
                                                  size: 40)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: sliderIsVisible,
                                    child: Expanded(
                                        flex: 2,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              border3Color()!,
                                                          width: 5)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (img3IsSelected ==
                                                              true) {
                                                            img3IsSelected =
                                                                false;
                                                          } else {
                                                            img1IsSelected =
                                                                false;
                                                            img2IsSelected =
                                                                false;
                                                            img3IsSelected =
                                                                true;
                                                            img4IsSelected =
                                                                false;
                                                          }
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                          padding:
                                                              MaterialStateProperty
                                                                  .all(EdgeInsets
                                                                      .zero)),
                                                      child: Image.asset(
                                                          'assets/images/sample3.jpg'))),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              border4Color()!,
                                                          width: 5)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (img4IsSelected ==
                                                              true) {
                                                            img4IsSelected =
                                                                false;
                                                          } else {
                                                            img1IsSelected =
                                                                false;
                                                            img2IsSelected =
                                                                false;
                                                            img3IsSelected =
                                                                false;
                                                            img4IsSelected =
                                                                true;
                                                          }
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                          padding:
                                                              MaterialStateProperty
                                                                  .all(EdgeInsets
                                                                      .zero)),
                                                      child: Image.asset(
                                                          'assets/images/sample4.jpg'))),
                                            ],
                                          ),
                                        ))),
                                Visibility(
                                    visible: sliderIsVisible,
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            sliderIsVisible = false;
                                          });
                                        },
                                        child: const Icon(Icons.reply,
                                            color: Colors.white, size: 30))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class painter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    Path path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 55 / 100, h * 85 / 100);
    path.quadraticBezierTo(
        w * 35 / 100, h * 85 / 100, w * 50 / 100, h * 53 / 100);
    path.quadraticBezierTo(
        w * 70 / 100, h * 20 / 100, w * 85 / 100, h * 25 / 100);
    path.quadraticBezierTo(w, h * 30 / 100, w * 90 / 100, h * 50 / 100);
    path.quadraticBezierTo(
        w * 75 / 100, h * 85 / 100, w * 55 / 100, h * 85 / 100);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class painter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    Path path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 15 / 100, h * 90 / 100);
    path.quadraticBezierTo(
        w * 0 / 100, h * 85 / 100, w * 10 / 100, h * 70 / 100);
    path.quadraticBezierTo(
        w * 15 / 100, h * 60 / 100, w * 25 / 100, h * 60 / 100);
    path.quadraticBezierTo(
        w * 40 / 100, h * 60 / 100, w * 32 / 100, h * 78 / 100);
    path.quadraticBezierTo(
        w * 25 / 100, h * 91 / 100, w * 15 / 100, h * 90 / 100);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class painter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    Path path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 5 / 100, h * 60 / 100);
    path.quadraticBezierTo(
        w * 10 / 100, h * 45 / 100, w * 20 / 100, h * 50 / 100);
    path.quadraticBezierTo(
        w * 45 / 100, h * 60 / 100, w * 38 / 100, h * 85 / 100);
    path.quadraticBezierTo(w * 30 / 100, h, w * 10 / 100, h * 83 / 100);
    path.quadraticBezierTo(
        w * 3 / 100, h * 75 / 100, w * 5 / 100, h * 60 / 100);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class painter4 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    Path path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 60 / 100, h);
    path.quadraticBezierTo(
        w * 59 / 100, h * 50 / 100, w * 65 / 100, h * 30 / 100);
    path.lineTo(w, h * 30 / 100);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
