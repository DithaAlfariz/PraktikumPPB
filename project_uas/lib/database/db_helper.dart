import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;
  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb('auth_user.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        joinDate TEXT NOT NULL,
        courses INTEGER DEFAULT 0,
        reviews INTEGER DEFAULT 0,
        rating REAL DEFAULT 0.0
      )
    ''');
  }

  // Insert a new user
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  //login check
  Future<User?> login(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    
    return null;
  }
}