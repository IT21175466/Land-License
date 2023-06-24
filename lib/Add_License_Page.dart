import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddLicense extends StatefulWidget {
  const AddLicense({super.key});

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
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
    });
  }

  Future getFrontImage() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      frontImage = File(image!.path);
    });
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
      body: SingleChildScrollView(
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
                                fontSize: 20, fontWeight: FontWeight.w500),
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
                                fontSize: 20, fontWeight: FontWeight.w500),
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
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Colors.blueAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(370, 65)),
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
