import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int documentCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentCount();
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
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Land License Management System",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 230, 251),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: Icon(Icons.done),
                    title: Row(
                      children: [
                        Spacer(),
                        Text(
                          "දැනට ඇති බලපත්‍ර සංඛ්‍යාව - ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$documentCount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/addLicensePage');
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 230, 251),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(
                        Icons.add_circle_rounded,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      title: Text(
                        "නව බලපත්‍රයක් එකතු කරන්න.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
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
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 230, 251),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(
                        Icons.search_rounded,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      title: Text(
                        "බලපත්‍රයක් සොයන්න.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
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
