import 'package:flutter/material.dart';
import './data/books_helper.dart';
import 'favorite_screen.dart';
import 'ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Books',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BooksHelper helper;
  List<dynamic> books = [];
  int? booksCount;
  late TextEditingController txtSearchController;

  @override
  void initState() {
    helper = BooksHelper();
    txtSearchController = TextEditingController();
    initialize();
    super.initState();
  }

  Future initialize() async {
    books = await helper.getBooks('Flutter') ?? books;
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Books'), actions: <Widget>[
        InkWell(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall) ? Icon(Icons.home) : Text('Home')),
        ),
        InkWell(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall) ? Icon(Icons.star) : Text('Favorites')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(),
              ),
            );
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(children: [
                Text('Search book'),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 200,
                  child: TextField(
                    controller: txtSearchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      helper.getBooks(text).then((value) {
                        setState(() {
                          books = value ?? books;
                        });
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      helper.getBooks(txtSearchController.text).then((value) {
                        setState(() {
                          books = value ?? books;
                        });
                      });
                    },
                  ),
                ),
              ]),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: (isSmall)
                    ? BooksList(books, false)
                    : BooksTable(books, false)),
          ],
        ),
      ),
    );
  }
}
