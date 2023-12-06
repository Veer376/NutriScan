import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'Result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool textScanning = false;
  String scannedText = "";

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage != null) {
        textScanning = true;

        CroppedFile? croppedImage=await ImageCropper().cropImage(sourcePath: pickedImage.path,cropStyle: CropStyle.rectangle,
            uiSettings: [IOSUiSettings(),AndroidUiSettings()]);

        getRecognisedText(XFile(croppedImage!.path));
      }
    } catch (e) {
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }
  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText ="";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    setState(() {});
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
              (textScanning)? Column(
                children: [
                  const Text("Scanned Text",textAlign: TextAlign.left,style: TextStyle(fontFamily: "Quicksand",fontSize: 20,fontWeight: FontWeight.w600),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.deepPurpleAccent
                      )

                    ),
                    height: 250,
                    width: double.infinity,
                    child: SingleChildScrollView(child: Text(scannedText)),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Result()));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                        ),
                      side: BorderSide(color: Colors.deepPurpleAccent)
                    ),
                    child: const Text(" Find Out! ", style: TextStyle(color: Colors.black,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),),

                  ),

                ],
              ):const Column(
                children: [
                  Text("Scan Now!", style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    fontFamily: "Quicksand",),),
                  SizedBox(height: 60,),
                  Icon(Icons.qr_code_scanner_rounded, size: 200,
                    color: Colors.orangeAccent,),
                ],
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
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
                        fontSize: 20),),

                  ),
                  const SizedBox(width: 15,),
                  IconButton(
                    padding: const EdgeInsets.all(12),
                    onPressed: (){
                      getImage(ImageSource.gallery);

                    },
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))),
                    ),
                    color: Colors.deepPurpleAccent,
                    icon: const Icon(Icons.image),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7E0),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
    );
  }
}


