import 'dart:ffi';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'home.dart';

class Result extends StatefulWidget {
  final String scannedText;
const Result({super.key,required this.scannedText});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final reference = FirebaseDatabase.instance.ref('Sheet1');
  double foodScore=0;

  @override
  Widget build(BuildContext context) {

    // print(widget.scannedText);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E0),
       appBar: AppBar(
         title: const Text("Scan Again",style: TextStyle(fontFamily: "Quicksand",fontWeight: FontWeight.bold),),
         scrolledUnderElevation: 0,
         // centerTitle: true,
         elevation: 0,
         backgroundColor: Colors.transparent,
       ),
       body: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.deepPurpleAccent)
                ),
                child: Text("${widget.scannedText}",style: const TextStyle(fontSize: 15),),
              ),
              const SizedBox(height: 10,),
              Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(25),
                ),
                child:  FirebaseAnimatedList(
                  physics: const BouncingScrollPhysics(),
                  query: reference,
                  itemBuilder: (context,snapshot,animation,index) {
                    final value=snapshot.child('Ingredients').value.toString().toLowerCase();


                    if(widget.scannedText.toLowerCase().contains(value) ) {
                      double percentage=0;
                      int index = widget.scannedText.toLowerCase().indexOf(value);
                      try{
                        if (index != -1) {
                          int startIndex = index + value.length;
                          int endIndex = startIndex + 5;

                          if (endIndex <= widget.scannedText.length) {
                            String extractedText = widget.scannedText
                                .substring(startIndex, endIndex);
                            extractedText =
                                extractedText.replaceAll("(", "");
                            extractedText =
                                extractedText.replaceAll(")", "");
                            extractedText =
                                extractedText.replaceAll("%", "");
                            percentage = double.parse(extractedText);
                            // print("Substring found at index $index");
                            // print("Extracted text: $extractedText");

                          }
                        }
                      } catch(exception) { }
                      print((double.parse(snapshot.child('Label').value!.toString())));
                      percentage!=0 ? foodScore=foodScore+percentage*(double.parse(snapshot.child('Label').value!.toString()))//ingredients to check
                                    : foodScore=foodScore+5*(double.parse(snapshot.child('Label').value!.toString()));

                      print(foodScore);

                       return Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: ListTile(
                          tileColor: Colors.white,
                          shape: const StadiumBorder(),
                          leading: Text(index.toString()),
                          title: percentage!=0?Text("${snapshot.child('Ingredients').value.toString()} ($percentage)")
                                              :Text("${snapshot.child('Ingredients').value.toString()} -"),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              snapshot.child('Source Type').value.toString() == "Natural" ?
                              /*condition if(Natural) */ Text("Healthy: ${snapshot.child('Healthy').value.toString()}", style: const TextStyle(color: Colors.green),)
                              /* else */ : Text("Unhealhty: ${snapshot.child('Unhealthy').value.toString()}",
                                style: const TextStyle(color: Colors.red),)
                            ],
                          ),
                                                   ),
                       );
                    } else {
                      return const Text("",style: TextStyle(fontSize: 0),);
                    }
                  },),
              ),
              const Spacer(),
              Container(
                height: 150,
                  width: 150,
                  child: CircularBarGraph(foodScore)
              ),
            ],
          ),

    );
  }

}
class DataPoint {
  final String category;
  final double value;
  final charts.Color color;


  DataPoint(this.category, this.value, this.color);
}

class CircularBarGraph extends StatelessWidget {
  final double foodScore;

  CircularBarGraph(this.foodScore);

  @override
  Widget build(BuildContext context) {
    print("$foodScore this is inside the chart");
    return charts.PieChart(
      _createSeriesList(),
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  List<charts.Series<DataPoint, String>> _createSeriesList() {
     final List<DataPoint> chartData = [
          DataPoint('Food Score', foodScore, charts.Color.fromHex(code: '#00C853')), // Green color for foodScore
          DataPoint('Remaining', (100 - foodScore), charts.Color.fromHex(code: '#FF5722')), // Red color for remaining
     ];
      return [
         charts.Series<DataPoint, String>(
           id: 'data',
           domainFn: (DataPoint dataPoint, _) => dataPoint.category,
           measureFn: (DataPoint dataPoint, _) => dataPoint.value,
           colorFn: (DataPoint dataPoint, _) => dataPoint.color,
           data: chartData,
      ),
    ];
  }
}
