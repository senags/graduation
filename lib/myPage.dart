import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motophoty/editPage.dart';
import 'package:motophoty/loginPage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/cupertino.dart';

class myPage extends StatefulWidget {
  myPage({super.key, required this.motoName, required this.coverURL});

  late String motoName;
  late String coverURL;

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  //メニューバーを右から出す用
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //firestorage,storeの設定
  final storageRef = FirebaseStorage.instance.ref();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid.toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 75,
        title: Text('MOTO Photy',
            style: GoogleFonts.blackOpsOne(
              textStyle: const TextStyle(
                  fontSize: 25, letterSpacing: 2, color: Colors.white),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: const Icon(
                  Icons.settings,
                )),
          )
        ],
      ),
      key: _scaffoldKey,
      endDrawer: SafeArea(
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return editPage();
                        }));
                      },
                      child: Text(
                        'Edit profile',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.logout),
                    TextButton(
                      onPressed: () {
                        final camera = availableCameras();
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (builder) {
                          return loginPage(camera: camera);
                        }));
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ?
          //縦向きのUI
          SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Image.network(
                          widget.coverURL,
                          fit: BoxFit.cover,
                        )),
                    //文字用

                    Expanded(
                        flex: 2,
                        child: Container(
                          // color: Colors.black,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                child: Text(widget.motoName,
                                    style: GoogleFonts.notoSerif(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text('Your Photo',
                            style: GoogleFonts.notoSerif(
                                textStyle: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white))),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: db
                                    .collection('test')
                                    .doc(uid)
                                    .collection('photoData')
                                    .orderBy('createdAt', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ));
                                  } else {
                                    final QuerySnapshot query = snapshot.data!;
                                    final List<String> imageList = query.docs
                                        .map((doc) =>
                                            doc.get('imageURL') as String)
                                        .toList();
                                    final List<String> pathList = query.docs
                                        .map((doc) =>
                                            doc.get('imagePath') as String)
                                        .toList();

                                    return GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemCount: imageList.length,
                                        itemBuilder: (context, index) {
                                          return Material(
                                            color: Colors.black,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: InkWell(
                                                onTap: () async {
                                                  openPhotoGallery(
                                                      context,
                                                      index,
                                                      imageList,
                                                      pathList);
                                                },
                                                child: Image.network(
                                                    imageList[index],
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : //横向きのUI
          SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.network(
                        widget.coverURL,
                        fit: BoxFit.fitWidth,
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.motoName,
                                    style: GoogleFonts.notoSerif(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Text('Your Photo >>',
                                    style: GoogleFonts.notoSerif(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                // const SizedBox(width: double.infinity)
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: StreamBuilder(
                              stream: db
                                  .collection('test')
                                  .doc(uid)
                                  .collection('photoData')
                                  .orderBy('createdAt', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData == false) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                                } else {
                                  final QuerySnapshot query = snapshot.data!;
                                  final List<String> imageList = query.docs
                                      .map((doc) =>
                                          doc.get('imageURL') as String)
                                      .toList();

                                  final List<String> pathList = query.docs
                                      .map((doc) =>
                                          doc.get('imagePath') as String)
                                      .toList();

                                  return GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1),
                                      itemCount: imageList.length,
                                      itemBuilder: (context, index) {
                                        return Material(
                                          color: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: InkWell(
                                              onTap: () async {
                                                openPhotoGallery(context, index,
                                                    imageList, pathList);
                                              },
                                              child: Image.network(
                                                  imageList[index],
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

//ビューワー用
Future<void> openPhotoGallery(BuildContext context, int initialIndex,
    List imageList, List pathList) async {
  await showDialog(
      context: context,
      builder: (context) {
        return GalleryScreen(
          imageList: imageList,
          initialIndex: initialIndex,
          pathList: pathList,
        );
      });
}

//ビューワーを作る
class GalleryScreen extends StatelessWidget {
  late List imageList;
  final int initialIndex;
  late List pathList;

  //index番号取得用
  late String selectedPhoto;

  GalleryScreen(
      {super.key,
      required this.imageList,
      required this.initialIndex,
      required this.pathList});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: PhotoViewGallery.builder(
              itemCount: imageList.length,
              builder: (context, index) {
                selectedPhoto = pathList[index];
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageList[index]),
                    initialScale: PhotoViewComputedScale.contained);
              },
              pageController: PageController(initialPage: initialIndex),
              backgroundDecoration:
                  const BoxDecoration(color: Color.fromARGB(100, 0, 0, 0)),
            ),
          )),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 50, 0, 0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  final auth = FirebaseAuth.instance;
                  final uid = auth.currentUser?.uid.toString();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          content: const Text('本当に削除しますか？'),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            CupertinoDialogAction(
                              onPressed: () async {
                                String? selectedRef;
                                await FirebaseFirestore.instance
                                    .collection('test')
                                    .doc(uid)
                                    .collection('photoData')
                                    .where('imagePath',
                                        isEqualTo: selectedPhoto)
                                    .get()
                                    .then((value) {
                                  selectedRef = value.docs[0].id;
                                });

                                FirebaseFirestore.instance
                                    .collection('test')
                                    .doc(uid)
                                    .collection('photoData')
                                    .doc(selectedRef)
                                    .delete();
                                FirebaseStorage.instance
                                    .ref()
                                    .child(selectedPhoto)
                                    .delete();

                                Navigator.pop(context);
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.delete, color: Colors.white))
          ],
        ),
      ),
    ]);
  }
}
