import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:babyname/utils/database.dart';
import 'package:babyname/components/snack_bar.dart';
import 'package:babyname/components/arrow_back.dart';
import 'package:babyname/components/swipe_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:babyname/components/helper_message.dart';

class Folder extends StatefulWidget {
  Folder({@required this.gender});

  /// Gender is strictly 'boy' or 'girl'
  final String gender;

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  List<Map> items = [];
  // variable to check whether the database was load
  bool screenIsLoad = false;
  // variable to check whether the folder is empty
  bool folderIsEmpty = true;
  // Hints:
  bool swipeRight = false;
  bool swipeLeft = false;
  bool hintSizedBox = false;

  @override
  void initState() {
    super.initState();
    processData();
    processHints();
  }

  void processData() async {
    // Check what folder is it
    if (widget.gender == 'boy') {
      items = await DBProvider.db.getFolderList('boy');
    } else if (widget.gender == 'girl') {
      items = await DBProvider.db.getFolderList('girl');
    }

    // Check whether folder is empty
    if (items == null) {
      folderIsEmpty = true;
    } else if (items != null) {
      folderIsEmpty = false;
    }

    // Update screen when got data
    setState(() {
      screenIsLoad = true;
    });
  }

  void processHints() async {
    // Check whether the user saw the hint 'Swipe Right'
    var swipeRightData = await DBProvider.db.queryHelperTable('SwipeRight');

    // Check whether the user saw the hint 'Swipe Left'
    var swipeLeftData = await DBProvider.db.queryHelperTable('SwipeLeft');

    // These overstep I made to remove hints when the folder is empty
    setState(() {
      if (swipeRightData == 1) {
        swipeRight = false;
      } else if (swipeRightData == null && folderIsEmpty == false) {
        swipeRight = true;
      }
      if (swipeLeftData == 1) {
        swipeLeft = false;
      } else if (swipeLeftData == null && folderIsEmpty == false) {
        swipeLeft = true;
      }
      // If both hints was seen remove whiteSizedBox
      if (swipeRight == false && swipeLeft == false) {
        hintSizedBox = false;
      } // If one of the hits wasn't seen keep whiteSizedBox
      else if (swipeRight == true || swipeLeft == true) {
        hintSizedBox = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return screenIsLoad
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  swipeRight
                      ? HelperMessage(
                          text: 'Swipe to right, FAVORITE',
                          top: 45.0,
                          bottom: null,
                          left: 5.0,
                          right: null,
                          topRightCorner: false,
                          topLeftCorner: true,
                          onTap: () async {
                            setState(() {
                              DBProvider.db.updateHelperTable('SwipeRight', 1);
                              swipeRight = false;
                              // Dynamically remove whiteSizedBox
                              if (swipeLeft == false) {
                                hintSizedBox = false;
                              }
                            });
                          },
                        )
                      : Container(),
                  swipeLeft
                      ? HelperMessage(
                          text: 'Swipe to left, DELETE',
                          top: 45.0,
                          bottom: null,
                          left: null,
                          right: 5.0,
                          topRightCorner: true,
                          topLeftCorner: false,
                          onTap: () {
                            setState(() {
                              DBProvider.db.updateHelperTable('SwipeLeft', 1);
                              swipeLeft = false;
                              // Dynamically remove whiteSizedBox
                              if (swipeRight == false) {
                                hintSizedBox = false;
                              }
                            });
                          },
                        )
                      : Container(),
                  Column(
                    children: <Widget>[
                      ArrowBack(),
                      hintSizedBox
                          ? SizedBox(
                              height: 102.0,
                            )
                          : Container(),
                      folderIsEmpty
                          ? Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/empty_folder.gif',
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        'Folder is empty',
                                        style: TextStyle(
                                          fontSize: 45.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Acme',
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    direction: DismissDirection.horizontal,
                                    // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets.
                                    key: UniqueKey(),
                                    // Provide a function that tells the app what to do after an item has been swiped away.
                                    onDismissed: (direction) async {
                                      // Get all names from folder
                                      var data;
                                      bool alreadyFavorite = false;
                                      // Check what folder is it
                                      if (widget.gender == 'boy') {
                                        data = await DBProvider.db
                                            .queryBoyFolder();
                                      } else if (widget.gender == 'girl') {
                                        data = await DBProvider.db
                                            .queryGirlFolder();
                                      }

                                      setState(() {
                                        // Add to favorite List
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          // Remove hint SwipeRight
                                          if (swipeRight == true) {
                                            DBProvider.db.updateHelperTable(
                                                'SwipeRight', 1);
                                            swipeRight = false;
                                            if (swipeLeft == false) {
                                              hintSizedBox = false;
                                            }
                                          }

                                          // Check weather name is already added to Favorites:
                                          for (var i in data) {
                                            if (items[index]['title'] ==
                                                    i['name'] &&
                                                i['favorite'] == 1) {
                                              alreadyFavorite = true;
                                            }
                                          }
                                          if (alreadyFavorite == false) {
                                            Scaffold.of(context).showSnackBar(
                                              buildSnackBar(
                                                  'Name added to Favorites'),
                                            );
                                            // Add Name to Favorites
                                            // Check what folder is it
                                            if (widget.gender == 'boy') {
                                              DBProvider.db.updateBoyFolder(
                                                  items[index]['title'], 1);
                                            } else if (widget.gender ==
                                                'girl') {
                                              DBProvider.db.updateGirlFolder(
                                                  items[index]['title'], 1);
                                            }
                                            // Call spin
                                            screenIsLoad = false;
                                            // Reload the page
                                            processData();
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                              buildSnackBar(
                                                  'Name removed from Favorites'),
                                            );
                                            // Remove name from favorites
                                            // Check what folder is it
                                            if (widget.gender == 'boy') {
                                              DBProvider.db.updateBoyFolder(
                                                  items[index]['title'], 0);
                                            } else if (widget.gender ==
                                                'girl') {
                                              DBProvider.db.updateGirlFolder(
                                                  items[index]['title'], 0);
                                            }
                                            // Call spin
                                            screenIsLoad = false;
                                            // Reload the page
                                            processData();
                                          }
                                        } // Delete from List of Names
                                        else if (direction ==
                                            DismissDirection.endToStart) {
                                          // Remove hint SwipeLeft
                                          if (swipeLeft == true) {
                                            DBProvider.db.updateHelperTable(
                                                'SwipeLeft', 1);
                                            swipeLeft = false;
                                            if (swipeRight == false) {
                                              hintSizedBox = false;
                                            }
                                          }

                                          Scaffold.of(context).showSnackBar(
                                            buildSnackBar('Name deleted'),
                                          );

                                          // Deleting name from folder(database)
                                          // Check what folder is it
                                          if (widget.gender == 'boy') {
                                            DBProvider.db.deleteFromBoyTable(
                                                items[index]['title']);
                                          } else if (widget.gender == 'girl') {
                                            DBProvider.db.deleteFromGirlTable(
                                                items[index]['title']);
                                          }
                                        }
                                        items.removeAt(index);
                                      });
                                    },

                                    // Show a lime background as the item is swiped from left to right
                                    background: SwipeBackground(
                                      color: Colors.lime[400],
                                      icon: Icons.star,
                                      swipe: true,
                                    ),

                                    // Show a pink background as the item is swiped from right to left
                                    secondaryBackground: SwipeBackground(
                                      color: Colors.pinkAccent[700],
                                      icon: Icons.delete,
                                      swipe: false,
                                    ),

                                    // Names from Database
                                    child: items[index]['widget'],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: Colors.lightBlueAccent[200],
                size: 100.0,
              ),
            ),
          );
  }
}
