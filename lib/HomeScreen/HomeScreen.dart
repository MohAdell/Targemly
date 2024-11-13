import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Favorites Page/ui/FavoritesPage.dart';
import '../Record Page/ui/Record.dart';
import '../Translation Page/ui/TranslationPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = (prefs.getStringList('favorites') ?? []);
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites);
  }

  void _addToFavorites(String translation) async {
    setState(() {
      _favorites.add(translation);
    });
    await _saveFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة الترجمة إلى المفضلة')),
    );
  }

  void _removeFromFavorites(String translation) async {
    setState(() {
      _favorites.remove(translation);
    });
    await _saveFavorites();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 0
            ? TranslationPage(onFavoriteAdded: _addToFavorites)
            : _selectedIndex == 1
                ? FavoritesPage(
                    favorites: _favorites, onRemove: _removeFromFavorites)
                : RecordPage(onFavoriteAdded: _addToFavorites),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.large(
            onPressed: () => _onItemTapped(0),
            child: Icon(Icons.translate,color: Colors.white,size: 50,),
            backgroundColor:
                _selectedIndex == 0 ? Colors.amber[800] : Colors.grey,
          ),
          FloatingActionButton.large(
            onPressed: () => _onItemTapped(2),
            child: Icon(Icons.mic,color: Colors.white,size: 50),
            backgroundColor:
                _selectedIndex == 2 ? Colors.amber[800] : Colors.grey,
          ),
          // FloatingActionButton.large(
          //   onPressed: () => _onItemTapped(2),
          //   child: Icon(Icons.document_scanner_outlined,color: Colors.white,size: 50),
          //   backgroundColor:
          //   _selectedIndex == 2 ? Colors.amber[800] : Colors.grey,
          // ),

          FloatingActionButton.large(

            onPressed: () => _onItemTapped(1),
            child: Icon(Icons.favorite,color: Colors.white,size: 50),
            backgroundColor:
                _selectedIndex == 1 ? Colors.amber[800] : Colors.grey,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
