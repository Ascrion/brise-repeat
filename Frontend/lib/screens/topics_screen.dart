import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

final tasksCompleted = StateProvider<int>((ref) => 0);
final totalTasks = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), DayPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    final completedTasks = ref.watch(tasksCompleted);
    final tasksTotal = ref.watch(totalTasks);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                width: screenWidth*0.25,
                height: screenHeight*0.06,
                placeholderBuilder: (context) => CircularProgressIndicator(),
              ),
              Text(
                '$completedTasks/$tasksTotal cards reviewed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            theme.bottomNavigationBarTheme.unselectedLabelStyle,
        backgroundColor: theme.colorScheme.secondary,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() => _selectedIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'All Topics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Today\'s Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'User Account',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('🏠 Home Page'));
}

class DayPage extends StatelessWidget {
  const DayPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('📅 Day Page'));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('👤 Account Page'));
}
