
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator_plus/translator_plus.dart';

class SpeechToTextWithTranslation extends StatefulWidget {
  final Function(String) onSendTranslatedText;
  const SpeechToTextWithTranslation({Key? key, required this.onSendTranslatedText}) : super(key: key);

  @override
  State<SpeechToTextWithTranslation> createState() => _SpeechToTextWithTranslationState();
}

class _SpeechToTextWithTranslationState extends State<SpeechToTextWithTranslation> {
  final translator = GoogleTranslator();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechEnabled = false;
  bool _isListening = false;

  String _lastWords = '';
  String _translatedText = '';
  double _confidenceLevel = 0;

  final List<String> _languages = ['English', 'Hindi', 'Urdu'];
  final Map<String, String> _localeMap = {
    'English': 'en',
    'Hindi': 'hi',
    'Urdu': 'ur',
  };

  String _selectedRecognitionLanguage = 'English';
  String _selectedTranslationLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    setState(() {
      _isListening = true;
      _confidenceLevel = 0;
    });

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _localeMap[_selectedRecognitionLanguage],
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _confidenceLevel = result.confidence;

      if (_lastWords.isNotEmpty) {
        _translateText(_lastWords);
      }
    });
  }

  void _translateText(String text) async {
  try {
    final targetLanguageCode = _localeMap[_selectedTranslationLanguage];
    final translation = await translator.translate(
      text,
      from: _localeMap[_selectedRecognitionLanguage].toString(),
      to: targetLanguageCode.toString(),
    );

    setState(() {
      _translatedText = translation.text;
    });
  } catch (e) {
    setState(() {
      _translatedText = "Translation failed: $e";
    });
    print("Translation error: $e");
  }
}

  Future<void> _speakTranslatedText() async {
    if (_translatedText.isNotEmpty) {
      await _flutterTts.setLanguage(_localeMap[_selectedTranslationLanguage]!);
      await _flutterTts.speak(_translatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VoiceMate', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown(
                  "Speech Recognition Language",
                  _selectedRecognitionLanguage,
                  (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRecognitionLanguage = value;
                      });
                    }
                  },
                ),
                _buildDropdown(
                  "Translation Language",
                  _selectedTranslationLanguage,
                  (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTranslationLanguage = value;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.45,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton(
                          onPressed: _isListening ? _stopListening : _startListening,
                          child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                        ),
                      ),
                      Text('Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%'),
                      const SizedBox(height: 10),
                      Text("Recognized Text: $_lastWords"),
                      const SizedBox(height: 10),
                      Text("Translated Text: $_translatedText"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _speakTranslatedText,
                  child: const Text("Speak Translated Text"),
                ),
 ElevatedButton(
  onPressed: () {
    if (_translatedText.isNotEmpty) {
      widget.onSendTranslatedText(_translatedText); // Send the translated text
      Navigator.of(context).pop(); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No translated text to send")),
      );
    }
  },
  child: const Text("Send Translated Text"),
),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: _languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
      ),
    );
  }
}