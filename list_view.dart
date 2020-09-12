import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_app/custom_alert_dialog.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class AppListView extends StatefulWidget {
  AppListView({Key key}) : super(key: key);

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<AppListView> {
  @override
  Widget build(BuildContext context) {
    void showAddNote() {
      TextEditingController _noteField = new TextEditingController();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 4,
                child: Column(
                  children: [
                    TextField(
                      controller: _noteField,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 1.5,
                        onPressed: () {
                          Navigator.of(context).pop();
                          CollectionReference users = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('Notes');
                          users
                              .add({'Note': _noteField.text})
                              .then((value) => print("User Document Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                        },
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          'Add Note',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("Button Pressed");
          showAddNote();
        },
      ),
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection('Notes')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    children: snapshot.data.docs.map((document) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 1.0,
                        ),
                        child: SwipeActionCell(
                          key: ObjectKey(document.data()['Note']),
                          actions: <SwipeAction>[
                            SwipeAction(
                                title: "delete",
                                onTap: (CompletionHandler handler) {
                                  CollectionReference users = FirebaseFirestore
                                      .instance
                                      .collection('Users')
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection('Notes');
                                  users
                                      .doc(document.id)
                                      .delete()
                                      .then((value) => print("Note Deleted"))
                                      .catchError((error) => print(
                                          "Failed to delete note: $error"));
                                },
                                color: Colors.red),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              document.data()['Note'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
