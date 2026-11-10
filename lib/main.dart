import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/portfolio/bloc/portfolio_bloc.dart';
import 'features/portfolio/bloc/portfolio_event.dart';
import 'features/portfolio/presentation/portfolio_screen.dart';
import 'features/market_watch/bloc/market_bloc.dart';
import 'features/market_watch/presentation/market_screen.dart';
import 'features/transactions/bloc/transaction_bloc.dart';
import 'features/transactions/bloc/transaction_event.dart';
import 'features/transactions/presentation/transactions_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PortfolioBloc>(
          create: (context) => PortfolioBloc()..add(LoadPortfolioEvent()),
        ),
        BlocProvider<MarketBloc>(
          create: (context) => MarketBloc(),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc()..add(LoadTransactionsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Fintech Trading Engine',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationShell(),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PortfolioScreen(),
    MarketScreen(),
    TransactionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet_rounded),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.candlestick_chart_outlined),
            activeIcon: Icon(Icons.candlestick_chart_rounded),
            label: "Trade",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: "Activity",
          ),
        ],
      ),
    );
  }
}
