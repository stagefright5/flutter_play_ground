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
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
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
  final _saved = <Suggestion>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getAppBarTitleWidget('Select The Names'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(
            builder: (BuildContext context) => SavedNamesList(saved: _saved)))
        .then((shouldRebuild) {
      // "then" gets executed after this pushed state gets popped by clicking `back` button from the
      // "SavedNamesList" widget
      if (shouldRebuild) {
        // set state when the Navigator.pop says so (that, is sends "true")
        setState(() {});
      }
    });
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
        _saved.add(s);
      } else {
        _saved.remove(s);
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
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

class SavedNamesList extends StatefulWidget {
  final Set<Suggestion>
      saved; // This is being sent from the Navigator route builder -> "MaterialPageRoute"

  SavedNamesList({this.saved});
  @override
  _SavedNamesListState createState() => _SavedNamesListState(saved: saved);
}

class _SavedNamesListState extends State<SavedNamesList> {
  final Set<Suggestion> saved;

  _SavedNamesListState({this.saved});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getAppBarTitleWidget('Saved Names'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_left,
            ),
            onPressed: () => Navigator.pop(context, true)),
      ),
      body: ListView.builder(
        itemCount: saved.length,
        itemBuilder: (context, index) => _buildRow(saved.toList()[index]),
      ),
    );
  }

  void _togglSuggestionSelection(Suggestion s) {
    setState(() {
      s.toggleSelected();
      if (s.selected) {
        saved.add(s);
      } else {
        saved.remove(s);
      }
    });
  }

  Widget _buildRow(Suggestion suggestion) {
    return ListTile(
      title: Text(
        suggestion.wp.asPascalCase,
        // style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outlined),
        onPressed: () => _togglSuggestionSelection(suggestion),
        tooltip: 'Delete ${suggestion.wp.asPascalCase} from saved list',
      ),
    );
  }
}
