import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:land_license/Single_Record.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: FittedBox(
            child: Text(
              "බලපත්‍රයක් සොයන්න",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          color: Color(0XFFEEEFF5),
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 10.w,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.h,
                ),
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0.h),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 17.h,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 20.h,
                          minWidth: 25.h,
                        ),
                        border: InputBorder.none,
                        hintText: 'සොයන්න',
                        hintStyle: TextStyle(
                          fontSize: 15.h,
                        )),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        search = value.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'බලපත්‍ර ලයිස්තුව',
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
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
                                      fontSize: 18.h,
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
                                              fontSize: 16.h,
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.h),
                              color: Colors.white,
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
                                      fontSize: 18.h,
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
                                              fontSize: 16.h,
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
      ),
    );
  }
}
