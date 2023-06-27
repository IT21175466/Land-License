import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  int documentCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentCount();
  }

  void showDialogBox() {
    AlertDialog(
      title: Text("දෝශයකි! "),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Column(
            children: [
              Text(
                  "අන්තර්ජාලය සමඟ සම්බන්ධ වී නැත.\n (Please Turn On WiFi or Mobile Data))"),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[],
    );
  }

  void getDocumentCount() {
    FirebaseFirestore.instance
        .collection('All_Land_Licenses')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        documentCount = snapshot.docs.length;
        print(documentCount);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        backgroundColor: Colors.blueAccent,
        title: FittedBox(
          child: Text(
            "Land License Management System",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 230, 251),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: Icon(
                      Icons.done,
                      size: 15.h,
                    ),
                    title: Row(
                      children: [
                        Spacer(),
                        FittedBox(
                          child: Text(
                            "දැනට ඇති බලපත්‍ර සංඛ්‍යාව - ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(12),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            '$documentCount',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Image.asset('lib/images/document.png'),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/addLicensePage');
                },
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 230, 251),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(
                        Icons.add_circle_rounded,
                        color: Colors.blueAccent,
                        size: 25.h,
                      ),
                      title: Text(
                        "නව බලපත්‍රයක් එකතු කරන්න.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/searchLicense');
                },
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 230, 251),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(
                        Icons.search_rounded,
                        color: Colors.blueAccent,
                        size: 25.h,
                      ),
                      title: Text(
                        "බලපත්‍රයක් සොයන්න.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
