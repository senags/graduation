import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motophoty/myPage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cameraRoll extends StatefulWidget {
  cameraRoll({super.key});

  @override
  State<cameraRoll> createState() => _cameraRollState();
}

class _cameraRollState extends State<cameraRoll> {
  //firestoreの設定
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid.toString();

    //縦向きのUI
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 75,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text('MOTO Photy',
              style: GoogleFonts.blackOpsOne(
                textStyle: const TextStyle(
                    fontSize: 25, letterSpacing: 2, color: Colors.white),
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
                          final data =
                              await value.data() as Map<String, dynamic>;
                          motoName = data['motoName'];
                          coverURL = data['coverImageURL'];
                        },
                      );

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (builder) {
                        return myPage(motoName: motoName!, coverURL: coverURL!);
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
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ?
          //縦向きのUI
          SafeArea(
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
                            .map((doc) => doc.get('imageURL') as String)
                            .toList();
                        final List<String> pathList = query.docs
                            .map((doc) => doc.get('imagePath') as String)
                            .toList();
                  
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () async {
                                      openPhotoGallery(
                                          context, index, imageList, pathList);
                                    },
                                    child: Image.network(imageList[index],
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  )),
                ],
              ),
            )
          : //横向きのUI
          SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
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
                                  .map((doc) => doc.get('imageURL') as String)
                                  .toList();
                  
                              final List<String> pathList = query.docs
                                  .map((doc) => doc.get('imagePath') as String)
                                  .toList();
                  
                              return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
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
                                          child: Image.network(imageList[index],
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
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
              pathList: pathList);
        });
  }
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
