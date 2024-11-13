import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> favorites;
  final Function(String) onRemove;

  FavoritesPage({required this.favorites, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      appBar: AppBar(
        title: Center(
            child: Text(
          'المفضلة',
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w200,
              fontFamily: 'Blaka',
              color: Colors.white),
        )),
        // backgroundColor: Colors.teal[700],
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
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(16),
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
                    Expanded(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        favorites[index],
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onRemove(favorites[index]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
