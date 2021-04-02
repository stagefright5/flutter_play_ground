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
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getAppBarTitleWidget('Select The Names'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.list, color: Colors.black),
              onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: getAppBarTitleWidget('Saved Names'),
              leading: IconButton(icon: Icon(Icons.arrow_left_sharp, color: Colors.black), onPressed: () => Navigator.pop(context)),
            ),
            body: ListView(children: divided),
          );
        },
      ),
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
      if (s.selected) {
        _saved.add(s.wp);
      } else {
        _saved.remove(s.wp);
      }
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

Text getAppBarTitleWidget(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  );
}
