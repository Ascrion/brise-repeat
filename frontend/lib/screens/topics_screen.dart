// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/screens/cards_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../services/db_manager.dart';

// Topic Provider
final topicProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Topic Edit Provider (List to track all topics)
final editingIndexProvider = StateProvider<int?>((ref) => null);

final topicEditValuesProvider = StateProvider<Map<int, List<String>>>(
  (ref) => {},
);
final cardTopic = StateProvider<String>((ref) => '');

/// Topics page
class TopicsPage extends HookConsumerWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final topicCard = ref.watch(cardTopic);

    useEffect(() {
      fetchTopics(ref);
      return null;
    }, const []);

    return (topicCard.isNotEmpty)? CardPage(topicCard):Scaffold(
      body: topics.isEmpty
          ? const Center(child: Text('No Topics Created'))
          : ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return TopicRow(index: index, item: topics[index]);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addTopic(context, ref, 'New Topic', 'None');
        },
        child: Icon(Icons.add, size: screenHeight* 0.04),
      ),
    );
  }
}

class TopicRow extends HookConsumerWidget {
  final int index;
  final Map<String, dynamic> item;

  const TopicRow({super.key, required this.index, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editingIndexProvider) == index;
    final editValues = ref.watch(topicEditValuesProvider);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topicController = useTextEditingController(
      text: editValues[index]?.first ?? item['topic'],
    );
    final tagController = useTextEditingController(
      text: editValues[index]?.last ?? item['tag'],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(cardTopic.notifier).state = item['topic'];
        },
        child: Container(
          height: screenHeight*0.06,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: isEditing
              ? theme.colorScheme.onSurface.withAlpha((150))
              : theme.colorScheme.tertiary.withAlpha((150)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: isEditing
                    ? TextField(
                        controller: topicController,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        onChanged: (val) {
                          ref
                              .read(topicEditValuesProvider.notifier)
                              .update(
                                (state) => {
                                  ...state,
                                  index: [val, tagController.text],
                                },
                              );
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        item['topic'],
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: screenWidth * 0.3,
                child: isEditing
                    ? Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            controller: tagController,
                            style: theme.textTheme.bodyMedium,
                            onChanged: (val) {
                              ref
                                  .read(topicEditValuesProvider.notifier)
                                  .update(
                                    (state) => {
                                      ...state,
                                      index: [topicController.text, val],
                                    },
                                  );
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      )
                    : Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item['tag'],
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondary),
                            maxLines: 1,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              if (isEditing)
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.lightGreenAccent),
                  onPressed: () async {
                    final edited = ref.read(topicEditValuesProvider)[index];
                    if (edited != null) {
                      await editTopic(
                        item['topic'],
                        edited[0],
                        edited[1],
                        context,
                        ref,
                      );
                    }
                    ref.read(editingIndexProvider.notifier).state = null;
                    ref.read(topicEditValuesProvider.notifier).state = {};
                  },
                )
              else
                IconButton(
                  icon: Icon(Icons.edit,color: theme.colorScheme.onSecondary,),
                  onPressed: () {
                    ref.read(editingIndexProvider.notifier).state = index;
                    ref.read(topicEditValuesProvider.notifier).state = {
                      index: [item['topic'], item['tag']],
                    };
                  },
                ),
              IconButton(
                icon: Icon(Icons.delete, color: theme.colorScheme.error),
                onPressed: () async {
                  await topicDelete(item['topic'], context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Get Topic data
Future<void> fetchTopics(WidgetRef ref) async {
  //initialize db
  await initDb();
  final topics = await getTopics(db);
  ref.read(topicProvider.notifier).state = topics;
}

// Add new topic
Future<void> addTopic(
  BuildContext context,
  WidgetRef ref,
  String topic,
  String tag,
) async {
  await initDb();
  final existing = await db.query(
    'topics',
    where: 'topic = ?',
    whereArgs: [topic],
  );
  if (existing.isEmpty) {
    await insertTopic(topic, tag, db);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text('Topic "$topic" added')));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topic "$topic" already exists'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
  await fetchTopics(ref);
}

// Delete Topic
Future<void> topicDelete(
  String topic,
  BuildContext context,
  WidgetRef ref,
) async {
  await initDb();
  await deleteTopic(topic, db);
  await fetchTopics(ref);
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text('Topic "$topic" deleted'),
  //     duration: Duration(milliseconds: 300),
  //   ),
  // );
}

// Edit Topic
Future<void> editTopic(
  String oldTopic,
  String topic,
  String tag,
  BuildContext context,
  WidgetRef ref,
) async {
  await initDb();

  // To get previous values
  final existing = await db.query(
    'topics',
    where: 'topic = ?',
    whereArgs: [topic],
  );

  // If nothing changed, just return early
  if (oldTopic == topic) {
    // Get the current tag from DB
    if (existing.isNotEmpty && tag == existing[0]['tag']) {
      return;
    }
  }
  // If topic name changed, ensure it's unique
  if (oldTopic != topic) {
    if (existing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topic name already exists'),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }
  }

  // Update the topic
  await updateTopic(oldTopic, topic, tag, db);
  await fetchTopics(ref);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Topic "$topic" updated'),
      duration: const Duration(milliseconds: 500),
    ),
  );
}
