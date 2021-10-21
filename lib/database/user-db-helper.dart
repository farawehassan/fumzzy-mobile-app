import 'dart:async';
import 'dart:io' as io;
import 'package:fumzy/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// This creates and controls a sqlite database for the logged in user's details
class DatabaseHelper {

  /// Instantiating this class to make it a singleton
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  /// Instantiating database from the sqflite package
  static late Database _db;

  /// A string value to hold the name of the table in the database
  final String USER_TABLE = "User";

  /// A function to get the database [_db] if it exists or wait to initialize
  /// a new database by calling [initDb()] and return [_db]
  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  /// Creating a new database in the device located in [path] with the
  /// [_onCreate()] function to create its table and fields
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  /// Function to execute sqlite statement to create a new table and its fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE $USER_TABLE("
        "id TEXT PRIMARY KEY NOT NULL,"
        "name TEXT NOT NULL,"
        "phone TEXT,"
        "type TEXT,"
        "status TEXT,"
        "createdAt TEXT,"
        "updatedAt TEXT,"
        "token TEXT)");
    print("Created tables");
  }

  /// This function insert user's details into the database records
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    await dbClient.delete(USER_TABLE);
    int res = await dbClient.insert(USER_TABLE, user.toJson());
    return res;
  }

  /// This function update user's details in the database records
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.update(USER_TABLE, user.toJson());
    return res;
  }

  /// This function get user's details from the database
  Future<User> getUser() async {
    var dbConnection = await db;
    List<Map<String, dynamic>> users = await dbConnection.rawQuery('SELECT * FROM $USER_TABLE');
    if (users.isNotEmpty) return User.fromJson(users[0]);
    throw "No user";
  }

  /// This function deletes user's details from the database records
  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete(USER_TABLE);
    return res;
  }

  /// This function checks if a user exists in the database by querying the
  /// database to check the length of the records and returns true if it is > 0
  /// or false if it is not
  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query(USER_TABLE);
    return res.length > 0 ? true : false;
  }

}
