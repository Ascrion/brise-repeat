import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Global database object
late Database db;

/// Initialize the database and create tables if they don't exist
Future<void> initDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'anki_data.db');

  db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS topics (
          id INTEGER PRIMARY KEY,
          topic TEXT,
          tag TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS topic_data (
          id INTEGER PRIMARY KEY,
          topic TEXT,
          promt TEXT,
          correct_answer TEXT,
          interval INT
        )
      ''');
    },
  );
}

/// Insert a topic into the topics table
Future<void> insertTopic(String topic, String tag) async {
  await db.insert('topics', {
    'topic': topic,
    'tag': tag,
  });
}

/// Get all topics from the topics table
Future<List<Map<String, dynamic>>> getTopics() async {
  return await db.query('topics');
}

/// Update a topic in the topics table
Future<void> updateTopic(String topic, String tag) async {
  await db.update(
    'topics',
    {'topic': topic, 'tag': tag},
    where: 'topic = ?',
    whereArgs: [topic],
  );
}

/// Delete a topic from the topics table
Future<void> deleteTopic(String topic) async {
  await db.delete(
    'topics',
    where: 'topic = ?',
    whereArgs: [topic],
  );
}

/// Get a specific topic row by topic name
Future<void> getTopic(String topic, dynamic ref) async {
  final result = await db.query(
    'topics',
    where: 'topic = ?',
    whereArgs: [topic],
  );

  if (result.isNotEmpty) {
    // Replace this line with proper state management logic
    ref.read().state = result;
  }
}

/// Insert a new row into the 'topic_data' table
Future<void> insertTopicData({
  required String topic,
  required String promt,
  required String correctAnswer,
  required int interval,
}) async {
  await db.insert('topic_data', {
    'topic': topic,
    'promt': promt,
    'correct_answer': correctAnswer,
    'interval': interval,
  });
}

/// Get all rows from the 'topic_data' table
Future<List<Map<String, dynamic>>> getAllTopicData() async {
  return await db.query('topic_data');
}

/// Get topic_data rows filtered by topic
Future<List<Map<String, dynamic>>> getTopicDataByTopic(String topic) async {
  return await db.query(
    'topic_data',
    where: 'topic = ?',
    whereArgs: [topic],
  );
}

/// Update a specific topic_data row by id
Future<void> updateTopicData({
  required int id,
  String? topic,
  String? promt,
  String? correctAnswer,
  int? interval,
}) async {
  final updateData = <String, dynamic>{};
  if (topic != null) updateData['topic'] = topic;
  if (promt != null) updateData['promt'] = promt;
  if (correctAnswer != null) updateData['correct_answer'] = correctAnswer;
  if (interval != null) updateData['interval'] = interval;

  await db.update(
    'topic_data',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );
}

/// Delete a specific topic_data row by id
Future<void> deleteTopicData(String topic) async {
  await db.delete(
    'topic_data',
    where: 'topic = ?',
    whereArgs: [topic],
  );
}
