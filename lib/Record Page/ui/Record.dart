import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';

class RecordPage extends StatefulWidget {
  final Function(String) onFavoriteAdded;

  RecordPage({required this.onFavoriteAdded});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "اضغط على الزر وابدأ بالتحدث";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ النص إلى الحافظة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      appBar: AppBar(
        title: Center(
            child: Text(
          'التسجيل',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200,fontFamily: 'Blaka',color: Colors.white),
        )),
        backgroundColor: Colors.teal[700],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[700]!, Colors.teal[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'النص المسجل:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: _copyToClipboard,
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () => widget.onFavoriteAdded(_text),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    _text,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18.0),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
              backgroundColor: _isListening ? Colors.red : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
