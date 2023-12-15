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
  List<String> ingredients=["Corn Grits","Sugar","Iodized Salt","Malt Extract", "Soy Lecithin", "Vitamins & Minerals Prefix", "Probiotics","Rosemary Extract"];
  List<String> Extractedingredients=[];

  @override
  Widget build(BuildContext context) {

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
          const SizedBox(height: 50,),
          // Expanded(
          //   child: FirebaseAnimatedList(
          //     query: reference,
          //     itemBuilder: (context,snapshot,animation,index) {
          //       final value=snapshot.child('Ingredients').value.toString().toLowerCase();
          //
          //       return ingredients.contains(value) ?ListTile(
          //
          //         leading: Text(index.toString()),
          //         title: Text(snapshot.child('Ingredients').value.toString()),
          //         subtitle: Column(
          //           children: [
          //             Text(snapshot.child('Source Type').value.toString(),style: const TextStyle(color: Colors.orangeAccent),),
          //             Text("Healthy: ${snapshot.child('Healthy').value.toString()}",style: const TextStyle(color: Colors.redAccent),),
          //             Text("Unhealhty: ${snapshot.child('Unhealthy').value.toString()}",style: const TextStyle(color: Colors.green),)
          //           ],
          //         ),
          //       ):const Text("",style: TextStyle(fontSize: 0),);
          //     },),
          // )
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 250,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(25),


                ),
                child: Text("ingredients"),
              ),
              Container(
                height: 300,
                  width: 300,
                  child: CircularBarGraph(data)),

            ],
          )



        ],
      )
    );
  }

}
class DataPoint {
  final String category;
  final int value;
  final charts.Color color;

  DataPoint(this.category, this.value, this.color);
}
List<DataPoint> data = [
  DataPoint('Category 1', 10, charts.MaterialPalette.blue.shadeDefault),
  DataPoint('Category 2', 20, charts.MaterialPalette.green.shadeDefault),
  DataPoint('Category 3', 15, charts.MaterialPalette.red.shadeDefault),
  // Add more data points as needed
];
class CircularBarGraph extends StatelessWidget {
  final List<DataPoint> data;

  CircularBarGraph(this.data);

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      _createSeriesList(),
      animate: true,
      animationDuration: Duration(milliseconds: 500),
    );
  }

  List<charts.Series<DataPoint, String>> _createSeriesList() {
    return [
      charts.Series<DataPoint, String>(
        id: 'data',
        domainFn: (DataPoint dataPoint, _) => dataPoint.category,
        measureFn: (DataPoint dataPoint, _) => dataPoint.value,
        colorFn: (DataPoint dataPoint, _) => dataPoint.color,
        data: data,
      ),
    ];
  }
}
