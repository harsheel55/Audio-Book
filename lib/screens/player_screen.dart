import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;
  String textToRead = "";
  int lastSpokenWordIndex = 0;
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    textToRead = ModalRoute.of(context)!.settings.arguments as String;
    words = textToRead.split(" "); // Splitting text into words

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  textToRead,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: isPlaying ? _pause : _speak,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? 'Pause' : 'Play'),
                ),
                ElevatedButton.icon(
                  onPressed: _stop,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speak() async {
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
    await _speakFromIndex(lastSpokenWordIndex);
  }

  Future<void> _speakFromIndex(int startIndex) async {
    String remainingText = words.sublist(startIndex).join(" ");
    await flutterTts.speak(remainingText);
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _pause() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      isPaused = false;
      lastSpokenWordIndex = 0; // Reset position
    });
  }
}
