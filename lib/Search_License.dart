import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:land_license/Single_Record.dart';

class SearchLicense extends StatefulWidget {
  const SearchLicense({super.key});

  @override
  State<SearchLicense> createState() => _SearchLicenseState();
}

class _SearchLicenseState extends State<SearchLicense> {
  final _landLicences =
      FirebaseFirestore.instance.collection('All_Land_Licenses').snapshots();

  String selectedIndex = '';

  TextEditingController _search = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "බලපත්‍රයක් සොයන්න",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(100, 277, 239, 251),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(),
              ),
              child: Center(
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search),
                      prefixIconConstraints: BoxConstraints(
                        maxHeight: 20,
                        minWidth: 25,
                      ),
                      border: InputBorder.none,
                      hintText: 'සොයන්න'),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      search = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder(
                stream: _landLicences,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Connection Error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading......");
                  }
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      if (_search.text.toString().isEmpty) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(100, 277, 239, 251),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      docs[index]['Doc_ID'].toString();
                                  print(selectedIndex);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SingleRecord(id: selectedIndex),
                                    ),
                                  );
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  docs[index]['License_Number'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        docs[index]['Doc_ID'],
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              0, 277, 239, 251),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          docs[index]['License_Name'] +
                                              '\n' +
                                              docs[index]['License_Wasama'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (docs[index]['License_Number']
                              .toLowerCase()
                              .contains(_search.text.toString()) ||
                          docs[index]['License_Name']
                              .toLowerCase()
                              .contains(_search.text.toString()) ||
                          docs[index]['License_Wasama']
                              .toLowerCase()
                              .contains(_search.text.toString())) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(100, 277, 239, 251),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      docs[index]['Doc_ID'].toString();
                                  print(selectedIndex);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SingleRecord(id: selectedIndex),
                                    ),
                                  );
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  docs[index]['License_Number'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        docs[index]['Doc_ID'],
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              0, 277, 239, 251),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          docs[index]['License_Name'] +
                                              '\n' +
                                              docs[index]['License_Wasama'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
