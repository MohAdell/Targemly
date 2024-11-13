import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class TranslationPage extends StatefulWidget {
  final Function(String) onFavoriteAdded;

  TranslationPage({required this.onFavoriteAdded});

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = "";
  final translator = GoogleTranslator();
  bool _isAutoTranslating = true;

  @override
  void initState() {
    super.initState();
    _loadText();
  }

  @override
  void dispose() {
    _saveText();
    super.dispose();
  }

  void _loadText() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textController.text = prefs.getString('saved_text') ?? "";
    });
    if (_isAutoTranslating && _textController.text.isNotEmpty) {
      _translateText(_textController.text);
    }
  }

  void _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_text', _textController.text);
  }

  void _translateText(String text) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(
      text,
      from: 'auto',
      to: 'ar',
    );
    setState(() {
      _translatedText = translation.text;
    });
  }

  void _manualTranslate() {
    _translateText(_textController.text);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ الترجمة إلى الحافظة')),
    );
  }
  void _clearSavedTextAfterDelay() async { await Future.delayed(Duration(minutes: 10)); final prefs = await SharedPreferences.getInstance(); await prefs.remove('saved_text'); }

  @override
  Widget build(BuildContext context) {
    _clearSavedTextAfterDelay();
    return Scaffold(
      backgroundColor: Colors.teal[700],
      appBar: AppBar(
        title: Center(
            child: Text(
          'المترجم',
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w200,
              fontFamily: 'Blaka',
              color: Colors.white),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Stretch children to fill width
                  children: [
                    TextField(
                      maxLines: null,
                      minLines: 1,
                      controller: _textController,
                      onChanged: (text) {
                        if (_isAutoTranslating) {
                          _translateText(text);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'أدخل النص للترجمة',
                        suffixIcon: _textController.text
                                .isNotEmpty // Show clear button if text is not empty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _textController.clear(); // Clear the text
                                    _translatedText =
                                        ''; // Clear the output text as well
                                  });
                                },
                              )
                            : null, // Hide clear button if text is empty
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed:(){ _manualTranslate(); _saveText();},
                  child: Text(
                    'ترجم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.amber[800],
                  )),
              SizedBox(height: 20),
              if (_translatedText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.symmetric(),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        // Output Container
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الترجمه:',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      onPressed: _copyToClipboard,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      onPressed: () => widget
                                          .onFavoriteAdded(_translatedText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              _translatedText,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
