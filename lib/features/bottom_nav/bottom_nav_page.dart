import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_nav_cubit.dart';
import 'bottom_nav_state.dart';

class BottomNavPage extends StatefulWidget {
  final BottomNavCubit cubit;

  const BottomNavPage({super.key, required this.cubit});

  @override
  State<BottomNavPage> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavPage> {
  BottomNavCubit get cubit => widget.cubit;

  static const List<String> _tabLabels = <String>[
    'Home',
    'Explore',
    'Activity',
    'Messages',
    'Profile',
  ];

  static const List<IconData> _tabIcons = <IconData>[
    Icons.home_outlined,
    Icons.explore_outlined,
    Icons.notifications_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  static const List<IconData> _tabActiveIcons = <IconData>[
    Icons.home,
    Icons.explore,
    Icons.notifications,
    Icons.chat_bubble,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    cubit.closeTabCubits();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        final state = cubit.state;
        if (state.selectedIndex > 0) {
          cubit.setSelectedIndex(0);
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) {
            return;
          }

          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => const ExitAppDialog(
              text: 'Are you sure you want to exit the app?',
              label: 'Exit App',
            ),
          );

          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        });
      },
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        bloc: cubit,
        builder: (context, state) {
          return Scaffold(
            body: cubit.pages.elementAt(state.selectedIndex),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF3F3F3), width: 1),
                ),
              ),
              child: SizedBox(
                height: 102.h,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: state.selectedIndex,
                    onTap: cubit.setSelectedIndex,
                    type: BottomNavigationBarType.fixed,
                    items: List.generate(
                      _tabLabels.length,
                      (index) => BottomNavigationBarItem(
                        icon: Icon(_tabIcons[index]),
                        activeIcon: Icon(_tabActiveIcons[index]),
                        label: _tabLabels[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExitAppDialog extends StatelessWidget {
  final String text;
  final String label;

  const ExitAppDialog({super.key, required this.text, required this.label});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(text),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(label),
      ),
    ],
  );
}
