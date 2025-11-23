import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/Pages/main_page/main_page.dart';
import 'package:task_list/Classes/tarefa_provider.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});
  
  void _openHome(BuildContext context) {
    Future.microtask(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TarefaProvider>(
      builder: (context, provider, child) {
        bool isReady = !provider.isLoading;
        
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[ 
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Task List', 
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                        speed: Duration(milliseconds: 100)
                      ),
                    ],
                    totalRepeatCount: 1,
                    isRepeatingAnimation: false,
                    onFinished: () {
                      if (isReady) {
                        _openHome(context);
                      }
                    },
                  ),
                  SizedBox(height: 10),

                  if (isReady = true) 
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Organize your rotine right now!', 
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                          speed: Duration(milliseconds: 50)
                        ),
                      ],
                      totalRepeatCount: 1,
                      isRepeatingAnimation: false,
                      onFinished: (){
                        _openHome(context);
                      },
                    ),
                  if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: CircularProgressIndicator(),
                    )
                ]
              ),
            ),
          )
        );
      },
    );
  }
}