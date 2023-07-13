import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:time_converter/converter_screeen.dart';
import 'package:time_converter/theme.dart';
import 'package:time_converter/timezone_list_screen.dart';

// TODO: ui for convert amd impl
// TODO: cache future builder data for ___ time interval
// TODO: add search bar
// TODO: add dark theme, with actual darkened appbar

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: light,
      darkTheme: dark,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Current Time'),
              Tab(text: 'Convert'),
            ],
            labelStyle: width > 600 ? theme.textTheme.headlineSmall : theme.textTheme.bodyMedium,
          ),
          title: const Text('Tabs Demo'),
        ),
        body: const TabBarView(
          children: [
            TimeZoneListScreen(),
            ConverterScreen(),
          ],
        ),
      ),
    );
  }
}
