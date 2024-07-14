import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void _removeFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favorites.removeAt(index);
    await prefs.setStringList('favorites', _favorites);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Center(child: Text('Favorite Quotes',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color: Colors.black),)),
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_favorites[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeFavorite(index),
            ),
          );
        },
      ),
    );
  }
}