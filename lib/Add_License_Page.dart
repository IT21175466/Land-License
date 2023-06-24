import 'package:flutter/material.dart';

class AddLicense extends StatefulWidget {
  const AddLicense({super.key});

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
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
                    child: Container(
                      width: 146,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color.fromARGB(50, 277, 277, 277),
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
                    child: Container(
                      width: 146,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color.fromARGB(50, 277, 277, 277),
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
                onPressed: () {},
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
