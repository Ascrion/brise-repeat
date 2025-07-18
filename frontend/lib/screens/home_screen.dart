import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/topics_screen.dart';

/// StateProvider to track the selected tab index
final selectedIndexProvider = StateProvider<int>((ref) => 0);

// Track Search button state
final searchProvider = StateProvider<String>((ref) => '');
final isEditingProvider = StateProvider<bool>((ref) => false);

/// Main scaffold widget with bottom navigation
class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  static final _pages = [TopicsPage(), TasksPage(), StatsPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedIndex = ref.watch(selectedIndexProvider);
    final searchBar = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.inversePrimary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Brise',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
              Text(
                ' Repeat',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 0,
        actions: [
          Card(
            child: SizedBox(
              width: screenWidth * 0.35, // Compulsory
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Expanded(
                    child: InlineEditText(
                      valueProvider: searchProvider,
                      editingProvider: isEditingProvider,
                      hintText: 'Search here...',
                    ),
                  ),
                  if (searchBar.isNotEmpty)
                    InkWell(
                      onTap: () => ref.read(searchProvider.notifier).state = '',
                      child: Icon(
                        Icons.cancel,
                        size: screenWidth * 0.05,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_outlined),
            iconSize: screenWidth * 0.08,
          ),
        ],
      ),
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.tertiary,
              blurRadius: 5,
              offset: Offset(0, -1), // Shadow above the bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) =>
              ref.read(selectedIndexProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Topics'),
            BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Tasks'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }
}

/// Todays Tasks
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('📅 Day Page'));
}

/// Stats page
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('👤 Account Page'));
}

// Text Edit widget
class InlineEditText extends ConsumerStatefulWidget {
  final StateProvider<String> valueProvider;
  final StateProvider<bool> editingProvider;
  final String hintText;

  const InlineEditText({
    super.key,
    required this.valueProvider,
    required this.editingProvider,
    this.hintText = 'Enter text',
  });

  @override
  ConsumerState<InlineEditText> createState() => _InlineEditTextState();
}

class _InlineEditTextState extends ConsumerState<InlineEditText> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialText = ref.read(widget.valueProvider);
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(widget.editingProvider);
    final currentValue = ref.watch(widget.valueProvider);

    if (_controller.text != currentValue) {
      _controller.text = currentValue;
      _controller.selection = TextSelection.collapsed(
        offset: currentValue.length,
      );
    }

    return GestureDetector(
      onTap: () {
        ref.read(widget.editingProvider.notifier).state = true;
      },
      child: isEditing
          ? TextField(
              controller: _controller,
              autofocus: true,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                ref.read(widget.valueProvider.notifier).state = value;
                ref.read(widget.editingProvider.notifier).state = false;
              },
              onEditingComplete: () {
                ref.read(widget.valueProvider.notifier).state =
                    _controller.text;
                ref.read(widget.editingProvider.notifier).state = false;
              },
            )
          : Text(currentValue, style: const TextStyle(fontSize: 16)),
    );
  }
}
