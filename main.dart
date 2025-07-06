import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(RandomQuoteApp());
}

class RandomQuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF181A20),
        primarySwatch: Colors.deepPurple,
        cardColor: Color(0xFF23243A),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        fontFamily: 'Roboto',
      ),
      home: QuoteScreen(),
    );
  }
}

class Quote {
  final String text;
  final String author;
  Quote({required this.text, required this.author});
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<Quote> _quotes = [
    Quote(
      text: "The best way to get started is to quit talking and begin doing.",
      author: "Walt Disney",
    ),
    Quote(
      text: "Success is not in what you have, but who you are.",
      author: "Bo Bennett",
    ),
    Quote(
      text:
          "The harder you work for something, the greater you'll feel when you achieve it.",
      author: "Unknown",
    ),
    Quote(text: "Dream bigger. Do bigger.", author: "Unknown"),
    Quote(
      text: "Don't watch the clock; do what it does. Keep going.",
      author: "Sam Levenson",
    ),
    Quote(
      text: "Great things never come from comfort zones.",
      author: "Unknown",
    ),
    Quote(
      text: "Push yourself, because no one else is going to do it for you.",
      author: "Unknown",
    ),
    Quote(
      text: "Success doesn't just find you. You have to go out and get it.",
      author: "Unknown",
    ),
    Quote(
      text:
          "The only place where success comes before work is in the dictionary.",
      author: "Vidal Sassoon",
    ),
    Quote(
      text: "Don't stop when you're tired. Stop when you're done.",
      author: "Marilyn Monroe",
    ),
  ];

  int _currentIndex = 0;
  final Random _random = Random();
  bool _showQuote = true;
  Color _accentColor = Colors.deepPurpleAccent;
  final List<Color> _accentColors = [
    Colors.deepPurpleAccent,
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
  ];

  @override
  void initState() {
    super.initState();
    _showRandomQuote(initial: true);
  }

  void _showRandomQuote({bool initial = false}) async {
    int newIndex;
    do {
      newIndex = _random.nextInt(_quotes.length);
    } while (newIndex == _currentIndex && _quotes.length > 1);
    Color newAccent = _accentColors[_random.nextInt(_accentColors.length)];
    if (!initial) {
      setState(() => _showQuote = false);
      await Future.delayed(Duration(milliseconds: 200));
    }
    setState(() {
      _currentIndex = newIndex;
      _accentColor = newAccent;
      _showQuote = true;
    });
  }

  void _copyQuote() {
    final quote = _quotes[_currentIndex];
    Clipboard.setData(ClipboardData(text: '"${quote.text}" - ${quote.author}'));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Quote copied to clipboard!')));
  }

  void _shareQuote() {
    final quote = _quotes[_currentIndex];
    Share.share('"${quote.text}" - ${quote.author}');
  }

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[_currentIndex];
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF181A20), _accentColor.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder:
                      (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                  child:
                      _showQuote
                          ? Card(
                            key: ValueKey(_currentIndex),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color(0xFF23243A),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    size: 40,
                                    color: _accentColor,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '"${quote.text}"',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '- ${quote.author}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          color: _accentColor,
                                        ),
                                        tooltip: 'Copy',
                                        onPressed: _copyQuote,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.share,
                                          color: _accentColor,
                                        ),
                                        tooltip: 'Share',
                                        onPressed: _shareQuote,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _showRandomQuote,
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    'New Quote',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
