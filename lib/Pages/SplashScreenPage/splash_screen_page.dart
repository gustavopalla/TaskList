import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:task_list/Pages/main_page/main_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  bool showSecondText = false;

  openHome(){
    Future.delayed(const Duration(milliseconds: 100), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[ 
              AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Task List', textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),
                speed: Duration(milliseconds: 100)
                ),
              ],
              totalRepeatCount: 1,
              isRepeatingAnimation: false,
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
              
              onFinished: () {
                setState(() {
                  showSecondText = true;
                });
              },
            ),
            SizedBox(height: 10),

            if(showSecondText)
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Organize your rotine right now!', textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                  speed: Duration(milliseconds: 100)
                  ),
                ],
                totalRepeatCount: 1,
                isRepeatingAnimation: false,
                displayFullTextOnTap: false,
                stopPauseOnTap: false,
                onFinished: (){
                  openHome();
                },
              ),
            ]
          ),
        ),
      )
      );
  }
}