import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    // textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(100),
          height: double.infinity,
          width: double.infinity,
          color: const Color(0xFFFFF7E0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              (textScanning)?Container(
                height: 200,
                width: double.infinity,
                child: SingleChildScrollView(child: Text(scannedText)),
              ):const Text("Scan Now!", style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                fontFamily: "Quicksand",),),
              const SizedBox(height: 100,),
              const Icon(Icons.qr_code_scanner_rounded, size: 200,
                color: Colors.orangeAccent,),
              // const SizedBox(height: 20,),
              TextButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                onLongPress: (){
                  getImage(ImageSource.camera);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))
                ),
                child: const Text("Scan", style: TextStyle(color: Colors.white,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w900,
                    fontSize: 22),),


              ),

            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7E0),
          elevation: 0,
        ),
      ),
    );
  }
}


