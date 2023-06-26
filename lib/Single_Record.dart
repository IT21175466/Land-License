import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SingleRecord extends StatefulWidget {
  String? id;
  SingleRecord({this.id});

  @override
  State<SingleRecord> createState() => _SingleRecordState(id);
}

class _SingleRecordState extends State<SingleRecord> {
  bool loading = false;
  bool imageLoading = false;
  String? id;
  _SingleRecordState(this.id);

  String? licenseNumber;
  String? licenseName;
  String? licenseAddress;
  String? licenseWasama;
  String? frontImageUrl;
  String? backImageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData(id!);
    });
  }

  void deleteData(String uId) async {
    await FirebaseFirestore.instance
        .collection('All_Land_Licenses')
        .doc(uId)
        .delete();
  }

  void deleteStorageFolder(String folderPath) async {
    final storageReference = FirebaseStorage.instance.ref().child(folderPath);
    await storageReference.delete();
  }

  void getData(String uId) async {
    setState(() {
      loading = true;
    });
    final DocumentSnapshot licenseDoc = await FirebaseFirestore.instance
        .collection("All_Land_Licenses")
        .doc(uId)
        .get();

    setState(() {
      licenseNumber = licenseDoc.get('License_Number');
      licenseName = licenseDoc.get('License_Name');
      licenseAddress = licenseDoc.get('License_Address');
      licenseWasama = licenseDoc.get('License_Wasama');
      frontImageUrl = licenseDoc.get('front_img_url');
      backImageUrl = licenseDoc.get('back_image_url');
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: FittedBox(
          child: Text(
            "බලපත්‍ර විස්තර",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: loading
          ? AlertDialog(
              title: Text("මඳක් රැඳී සිටින්න..."),
              content: SizedBox(
                height: 100.h,
                width: 100.h,
                child: Center(
                  child: Column(
                    children: [
                      Text("දත්ත ලබාගනිමින් පවතී."),
                      SizedBox(
                        height: 20.h,
                      ),
                      CircularProgressIndicator(
                        color: Colors.blueAccent,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[],
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Column(
                  children: [
                    Text(
                      id!,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(100, 277, 239, 251),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            'බලපත්‍ර අංකය :',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            '$licenseNumber',
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(100, 277, 239, 251),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            'බලපත්‍ර හිමියාගේ නම :',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            '$licenseName',
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(100, 277, 239, 251),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            'බලපත්‍ර හිමියාගේ ලිපිනය :',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            '$licenseAddress',
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(100, 277, 239, 251),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            'වසම :',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            '$licenseWasama',
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'බලපත්‍රයේ චායාරූප',
                      style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (frontImageUrl != null)
                      Image.network(
                        frontImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (backImageUrl != null)
                      Image.network(
                        backImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text("පණිවිඩයක්!"),
                              content: Text(
                                  "මෙම බලපත්‍රය සහ එම තොරතුරු සියල්ල ඉවත් වී යයි. ඔබට ඉවත් කිරීමට අවශ්‍යද?"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "ඔව්. ඉවත් කරන්න",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  onPressed: () {
                                    print(id!);
                                    deleteData(id!);
                                    deleteStorageFolder('images/$id');
                                    Navigator.of(dialogContext).pop();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/home', (route) => false);
                                  },
                                ),
                                TextButton(
                                  child: Text("නැත"),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Colors.redAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                        ),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(370.w, 65.h)),
                      ),
                      child: Text(
                        'බලපත්‍රය ඉවත් කරන්න',
                        style: TextStyle(
                          fontSize: 15.h,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
