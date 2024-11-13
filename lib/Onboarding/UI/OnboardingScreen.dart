import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../HomeScreen/HomeScreen.dart';


class OnboardingScreen extends StatefulWidget {

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> speechBubbleTexts = ['ترجمه', 'سماع نص', 'قرائه صور'];
  List<bool> speechBubbleVisible = [false, false, false];
  final String githubUrl = "https://github.com/MohAdell";

  @override
  void initState() {
    super.initState();
    _showSpeechBubbles();
  }

  void _showSpeechBubbles() async {
    for (int i = 0; i < speechBubbleTexts.length; i++) {
      await Future.delayed(Duration(milliseconds: 500 * i)); // Stagger the animation
      setState(() {
        speechBubbleVisible[i] = true;
      });
    }}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[700],
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ترجملي بالعربي',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w100,
                        color: Colors.amber[800],
                        fontFamily: 'Blaka',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'تطبيق يكتشف اي لغه في العالم ويترجمها الي العربيه بضغطه زر',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    for (int i = 0; i < speechBubbleTexts.length; i++) ...[
        Padding(
        padding: EdgeInsets.only(right: i < speechBubbleTexts.length - 1 ? 10 : 10), // Add padding to the right
      child: _buildSpeechBubble(speechBubbleTexts[i], speechBubbleVisible[i]),
    ),
],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Icon(Icons.home_outlined, color: Colors.white,size: 50,),
          backgroundColor: Colors.amber[700],
          elevation: 10,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomSheet: Container(
          height: 140,
          color:Colors.teal[700] ,
child: Positioned(
  bottom: 2,
  left: 0,
  right: 0,
  child: Center(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'صنع بكل ',
            style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w200,fontFamily: 'Noto_Nastaliq_Urdu',),
          ),
          WidgetSpan(
            child: HeartIcon(),
          ),
          WidgetSpan(child: SizedBox(width: 5,)),
          TextSpan(
            text: ' محمد عادل',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,fontWeight: FontWeight.w200,fontFamily: 'Noto_Nastaliq_Urdu',
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunch(githubUrl)) {
                  await launch(githubUrl);
                }
              },
          ),
        ],
      ),
    ),
  ),
),
        ));
  }

  Widget _buildSpeechBubble(String text, bool visible) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500), // Fade-in duration
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(

          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
class HeartIcon extends StatefulWidget {
  @override
  _HeartIconState createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Icon(
        Icons.favorite,
        color: Colors.red,
        size: 16,
      ),
    );
  }
}
