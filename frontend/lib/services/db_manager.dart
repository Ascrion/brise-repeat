import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Global database reference
late Database db;

/// Initialize database
Future<void> initDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'my_database.db');

  db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS topics(id INTEGER PRIMARY KEY, topic TEXT UNIQUE, tag TEXT)',
      );
      await db.execute(
        'CREATE TABLE IF NOT EXISTS questions(id INTEGER PRIMARY KEY, topic TEXT, prompt TEXT UNIQUE, correct_answer TEXT, interval INT)',
      );
    },
  );
}

/// Topics -----

// Insert Topic
Future<void> insertTopic(String topic, String tag, Database db) async {
  await db.insert(
    'topics',
    {'topic': topic, 'tag': tag},
    conflictAlgorithm: ConflictAlgorithm.replace, // Avoid duplicate error
  );
}

// Get All Topics
Future<List<Map<String, dynamic>>> getTopics(Database db) async {
  return await db.query('topics');
}

// Update Topic (using `topic` as unique key)
Future<void> updateTopic(
  String oldTopic,
  String topic,
  String tag,
  Database db,
) async {
  await db.update(
    'topics',
    {'topic': topic, 'tag': tag},
    where: 'topic = ?',
    whereArgs: [oldTopic],
  );
}

// Delete Topic
Future<void> deleteTopic(String topic, Database db) async {
  await db.delete('topics', where: 'topic = ?', whereArgs: [topic]);
}

// Get Topic by topic
Future<Map<String, dynamic>?> getTopicByTopic(String topic, Database db) async {
  final result = await db.query(
    'topics',
    where: 'topic = ?',
    whereArgs: [topic],
    limit: 1,
  );

  return result.isNotEmpty ? result.first : null;
}

/// Questions ----
///
// Insert Question
Future<void> insertQuestion(
  String topic,
  String prompt,
  String correctAnswer,
  int interval,
  Database db,
) async {
  await db.insert('questions', {
    'topic': topic,
    'prompt': prompt,
    'correct_answer': correctAnswer,
    'interval': interval,
  }, conflictAlgorithm: ConflictAlgorithm.replace);
}

// Get Questions
Future<List<Map<String, dynamic>>> getQuestionsByTopic(
  Database db,
  String topic,
) async {
  return await db.query('questions', where: 'topic= ?', whereArgs: [topic]);
}

// Update Question (using `prompt` as unique key)
Future<void> updateQuestion(
  String prompt,
  String topic,
  String correctAnswer,
  int interval,
  Database db,
) async {
  await db.update(
    'questions',
    {'topic': topic, 'correct_answer': correctAnswer, 'interval': interval},
    where: 'prompt = ?',
    whereArgs: [prompt],
  );
}

// Delete Question
Future<void> deleteQuestion(String prompt, Database db) async {
  await db.delete('questions', where: 'prompt = ?', whereArgs: [prompt]);
}

// get question by prompt
Future<Map<String, dynamic>?> getQuestionByPromt(
  String prompt,
  Database db,
) async {
  final result = await db.query(
    'questions',
    where: 'prompt = ?',
    whereArgs: [prompt],
    limit: 1,
  );

  return result.isNotEmpty ? result.first : null;
}
