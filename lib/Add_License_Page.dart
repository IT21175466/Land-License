import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddLicense extends StatefulWidget {
  const AddLicense({super.key});

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
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

  TextEditingController _LicenseNumberController = TextEditingController();
  TextEditingController _LicenseNameController = TextEditingController();
  TextEditingController _LicenseAddressController = TextEditingController();
  TextEditingController _LicenseWasamaController = TextEditingController();

  File? frontImage;
  File? backImage;

  final imagePicker = ImagePicker();

  Future getBackImage() async {
    final bImage = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      backImage = File(bImage!.path);
      print(bImage.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(docID);

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      setState(() {
        loading = true;
      });

      UploadTask uploadTask =
          referenceImageToUpload.putFile(File(bImage!.path));

      uploadTask.then((TaskSnapshot taskSnapshot) async {
        if (taskSnapshot.state == TaskState.success) {
          // Upload completed successfully
          setState(() {
            loading = false;
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

  Future getFrontImage() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      frontImage = File(image!.path);
      print(image.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(docID);

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      setState(() {
        loading = true;
      });
      UploadTask uploadTask = referenceImageToUpload.putFile(File(image!.path));
      uploadTask.then((TaskSnapshot taskSnapshot) async {
        if (taskSnapshot.state == TaskState.success) {
          // Upload completed successfully
          setState(() {
            loading = false;
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
    } catch (error) {}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "බලපත්‍රයක් එකතුකරන්න",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: loading
          ? const AlertDialog(
              title: Text("මඳක් රැඳී සිටින්න..."),
              content: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
              actions: <Widget>[],
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
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
                    const SizedBox(
                      height: 15,
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
                    const SizedBox(
                      height: 15,
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
                    const SizedBox(
                      height: 15,
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
                    const SizedBox(height: 40),
                    const Text(
                      "බලපත්‍රයේ චායාරූප එකතු කරන්න.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            getFrontImage();
                          },
                          child: Container(
                            width: 146,
                            height: 112,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: const Color.fromARGB(50, 277, 277, 277),
                              image: frontImage != null
                                  ? DecorationImage(
                                      image: FileImage(frontImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: const Column(
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.document_scanner,
                                  size: 40,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "ඉදිරිපස",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            getBackImage();
                          },
                          child: Container(
                            width: 146,
                            height: 112,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: const Color.fromARGB(50, 277, 277, 277),
                              image: backImage != null
                                  ? DecorationImage(
                                      image: FileImage(backImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: const Column(
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.document_scanner,
                                  size: 40,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "පිටුපස",
                                  style: TextStyle(
                                      fontSize: 20,
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
                    const SizedBox(
                      height: 50,
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
                          }).then((value) {
                            setState(() {
                              loading = false;
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
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/home', (route) => false);
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
                                  content: Text("දෝශයකි..! නැවත උත්සාහ කරන්න."),
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
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Colors.blueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(370, 65)),
                      ),
                      child: const Text(
                        'බලපත්‍රය එකතු කරන්න',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
