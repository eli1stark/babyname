import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:babyname/utils/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:babyname/components/image_button.dart';
import 'package:babyname/screens/folder_template.dart';
import 'package:babyname/components/folder_button.dart';
import 'package:babyname/components/helper_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetName extends StatefulWidget {
  @override
  _GetNameState createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  Color boyColor;
  Color girlColor;
  bool boyPressed = false;
  bool girlPressed = false;
  bool noOnePressedGender = false;
  bool hintSaveName = false;
  var name = 'Name';

  // SnackBar onDoubleTap
  double opacity = 0.0;
  int duration = 500;

  @override
  void initState() {
    super.initState();
    DBProvider.db.createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: duration),
              onEnd: () {
                setState(() {
                  opacity = 0.0;
                  duration = 2500;
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  height: 40.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'SAVED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            noOnePressedGender
                ? HelperMessage(
                    text: 'Please choose GENDER',
                    top: 4.0,
                    bottom: null,
                    left: 5.0,
                    right: null,
                    topRightCorner: false,
                    topLeftCorner: true,
                    onTap: () {
                      setState(() {
                        noOnePressedGender = false;
                      });
                    })
                : Container(),
            hintSaveName
                ? HelperMessage(
                    text: 'Double TAP on Name to SAVE',
                    top: 4.0,
                    bottom: null,
                    left: null,
                    right: 5.0,
                    topRightCorner: true,
                    topLeftCorner: false,
                    onTap: () {
                      setState(() {
                        // if status = 1, then I never will see 'Save Name hint' in my App until I reinstall it
                        DBProvider.db.updateHelperTable('hintSaveName', 1);
                        hintSaveName = false;
                      });
                    })
                : Container(),
            Container(
              padding: EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageButton(
                        color: boyColor,
                        imagePath: 'images/boy.png',
                        onTap: () {
                          setState(() {
                            boyPressed = true;
                            boyColor = Colors.grey[300];
                            girlPressed = false;
                            girlColor = null;
                            noOnePressedGender = false;
                          });
                        },
                      ),
                      ImageButton(
                        color: girlColor,
                        imagePath: 'images/girl.png',
                        onTap: () {
                          setState(() {
                            girlPressed = true;
                            girlColor = Colors.grey[300];
                            boyPressed = false;
                            boyColor = null;
                            noOnePressedGender = false;
                          });
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      if (name != 'Name') {
                        bool alreadySaved = false;
                        if (boyPressed == true) {
                          var value = await DBProvider.db.queryBoyFolder();
                          // If database isn't empty
                          // Check if already Name exist
                          if (value != null) {
                            for (var i in value) {
                              String dbName = i['name'];
                              if (dbName == name) {
                                alreadySaved = true;
                              }
                            }
                            if (alreadySaved == false) {
                              setState(() {
                                // SnackBar
                                duration = 500;
                                opacity = 1.0;
                              });
                              DBProvider.db.insertIntoBoyFolder(name, 0);
                            }
                          } else {
                            setState(() {
                              // SnackBar
                              duration = 500;
                              opacity = 1.0;
                            });
                            DBProvider.db.insertIntoBoyFolder(name, 0);
                          }
                        } else if (girlPressed == true) {
                          var value = await DBProvider.db.queryGirlFolder();
                          // If database isn't empty
                          // Check if already Name exist
                          if (value != null) {
                            for (var i in value) {
                              String dbName = i['name'];
                              if (dbName == name) {
                                alreadySaved = true;
                              }
                            }
                            if (alreadySaved == false) {
                              setState(() {
                                // SnackBar
                                duration = 500;
                                opacity = 1.0;
                              });
                              DBProvider.db.insertIntoGirlFolder(name, 0);
                            }
                          } else {
                            setState(() {
                              // SnackBar
                              duration = 500;
                              opacity = 1.0;
                            });
                            DBProvider.db.insertIntoGirlFolder(name, 0);
                          }
                        }
                      }
                    },
                    child: FittedBox(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 60.0,
                          fontFamily: 'Acme',
                          letterSpacing: 1.0,
                        ),
                      ),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightBlueAccent[100],
                    ),
                    width: 140.0,
                    height: 80.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Text(
                          'GET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        // Check whether the user saw the hint how to save a name
                        var status = await DBProvider.db
                            .queryHelperTable('hintSaveName');
                        // If Yes
                        if (status == 1) {
                          hintSaveName = false;
                        } //If No
                        else if (status == null) {
                          hintSaveName = true;
                        }

                        // Check whether the user choose gender
                        var value;
                        if (boyPressed == true) {
                          value = await DBProvider.db.getBoyName();
                        } else if (girlPressed == true) {
                          value = await DBProvider.db.getGirlName();
                        } else {
                          // If Gender wasn't choose
                          value = 'Name';
                          noOnePressedGender = true;
                          hintSaveName = false;
                        }

                        setState(() {
                          if (value == null) {
                            name = 'Name';
                            // Alert if there isn't left names of picked gender in Database
                            Alert(
                              context: context,
                              image: Image.asset(
                                'images/alert_baby.png',
                                height: 200,
                                width: 200,
                              ),
                              title: boyPressed
                                  ? 'Run Out Of Boys Names'
                                  : 'Run Out Of Girls Names',
                              desc: 'DO YOU WANT TO START AGAIN?',
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "AGAIN",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    if (boyPressed == true) {
                                      DBProvider.db.updateBoyTable();
                                    } else if (girlPressed == true) {
                                      DBProvider.db.updateGirlTable();
                                    }
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green[400],
                                ),
                                DialogButton(
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Colors.red[400],
                                )
                              ],
                            ).show();
                          } else {
                            // if there are left names of picked gender in Database
                            name = value.toString();
                          }
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FolderButton(
                        icon: FontAwesomeIcons.mars,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Folder(gender: 'boy');
                          }));
                        },
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.lightBlue[200],
                      ),
                      FolderButton(
                        icon: FontAwesomeIcons.venus,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Folder(gender: 'girl');
                          }));
                        },
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                        ),
                        color: Colors.pink[200],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
