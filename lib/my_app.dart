import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_list/Pages/SplashScreenPage/splash_screen_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreenPage(),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey, 
      
        scaffoldBackgroundColor: Colors.grey[50], 
        
       
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey, 
        ).copyWith(
          
          primary: Colors.black, 
          
   
          secondary: Colors.cyan[400], 
        
          onSurface: Colors.black, 
        ),
        
        textTheme: GoogleFonts.robotoTextTheme(),
        
     
        switchTheme: SwitchThemeData(
          
          trackColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (!states.contains(WidgetState.selected)) {
            
                return Colors.grey[400]!; 
              }
             
              return Colors.cyan[400]!; 
            },
          ),

          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (!states.contains(WidgetState.selected)) {
               
                return Colors.grey[600]!; 
              }
            
              return Colors.white; 
            },
          ),
        ),
        
     
        inputDecorationTheme: InputDecorationTheme(
         
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[500]!, 
            ),
          ),
         
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black, 
              width: 2.0,
            ),
          ),
          
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[300]!, 
              width: 1.0,
            ),
          ),
        ),
        
   
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}