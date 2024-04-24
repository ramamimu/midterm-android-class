import 'package:flutter/foundation.dart';
import 'package:midterm/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableMoviesName(
      ${MovieFields.id} $idType,
      ${MovieFields.title} $textType,
      ${MovieFields.imageURL} $textType,
      ${MovieFields.description} $textType,
      ${MovieFields.time} $textType
    )
    ''');
  }

  Future<Movie> create(Movie movie) async {
    final db = await instance.database;

    if (kDebugMode) {
      print(movie.toJson());

    }final id = await db.insert(tableMoviesName, movie.toJson());
    return movie.copy(id: id);
  }

  Future<Movie> readMovie(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableMoviesName,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movie>> readAllMovies() async {
    final db = await instance.database;

    const orderBy = '${MovieFields.time} ASC';

    final result = await db.query(tableMoviesName, orderBy: orderBy);
    return result.map((item) => Movie.fromJson(item)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;
    if (kDebugMode) {
      print("on update ${movie.toJson()}");
    }

    return db.update(
      tableMoviesName,
      movie.toJson(),
      where: '${MovieFields.id} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMoviesName,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
