import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  factory UserDatabaseHelper() => _instance;
  static Database? _database;

  UserDatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE user(
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          province_code TEXT,
          city_code TEXT,
          register_number TEXT,
          unique_number TEXT,
          profile_photo TEXT
        )
      ''');
    });
  }
  /// Insert user to database.
  ///
  /// If user already exists on the database, the existing user will be replaced.
  ///

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'user',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
