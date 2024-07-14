import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _quote = "Press the button to get a quote!";
  String _author = "Author";

  final List<Map<String, String>> _quotes = [
    {"quote": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
    {"quote": "Life is beautiful when you smile", "author": "Billu Verma"},
    {"quote": "The best time to plant a tree was 20 years ago. The second best time is now.", "author": "Chinese Proverb"},
    {"quote": "An unexamined life is not worth living.", "author": "Socrates"},
    {"quote": "Eighty percent of success is showing up.", "author": "Woody Allen"},
    {"quote": "Your time is limited, don’t waste it living someone else’s life.", "author": "Steve Jobs"},
  ];

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  void _loadQuote() {
    final random = Random();
    final randomQuote = _quotes[random.nextInt(_quotes.length)];
    setState(() {
      _quote = randomQuote["quote"]!;
      _author = randomQuote["author"]!;
    });
  }

  void _saveFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    favorites.add('$_quote   -   $_author');
    await prefs.setStringList('favorites', favorites);
  }

  void _shareQuote() async {
    final url = 'mailto:?subject=Quote of the Day&body=$_quote - $_author';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,

        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),

                child: Center(
                  child: Text(
                    "Quote of the Day",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _quote,
                        style: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '- $_author',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _loadQuote,
                            child: Text('New Quote'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _shareQuote,
                            child: Icon(Icons.share),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _saveFavorite,
                            child: Text('Favorite'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
