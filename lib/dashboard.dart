import 'package:flutter/material.dart';
import 'my_colors.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController titleCont = new TextEditingController();
  TextEditingController descCont = new TextEditingController();
  bool _autovalidate = false;
  String _validateEntry(String value) {
    if (value == null || value.isEmpty) return 'Required field';
    return null;
  }

  Map<int, List<String>> addedItems = new Map();
  var title;
  var desc;

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: AppBar(
          title: Text("TODO"),
        ),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: titleCont,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: 'Enter title',
                      ),
                      onSaved: (String value) {
                        title = value;
                      },
                      style: new TextStyle(color: Colors.black, fontSize: 16.0),
                      validator: _validateEntry,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descCont,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: 'Enter description',
                      ),
                      onSaved: (String value) {
                        desc = value;
                      },
                      style: new TextStyle(color: Colors.black, fontSize: 16.0),
                      validator: _validateEntry,
                    ),
                    new SizedBox(
                      height: 40.0,
                    ),
                    new RaisedButton(
                        color: MyColors.accentColor,
                        child: new Text("Enter",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 13.0)),
                        onPressed: _handleSubmitted),
                    SizedBox(
                      height: 20,
                    ),
                    addedItems.isEmpty
                        ? Center(
                            child: Text("No TODO found"),
                          )
                        : Container(
                            height: query.height / 2,
                            child: _getItems(),
                          ),
                  ],
                )),
          ),
        ));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Textbox cannot be empty');
    } else {
      form.save();
      insertIntoMap();
    }
  }

  insertIntoMap() {
    var newId = addedItems.length + 1;
    addedItems.putIfAbsent(newId, () => [title, desc]);
    setState(() {
      titleCont.text = "";
      descCont.text = "";
    });
  }

  deleteFromMap(int index) {
    if (addedItems.containsKey(index)) {
      addedItems.remove(index);
    }
    setState(() {});
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(value)));
  }

  Widget _getItems() {
    return new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Title",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Description",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Delete",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        Expanded(
          child: new ListView.builder(
            itemCount: addedItems.length,
            itemBuilder: (BuildContext context, int index) {
              int key = addedItems.keys.elementAt(index);
              return new Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${addedItems[key][0]}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${addedItems[key][1]}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteFromMap(key);
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
