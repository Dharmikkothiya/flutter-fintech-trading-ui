# 📈 Flutter Fintech & Crypto Portfolio Engine (Clean Bloc)

An enterprise-grade, high-performance financial mobile application built with Flutter. Demonstrates 60+ FPS zero frame-drop rendering, complex candlestick charts, gesture-driven micro-interactions, and reactive state management using BLoC.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)](https://dart.dev)
[![Bloc](https://img.shields.io/badge/BLoC-8.1+-blue.svg?style=for-the-badge)](https://bloclibrary.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

---

## 🌟 Key Highlights

- 📊 **Real-Time Market Charts:** Smooth interactive Candlestick & Area charts with live simulated tick data and technical indicators (MA, EMA, Volume).
- 🎨 **Adaptive Neumorphic & Cyber UI:** Dynamic Cyber Dark & Obsidian Fintech themes with zero layout rebuild overhead.
- ⚡ **Zero-Jank Performance:** Optimized widget trees, `const` constructors, RepaintBoundaries, and custom painters for heavy high-frequency rendering.
- 🏛️ **BLoC Clean Architecture:** Strictly decoupled Domain, Data, and Presentation layers with 100% testable event-driven business logic.
- 💱 **Multi-Currency Portfolio:** Instant real-time asset valuation, P&L calculations (24h gainers/losers), and asset distribution.
- 📜 **Interactive Order Book & Depth Chart:** Bid/Ask depth charts, live spread calculation, and simulated execution logs.

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** Flutter (Dart 3+)
- **State Management:** `flutter_bloc` (^8.1.3) & `equatable`
- **Charts & Visualization:** Custom Candlestick Painter & `fl_chart`
- **Formatting:** `intl` (Currency, percentage, and timestamp formatting)
- **Icons:** `cupertino_icons` & Material Symbols

---

## 📂 Architecture Structure

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart        # Cyber Dark, Neon Green & Crimson palettes
│   │   └── app_theme.dart         # Material 3 typography and component styling
│   └── utils/
│       ├── currency_formatter.dart# Multi-currency formatting ($ USD, € EUR, ₹ INR)
│       └── math_helpers.dart      # Moving average & percentage change calculations
├── features/
│   ├── portfolio/
│   │   ├── bloc/                  # PortfolioBloc, PortfolioEvent, PortfolioState
│   │   ├── models/                # CryptoAsset, PortfolioSummary
│   │   └── presentation/          # PortfolioDashboardScreen, AssetAllocationCard
│   ├── market_watch/
│   │   ├── bloc/                  # MarketBloc, MarketEvent, MarketState
│   │   ├── models/                # CandlestickData, TickerModel
│   │   └── presentation/          # MarketWatchScreen, CandlestickChartWidget, OrderBookWidget
│   └── transactions/
│       ├── bloc/                  # TransactionBloc, TransactionEvent, TransactionState
│       ├── models/                # TransactionModel
│       └── presentation/          # TransactionsScreen, TransactionTile
└── main.dart                      # MultiBlocProvider setup and application entry point
```

---

## ⚙️ Quick Start

### 1. Clone the repository:
```bash
git clone https://github.com/Dharmikkothiya/flutter-fintech-trading-ui.git
cd flutter-fintech-trading-ui
```

### 2. Install dependencies:
```bash
flutter pub get
```

### 3. Run the application:
```bash
flutter run
```

---

## 🧪 Testing & Code Quality

Run the unit and BLoC test suite:

```bash
flutter test
flutter analyze
```

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.
