import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/utils/widgets.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? color;
  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);
// Add a controller
  late RichTextController rich_controller;

  List<Note>? noteList;
  @override
  void initState() {
    super.initState();
    // initialize with your custom regex patterns or Strings and styles
    //* Starting V1.2.0 You also have "text" parameter in default constructor !
    rich_controller = RichTextController(
      patternMatchMap: {
        //
        //* Returns every Hashtag with red color
        //
        RegExp(r"\B<>\s[a-zA-Z0-9 ]+\b"): TextStyle(color: Colors.red),
        //
        //* Returns every Mention with blue color and bold style.
        //
        // RegExp(r"\B@[a-zA-Z0-9]+\b"):TextStyle(fontWeight: FontWeight.w800 ,color:Colors.blue,),
        //
        //* Returns every word after '!' with yellow color and italic style.
        //
        // RegExp(r"\B![a-zA-Z0-9]+\b"):TextStyle(color:Colors.yellow, fontStyle:FontStyle.italic),
        // add as many expressions as you need!
      },
      //* starting v1.2.0
      // Now you have the option to add string Matching!
      //   stringMatchMap: {
      //   // "String1":TextStyle(color: Colors.lightBlueAccent),
      //   // "String2":TextStyle(color: Colors.yellow),
      //  },
      //! Assertion: Only one of the two matching options can be given at a time!

      //* starting v1.1.0
      //* Now you have an onMatch callback that gives you access to a List<String>
      //* which contains all matched strings
      onMatch: (List<String> matches) {
        // Do something with matches.
        //! P.S
        // as long as you're typing, the controller will keep updating the list.
      },
      deleteOnBack: true,
      // You can control the [RegExp] options used:
      regExpUnicode: true,
    );
    updateListView();
  }

  // List<String> matches = [];
  // List<String>? suggestons ;
  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = helper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          // count = noteList.length;
        });

        // print(count);
      });
    });
    // print(suggestons);
  }

  List<String> suggestons = [
    "USA",
    "UK",
    "Uganda",
    "Uruguay",
    "United Arab Emirates"
  ];
  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return WillPopScope(
        onWillPop: () async {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            backgroundColor: colors[color!],
            leading: IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                splashRadius: 22,
                icon: const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: () {
                  titleController.text.isEmpty
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
              IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: Container(
            color: colors[color!],
            child: Column(
              children: <Widget>[
                PriorityPicker(
                  selectedIndex: 3 - note.priority,
                  onTap: (index) {
                    isEdited = true;
                    note.priority = 3 - index;
                  },
                ),
                ColorPicker(
                  selectedIndex: note.color,
                  onTap: (index) {
                    setState(() {
                      color = index;
                    });
                    isEdited = true;
                    note.color = index;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: rich_controller,
                    maxLength: 255,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (value) {
                      updateTitle();
                      // var regex = RegExp("[/^>\$]");
                      // if (regex.hasMatch(note.title)) {
                      //   print("matched <>");
                      // } else {
                      //   print("not matched <>");
                      // }
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Title',
                    ),
                  ),
                ),
                TypeAheadField(
                  animationStart: 0,
                  animationDuration: Duration.zero,
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: rich_controller,
                      autofocus: true,
                      style: TextStyle(fontSize: 15),
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                  suggestionsBoxDecoration:
                      SuggestionsBoxDecoration(color: Colors.lightBlue[50]),
                  suggestionsCallback: (pattern) {
                   List<String> matches = <String>[];
                    var regex = RegExp(r"<>");
                    String refreshData = pattern.replaceAll(
                        RegExp(r"\B<>\s[a-zA-Z0-9 ]+\b"), '');
                    print(
                        "pattern: $refreshData");
                       
                    print(
                        "pattern: $pattern");
                    print(
                        "regexCheck: ${pattern.contains(regex)}");
                     
                    if (pattern.contains(regex)) {
                      //  matches = <String>[];
                       noteList!.forEach((element) {
                        matches.add(element.title);
                      });
                    
                      print("inside if $matches");
                      print("inside if ${refreshData.toLowerCase()}");
                      // String result = str.replaceAll(RegExp('[^A-Za-z0-9]'), '');

                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(refreshData.toLowerCase());
                      });
                        setState(() {});
                      return matches;
                    }
                    print("after if $matches");
                    return matches;
                  },
                  itemBuilder: (context, sone) {
                    return Card(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(sone.toString()),
                    ));
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion);
                    rich_controller.text =
                        rich_controller.text +  suggestion;
                    print(rich_controller.text);
                  },
                ),

                /**/
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      maxLength: 255,
                      controller: descriptionController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text("Are you sure you want to discard changes?",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Title is empty!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text('The title of the note cannot be empty.',
              style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              child: Text("Okay",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != 0) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
