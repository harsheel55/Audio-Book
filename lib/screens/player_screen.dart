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
                  onPressed: isPlaying ? _stop : _speak,
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(isPlaying ? 'Stop' : 'Play'),
                ),
                ElevatedButton.icon(
                  onPressed:
                      isPlaying ? _pause : null, // Disable if not playing
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                ElevatedButton.icon(
                  onPressed: isPaused ? _resume : null, // Disable if not paused
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume'),
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

  Future<void> _resume() async {
    if (isPaused) {
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
      String remainingText = words.sublist(lastSpokenWordIndex).join(" ");
      await flutterTts.speak(remainingText);
    }
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
