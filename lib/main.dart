import 'package:flutter/material.dart';
import 'package:nutriscan/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: OnBoarding(),
    debugShowCheckedModeBanner: false,
  ));
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final pageControl = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFFF7E0),
          primary: false,

        ),
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          controller: pageControl,
          children: [
            Container(
              color: const Color(0xFFFFF7E0),
              child: Stack(
                children: [
                  const Column(
                    children: [
                      Text(
                        "     Scan Your Drink!   ",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "\n\n     Get to know the unhealthy \n        ingredient in your drink. \n      Just scan the ingredients \n                 with a click.     ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ],
                  ),
                  Image.asset('assets/pageview1.png'),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFFFF7E0),
              child: Stack(
                children: [
                  const Text(
                    "                Get Details...",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontFamily: "Quicksand"),),
                  Image.asset('assets/pageview2.png'),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFFFF7E0),
              child: Stack(
                 children: [
                   const Text(
                     "               ...Of the Drink",
                     style: TextStyle(
                         fontFamily: "Quicksand",
                         fontSize: 30,
                         fontWeight:
                         FontWeight.w900),),
                   Image.asset('assets/pageview3.png'),
                   Container(
                     padding: const EdgeInsets.only(left: 120),

                     alignment: const Alignment(0,0.20),
                     width: 350,
                       child: const Text("Your Drink is only 30 percent healtheir if consumed less than a month and 20 percent healthier further.",style: TextStyle(fontFamily: 'Quicksand',fontSize: 20,fontWeight: FontWeight.w600),))

                 ],

              ),
            ),
          ],
        ),
        bottomSheet: isLastPage?
             Container(
               width: 450,
               color: const Color(0xFFFFF7E0),
               padding: const EdgeInsets.all(10),
               child: TextButton(
                 onPressed: () {
                   Navigator.push(context,
                       MaterialPageRoute(builder: (context)=> const HomePage()));
                 },

                 style: ButtonStyle(
                   shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                   backgroundColor: const MaterialStatePropertyAll<Color>(Colors.orangeAccent),
                 ),
                 child: const Text("Get Started",style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',fontWeight: FontWeight.w900,fontSize: 22),),


               ),
             )
            : Container(
              color: const Color(0xFFFFF7E0),
              padding: const EdgeInsets.only(
                 left: 18,
                 right: 18,
                 bottom: 10,
                 top: 7,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                TextButton(
                  onPressed: () =>
                    pageControl.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn),
                  child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
                 SmoothPageIndicator(
                controller: pageControl,
                count: 3,
                effect: const WormEffect(
                  dotColor: Color(0xFFFAE2A3),
                  dotHeight: 10,
                  dotWidth: 25,
                  type: WormType.normal,
                  activeDotColor: Color(0xFFFFBB46),
                ),
                onDotClicked: (page) => pageControl.jumpToPage(page),
              ),
                 Container(
                   padding: const EdgeInsets.all(10),
                   decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFBB46),
                ),
                   child: IconButton(
                      iconSize: 20,
                      color: Colors.white,
                      splashColor: Colors.black,
                      style: ButtonStyle(
                      iconColor: const MaterialStatePropertyAll<Color>(Colors.black),
                      backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xFFFFBB46)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                  ),
                    onPressed: () => pageControl.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn),
                     icon: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

