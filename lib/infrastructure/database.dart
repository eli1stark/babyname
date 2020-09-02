import 'package:babyname/datasets/names_boy.dart';
import 'package:babyname/datasets/names_girl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:babyname/components/saved_name.dart';
import 'package:babyname/components/favorite_name.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  // When I call this method it's going to check if an instance of the object already exists.
  // If it does it's gonna return that instance and if it doesn't it's gonna make a new instance.
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  // Initialize database
  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'names.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE boy_names (id integer, name varchar(255));
        ''');
        await db.execute('''
          CREATE TABLE girl_names (id integer, name varchar(255));
        ''');
        await db.execute('''
          CREATE TABLE helper (name varchar(255), status integer);
        ''');
        await db.execute('''
          CREATE TABLE boy_folder (name varchar(255), favorite integer);
        ''');
        await db.execute('''
          CREATE TABLE girl_folder (name varchar(255), favorite integer);
        ''');
        updateBoyTable();
        updateGirlTable();
      },
      version: 1,
    );
  }

  // Create database
  void createDatabase() async {
    // ignore: unused_local_variable
    final db = await database;
  }

  // Update database (on Create) - part 1
  void insertBoyName(int id, String name) async {
    final db = await database;
    db.rawInsert('''
      INSERT INTO boy_names (id, name) VALUES ($id, '$name');
    ''');
  }

  void insertGirlName(int id, String name) async {
    final db = await database;
    db.rawInsert('''
      INSERT INTO girl_names (id, name) VALUES ($id, '$name');
    ''');
  }

  // Update database (on Create)  - part 2
  // Copy Boy Names from List to database
  void updateBoyTable() {
    for (int i = 0; i < boyNames.length; i++) {
      insertBoyName(i, boyNames[i]);
    }
  }

  // Copy Girl Names from List to database
  void updateGirlTable() {
    for (int i = 0; i < girlNames.length; i++) {
      insertGirlName(i, girlNames[i]);
    }
  }

  void deleteBoyName(int id) async {
    final db = await database;
    db.rawDelete('''
      DELETE FROM boy_names WHERE id = $id;
    ''');
  }

  void deleteGirlName(int id) async {
    final db = await database;
    db.rawDelete('''
      DELETE FROM girl_names WHERE id = $id;
    ''');
  }

  // Get Random names
  Future<dynamic> getBoyName() async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM boy_names ORDER BY RANDOM() LIMIT 1;
    ''');

    var name;

    if (response.length == 1) {
      var id = response[0]['id'];
      deleteBoyName(id);

      name = response[0]['name'];
    } else if (response.length == 0) {
      name = null;
    }

    return name;
  }

  Future<dynamic> getGirlName() async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM girl_names ORDER BY RANDOM() LIMIT 1;
    ''');

    var name;

    if (response.length == 1) {
      var id = response[0]['id'];
      deleteGirlName(id);

      name = response[0]['name'];
    } else if (response.length == 0) {
      name = null;
    }

    return name;
  }

  // update Helper table
  void updateHelperTable(String name, int status) async {
    final db = await database;
    db.rawInsert('''
      INSERT INTO helper (name, status) VALUES ('$name', $status);
    ''');
  }

  // Query Helper table
  // Take the name of a helper and return its status
  Future<dynamic> queryHelperTable(String name) async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT status FROM helper WHERE name = ?;
    ''', ['$name']);

    var status;

    // If there is a record about helper
    if (response.length == 1) {
      status = response[0]['status'];
    } // If there is no record about helper
    else if (response.length == 0) {
      status = null;
    }

    return status;
  }

  // Insert into Name Folders
  // By default favorite must be 0
  void insertIntoBoyFolder(String name, int favorite) async {
    final db = await database;
    db.rawInsert('''
      INSERT INTO boy_folder (name, favorite) VALUES ('$name', $favorite);
    ''');
  }

  void insertIntoGirlFolder(String name, int favorite) async {
    final db = await database;
    db.rawInsert('''
      INSERT INTO girl_folder (name, favorite) VALUES ('$name', $favorite);
    ''');
  }

  // Delete from Folders
  void deleteFromBoyTable(String name) async {
    final db = await database;
    db.rawDelete('''
      DELETE FROM boy_folder WHERE name = '$name';
    ''');
  }

  void deleteFromGirlTable(String name) async {
    final db = await database;
    db.rawDelete('''
      DELETE FROM girl_folder WHERE name = '$name';
    ''');
  }

  // If the user choose favorite name
  void updateBoyFolder(String name, int favorite) async {
    final db = await database;
    db.rawUpdate('''
      UPDATE boy_folder SET favorite = $favorite WHERE name = '$name';
    ''');
  }

  void updateGirlFolder(String name, int favorite) async {
    final db = await database;
    db.rawUpdate('''
      UPDATE girl_folder SET favorite = $favorite WHERE name = '$name';
    ''');
  }

  // Query Name Folders
  Future<dynamic> queryBoyFolder() async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM boy_folder;
    ''');
    // If there are no records
    if (response.length == 0) {
      response = null;
    }
    return response;
  }

  Future<dynamic> queryGirlFolder() async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM girl_folder;
    ''');
    // If there are no records
    if (response.length == 0) {
      response = null;
    }
    return response;
  }

  /// Process queryFolder() to make list of maps.
  /// Map contains widget and title.
  /// String takes 'boy' or 'girl'.
  Future<List> getFolderList(String folder) async {
    var data;
    if (folder == 'boy') {
      data = await queryBoyFolder();
    } else if (folder == 'girl') {
      data = await queryGirlFolder();
    }
    List<Map> folderList = [];

    if (data != null) {
      for (var i in data) {
        if (i['favorite'] == 1) {
          // Creating Map for a FavoriteName Widget
          var map = {};
          map['widget'] = FavoriteName(name: i['name']);
          map['title'] = i['name'];
          folderList.add(map);
        }
      }
      // I separated this loops to make favorite names at the top
      for (var i in data) {
        if (i['favorite'] == 0) {
          // Creating Map for a SavedName Widget
          var map = {};
          map['widget'] = SavedName(name: i['name']);
          map['title'] = i['name'];
          folderList.add(map);
        }
      }
    } else if (data == null) {
      folderList = null;
    }

    return folderList;
  }
}
