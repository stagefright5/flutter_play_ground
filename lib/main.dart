import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Center(
          child: RandomWords(),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <Suggestion>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select The Names',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final nonDividerIdx = i ~/ 2;
          if (nonDividerIdx >= _suggestions.length) {
            _suggestions.addAll(
                generateWordPairs().take(10).map((e) => Suggestion(e, false)));
          }
          return _buildRow(_suggestions[nonDividerIdx]);
        });
  }

  void _togglSuggestionSelection(Suggestion s) {
    setState(() {
      s.toggleSelected();
    });
  }

  Widget _buildRow(Suggestion suggestion) {
    final icon = suggestion.selected ? Icons.favorite : Icons.favorite_border;
    return ListTile(
      title: Text(
        suggestion.wp.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(icon),
      onTap: () => _togglSuggestionSelection(suggestion),
    );
  }
}

class Suggestion {
  bool selected = false;
  WordPair wp;

  Suggestion(this.wp, this.selected);

  toggleSelected() {
    this.selected = !this.selected;
  }
}
