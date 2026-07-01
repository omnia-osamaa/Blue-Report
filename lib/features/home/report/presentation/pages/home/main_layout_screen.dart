import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/home/report/presentation/pages/home/home_screen.dart';
import 'package:general_app/core/service/fcm_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/features/home/report/presentation/bloc/notification_cubit.dart';
import 'package:general_app/features/home/report/presentation/pages/report/my_report_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/my_impact_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/wallet_points_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final User user;

  const MainLayoutScreen({super.key, required this.user});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;
  final List<int> _visitedIndexes = [0];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      const MyImpactScreen(),
      const MyReportsScreen(),
      const WalletPointsScreen(),
    ];

    FCMService().notificationStream.listen((_) {
      if (mounted) {
        context.read<NotificationCubit>().loadNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_screens.length, (index) {
          if (_visitedIndexes.contains(index)) {
            return _screens[index];
          }
          return const SizedBox.shrink();
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (!_visitedIndexes.contains(index)) {
                _visitedIndexes.add(index);
              }
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined),
              activeIcon: Icon(Icons.auto_graph),
              label: 'Impact',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.report),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Wallet Points',
            ),
          ],
        ),
      ),
    );
  }
}
