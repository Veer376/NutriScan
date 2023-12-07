import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final reference = FirebaseDatabase.instance.ref('Sheet1');
  List<String> ingredients=["lecithin","xanthan gum","disodium edta"];


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
          Expanded(
            child: FirebaseAnimatedList(
              query: reference,
              itemBuilder: (
                  context,snapshot,animation,index) {
                final value=snapshot.child('Ingredients').value.toString().toLowerCase();

                return ingredients.contains(value) ?ListTile(

                  leading: Text(index.toString()),
                  title: Text(snapshot.child('Ingredients').value.toString()),
                  subtitle: Column(
                    children: [
                      Text(snapshot.child('Source Type').value.toString(),style: const TextStyle(color: Colors.orangeAccent),),
                      Text("Healthy: ${snapshot.child('Healthy').value.toString()}",style: const TextStyle(color: Colors.redAccent),),
                      Text("Unhealhty: ${snapshot.child('Unhealthy').value.toString()}",style: const TextStyle(color: Colors.green),)
                    ],
                  ),
                ):const Text("",style: TextStyle(fontSize: 0),);
              },),
          )

        ],
      )
    );
  }

}
