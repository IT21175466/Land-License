import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:land_license/Home_Page.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLicense extends StatefulWidget {
  const AddLicense({super.key});

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
  ProgressDialog? pd;
  String docID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docID = generateRandomId();
  }

  final storage = FirebaseStorage.instance;

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  String frontImageUrl = '';
  String backImageUrl = '';

  bool loading = false;
  bool uploaded = false;
  bool uploadedFrontImage = false;

  TextEditingController _LicenseNumberController = TextEditingController();
  TextEditingController _LicenseNameController = TextEditingController();
  TextEditingController _LicenseAddressController = TextEditingController();
  TextEditingController _LicenseWasamaController = TextEditingController();

  File? frontImage;
  File? backImage;

  final imagePicker = ImagePicker();

  Future getBackImage() async {
    final bImage = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 70);

    setState(() {
      backImage = File(bImage!.path);
      print(bImage.path);
      uploaded = true;
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(docID);

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      setState(() {
        loading = true;
        uploaded = true;
      });

      UploadTask uploadTask =
          referenceImageToUpload.putFile(File(bImage!.path));

      uploadTask.then((TaskSnapshot taskSnapshot) async {
        if (taskSnapshot.state == TaskState.success) {
          // Upload completed successfully
          setState(() {
            loading = false;
            uploaded = true;
          });
        }
        backImageUrl = await referenceImageToUpload.getDownloadURL();
      }).catchError((error) {
        // Error during upload
        setState(() {
          loading = false;
        });
        print("Error uploading image: $error");
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteImages() async {
    try {
      final ListResult list =
          await FirebaseStorage.instance.ref(docID).listAll();
      final List<Reference> items = list.items;

      for (Reference item in items) {
        await item.delete();
      }

      //Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (e) {
      print('Error deleting images: $e');
    }
  }

  Future getFrontImage() async {
    final image = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 70);

    setState(() {
      frontImage = File(image!.path);
      print(image.path);
      uploadedFrontImage = true;
      print(uploaded);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(docID);

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      setState(() {
        loading = true;
        uploadedFrontImage = true;
      });

      UploadTask uploadTask = referenceImageToUpload.putFile(File(image!.path));
      uploadTask.then((TaskSnapshot taskSnapshot) async {
        if (taskSnapshot.state == TaskState.success) {
          // Upload completed successfully
          setState(() {
            loading = false;
            uploadedFrontImage = true;
          });
        }
        frontImageUrl = await referenceImageToUpload.getDownloadURL();
      }).catchError((error) {
        // Error during upload
        setState(() {
          loading = false;
        });
        print("Error uploading image: $error");
      });
    } catch (error) {
      loading = false;
    }
  }

  void emptyFileds() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("දෝශයකි..!"),
          content: Text("කරුණාකර තොරතුරු සියල්ල පුරවන්න."),
          actions: <Widget>[
            TextButton(
              child: Text("හරි"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void alreadyUploaded() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          //title: Text("දෝශයකි..!"),
          content: Text("දැනටමත් චායාරූපයක් ඇතුලත් කර තිබේ.!"),
          actions: <Widget>[
            TextButton(
              child: Text("හරි"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void emptyImages() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("දෝශයකි..!"),
          content: Text("කරුණාකර බලපත්‍ර වල චායාරූප එක් කරන්න."),
          actions: <Widget>[
            TextButton(
              child: Text("හරි"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> backPressed(BuildContext context) async {
    if (uploaded == true ||
        uploadedFrontImage == true ||
        uploaded && uploadedFrontImage == true) {
      print(docID);
      deleteImages();

      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return WillPopScope(
      onWillPop: () async {
        backPressed(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: FittedBox(
            child: Text(
              "බලපත්‍රයක් එකතුකරන්න",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 10.h,
            ),
            child: loading
                ? AlertDialog(
                    title: Text("මඳක් රැඳී සිටින්න..."),
                    content: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Column(
                          children: [
                            Text("දත්ත ලබාගනිමින් පවතී."),
                            SizedBox(
                              height: 20,
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
                : SizedBox(
                    child: Column(
                      children: [
                        TextField(
                          controller: _LicenseNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'බලපත්‍ර අංකය',
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextField(
                          controller: _LicenseNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'හිමිකරුගේ නම',
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextField(
                          controller: _LicenseAddressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'ලිපිනය',
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextField(
                          controller: _LicenseWasamaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'ග්‍රාම නිලධාරී වසම',
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "බලපත්‍රයේ චායාරූප එකතු කරන්න.",
                          style: TextStyle(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            const Spacer(),
                            if (uploadedFrontImage == true)
                              GestureDetector(
                                onTap: () {
                                  alreadyUploaded();
                                },
                                child: Container(
                                  width: 146.w,
                                  height: 112.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color:
                                        const Color.fromARGB(50, 277, 277, 277),
                                    image: frontImage != null
                                        ? DecorationImage(
                                            image: FileImage(frontImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.document_scanner,
                                        size: 40.h,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "ඉදිරිපස",
                                        style: TextStyle(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  getFrontImage();
                                },
                                child: Container(
                                  width: 146.w,
                                  height: 112.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color:
                                        const Color.fromARGB(50, 277, 277, 277),
                                    image: frontImage != null
                                        ? DecorationImage(
                                            image: FileImage(frontImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.document_scanner,
                                        size: 40.h,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "ඉදිරිපස",
                                        style: TextStyle(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            const Spacer(),
                            if (uploaded == true)
                              GestureDetector(
                                onTap: () {
                                  alreadyUploaded();
                                },
                                child: Container(
                                  width: 146.w,
                                  height: 112.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color:
                                        const Color.fromARGB(50, 277, 277, 277),
                                    image: backImage != null
                                        ? DecorationImage(
                                            image: FileImage(backImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.document_scanner,
                                        size: 40.h,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "පිටුපස",
                                        style: TextStyle(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  getBackImage();
                                },
                                child: Container(
                                  width: 146.w,
                                  height: 112.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color:
                                        const Color.fromARGB(50, 277, 277, 277),
                                    image: backImage != null
                                        ? DecorationImage(
                                            image: FileImage(backImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.document_scanner,
                                        size: 40.h,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "පිටුපස",
                                        style: TextStyle(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String lNumber = _LicenseNumberController.text;
                            String lName = _LicenseNameController.text;
                            String lAddress = _LicenseAddressController.text;
                            String lWasama = _LicenseWasamaController.text;

                            if (lNumber.isEmpty ||
                                lName.isEmpty ||
                                lAddress.isEmpty ||
                                lWasama.isEmpty) {
                              emptyFileds();
                            } else if (frontImage == null) {
                              emptyImages();
                            } else if (backImage == null) {
                              emptyImages();
                            } else {
                              print("Done");

                              setState(() {
                                loading = true;
                              });

                              FirebaseFirestore.instance
                                  .collection('All_Land_Licenses')
                                  .doc('$docID')
                                  .set({
                                'Doc_ID': docID,
                                'License_Number': lNumber,
                                'License_Name': lName,
                                'License_Address': lAddress,
                                'License_Wasama': lWasama,
                                'front_img_url': frontImageUrl,
                                'back_image_url': backImageUrl,
                              }).then((value) {
                                setState(() {
                                  loading = false;
                                  Future.delayed(Duration(seconds: 2), () {});
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text("සාර්ථකයි..!"),
                                      content: const Text(
                                        "තොරතුරු සාර්ථකව ඇතුලත් වී ඇත.",
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("හරි"),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                print("Data added successfully");
                              }).catchError((error) {
                                setState(() {
                                  loading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text("අසාර්ථකයි..!"),
                                      content:
                                          Text("දෝශයකි..! නැවත උත්සාහ කරන්න."),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("හරි"),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                print("Error adding data: $error");
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.blueAccent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(370.w, 55.h)),
                          ),
                          child: Text(
                            'බලපත්‍රය එකතු කරන්න',
                            style: TextStyle(
                              fontSize: 15.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
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
  }
}
