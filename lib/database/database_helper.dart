import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('formation_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // Table des formations
    await db.execute('''
      CREATE TABLE formations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        description TEXT NOT NULL,
        dateDebut TEXT NOT NULL,
        dateFin TEXT NOT NULL,
        lieu TEXT NOT NULL,
        nombreParticipants INTEGER NOT NULL,
        prix REAL NOT NULL
      )
    ''');

    // Table des participants
    await db.execute('''
      CREATE TABLE participants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL,
        telephone TEXT NOT NULL,
        adresse TEXT NOT NULL
      )
    ''');

    // Table de liaison formation-participant
    await db.execute('''
      CREATE TABLE formation_participants (
        formationId INTEGER,
        participantId INTEGER,
        FOREIGN KEY (formationId) REFERENCES formations (id) ON DELETE CASCADE,
        FOREIGN KEY (participantId) REFERENCES participants (id) ON DELETE CASCADE,
        PRIMARY KEY (formationId, participantId)
      )
    ''');

    // Insérer l'utilisateur admin par défaut
    await db.insert('users', {
      'username': 'admin',
      'password': '00000000',
      'role': 'admin',
    });
  }

  // Méthodes pour l'authentification
  Future<Map<String, dynamic>?> authenticateUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Méthodes pour les formations
  Future<int> insertFormation(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('formations', row);
  }

  Future<List<Map<String, dynamic>>> getAllFormations() async {
    final db = await database;
    return await db.query('formations');
  }

  Future<Map<String, dynamic>?> getFormation(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'formations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateFormation(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'formations',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteFormation(int id) async {
    final db = await database;
    return await db.delete('formations', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour les participants
  Future<int> insertParticipant(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('participants', row);
  }

  Future<List<Map<String, dynamic>>> getAllParticipants() async {
    final db = await database;
    return await db.query('participants');
  }

  Future<Map<String, dynamic>?> getParticipant(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'participants',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateParticipant(Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'participants',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> deleteParticipant(int id) async {
    final db = await database;
    return await db.delete('participants', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour la relation formation-participant
  Future<int> addParticipantToFormation(
    int formationId,
    int participantId,
  ) async {
    final db = await database;
    return await db.insert('formation_participants', {
      'formationId': formationId,
      'participantId': participantId,
    });
  }

  Future<List<Map<String, dynamic>>> getFormationParticipants(
    int formationId,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT p.* FROM participants p
      INNER JOIN formation_participants fp ON p.id = fp.participantId
      WHERE fp.formationId = ?
    ''',
      [formationId],
    );
  }

  Future<int> removeParticipantFromFormation(
    int formationId,
    int participantId,
  ) async {
    final db = await database;
    return await db.delete(
      'formation_participants',
      where: 'formationId = ? AND participantId = ?',
      whereArgs: [formationId, participantId],
    );
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
