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
       body: //loading?const Center(
      //   child: CircularProgressIndicator(),
      // ):
      //  Flex(
      //   direction: Axis.vertical, // or Axis.horizontal, depending on your layout
      //   children: [
      //     Expanded(
      //       flex: 1,
      //       child: FirebaseAnimatedList(
      //         query: reference,
      //         itemBuilder: (
      //             context,snapshot,animation,index) {
      //           final value=snapshot.child('Ingredients').value.toString().toLowerCase();
      //
      //           return ingredients.contains(value) ?ListTile(
      //
      //             leading: Text(index.toString()),
      //             title: Text(snapshot.child('Ingredients').value.toString()),
      //             subtitle: Text(snapshot.child('Source Type').value.toString()),
      //           ):const Text("",style: TextStyle(fontSize: 0),);
      //         },),
      //     ),
      //     // Other children of the Flex widget
      //   ],
      // )
      Column(
        children: [
          const SizedBox(height: 50,),
          Image.asset("assets/foodImage.png",width: 430,height: 300,)
        ],
      )
    );
  }

}
