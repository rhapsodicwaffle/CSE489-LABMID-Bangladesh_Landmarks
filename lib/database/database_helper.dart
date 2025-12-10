import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/landmark.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('landmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE landmarks (
        id $idType,
        title $textType,
        lat $realType,
        lon $realType,
        image $textTypeNullable,
        local_image_path $textTypeNullable,
        created_at $textTypeNullable,
        updated_at $textTypeNullable
      )
    ''');
  }

  // Create
  Future<Landmark> create(Landmark landmark) async {
    final db = await instance.database;
    
    final id = await db.insert('landmarks', landmark.toDatabase());
    return landmark.copyWith(id: id);
  }

  // Read one
  Future<Landmark?> readLandmark(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'landmarks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Landmark.fromDatabase(maps.first);
    } else {
      return null;
    }
  }

  // Read all
  Future<List<Landmark>> readAllLandmarks() async {
    final db = await instance.database;
    
    final orderBy = 'created_at DESC';
    final result = await db.query('landmarks', orderBy: orderBy);

    return result.map((json) => Landmark.fromDatabase(json)).toList();
  }

  // Update
  Future<int> update(Landmark landmark) async {
    final db = await instance.database;

    return db.update(
      'landmarks',
      landmark.toDatabase(),
      where: 'id = ?',
      whereArgs: [landmark.id],
    );
  }

  // Delete
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'landmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all
  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete('landmarks');
  }

  // Replace all (for sync from API)
  Future<void> replaceAll(List<Landmark> landmarks) async {
    final db = await instance.database;
    
    await db.transaction((txn) async {
      await txn.delete('landmarks');
      for (var landmark in landmarks) {
        await txn.insert('landmarks', landmark.toDatabase());
      }
    });
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
