import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/screens/topics_screen.dart';
import 'package:frontend/services/db_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final questionProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);
final sliderValueProvider = StateProvider<List<double>>((ref) => [2.5, 2.5]);

class CardPage extends HookConsumerWidget {
  final String topic;

  const CardPage(this.topic, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final questions = ref.watch(questionProvider);
    // Fetch all questions once on startup
    useEffect(() {
      fetchQuestions(topic, ref);
      return null;
    }, const []);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addQuestion(context, ref, topic, 'Enter Prompt', 'Enter Answer', 1);
        },
        child: Icon(Icons.add, size: screenHeight * 0.04),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSecondary,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            height: screenHeight * 0.06,
            child: ListTile(
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.onSecondary,
                  ),
                  onTap: () {
                    ref.read(cardTopic.notifier).state = '';
                  },
                ),
              ),
              title: Text(
                topic,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontSize: screenHeight * 0.025,
                ),
              ),
            ),
          ),
          // List Builder
          Expanded(
            child: questions.isEmpty
                ? Center(child: Text('No questions for this topic'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: questions.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = questions[index];
                      return Cards(topic, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Card
class Cards extends ConsumerWidget {
  final String topic;
  final Map<String, dynamic> item;

  const Cards(this.topic, this.item, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sliderValue = ref.watch(sliderValueProvider);
    return Center(
      // ⬅️ This ensures horizontal centering inside scroll
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,

        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          color: theme.colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondary,
                                fontSize: screenHeight * 0.025,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: screenWidth * 0.02),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.edit,
                                      color: theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: theme.colorScheme.error,
                                    ), onTap: () {
                                      questionDelete(item['prompt'],topic, context, ref);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: screenHeight * 0.125),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Card(
                      elevation: 1,
                      child: Container(
                        width: screenWidth*0.4,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Reveal Answer',textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: Column(
                        children: [
                          Slider(
                            value: sliderValue[0],
                            min: 0,
                            max: 5,
                            divisions: 5,
                            label: sliderValue[0].toStringAsFixed(1),
                            onChanged: (newValue) {
                              final currentList = [
                                ...ref.read(sliderValueProvider),
                              ];
                              currentList[0] = newValue;
                              ref.read(sliderValueProvider.notifier).state =
                                  currentList;
                            },
                          ),
                          Text('Difficulty'),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02), // space between
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: Column(
                        children: [
                          Slider(
                            value: sliderValue[1],
                            min: 0,
                            max: 5,
                            divisions: 5,
                            activeColor: theme.colorScheme.inversePrimary,
                            label: sliderValue[1].toStringAsFixed(1),
                            onChanged: (newValue) {
                              final currentList = [
                                ...ref.read(sliderValueProvider),
                              ];
                              currentList[1] = newValue;
                              ref.read(sliderValueProvider.notifier).state =
                                  currentList;
                            },
                          ),
                          Text('Correctness'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fetch all questions
Future<void> fetchQuestions(String topic, WidgetRef ref) async {
  await initDb();
  final questions = await getQuestionsByTopic(db, topic);
  ref.read(questionProvider.notifier).state = questions;
}

// Add Questions
Future<void> addQuestion(
  BuildContext context,
  WidgetRef ref,
  String topic,
  String prompt,
  String correctAnswer,
  int interval,
) async {
  await initDb();
  final existing = await db.query(
    'questions',
    where: 'prompt = ?',
    whereArgs: [prompt],
  );
  if (existing.isEmpty) {
    await insertQuestion(topic, prompt, correctAnswer, interval, db);
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Question "$prompt" already exists for this topic'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
  await fetchQuestions(topic, ref);
}

// Delete Topic
Future<void> questionDelete(
  String prompt,
  String topic,
  BuildContext context,
  WidgetRef ref,
) async {
  await initDb();
  await deleteQuestion(prompt, db);
  await fetchQuestions(topic,ref);
}