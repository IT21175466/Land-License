import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SingleRecord extends StatefulWidget {
  String? id;
  SingleRecord({this.id});

  @override
  State<SingleRecord> createState() => _SingleRecordState(id);
}

class _SingleRecordState extends State<SingleRecord> {
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

  void getData(String uId) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "බලපත්‍ර විස්තර",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
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
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '$licenseNumber',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
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
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '$licenseName',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
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
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '$licenseAddress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
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
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '$licenseWasama',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'බලපත්‍රයේ චායාරූප',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image.network(
                frontImageUrl!,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Image.network(
                backImageUrl!,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
