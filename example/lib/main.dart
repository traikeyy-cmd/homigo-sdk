import 'package:flutter/material.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

Future<void> main() async {
  await HomiGoBootstrap.initialize(
    config: HomiGoBootstrapConfig(
      sdkConfig: const HomiGoConfig(
        appName: 'HomiGo SDK Example',
        environment: HomiGoEnvironment.development,
        themeMode: ThemeMode.system,
        defaultLocale: Locale('ar'),
      ),
    ),
  );

  runApp(const HomiGoExampleApp());
}

class HomiGoExampleApp extends StatelessWidget {
  const HomiGoExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: HomiGoSDK.config.appName,
      theme: HomiGoTheme.light(),
      darkTheme: HomiGoTheme.dark(),
      themeMode: HomiGoTheme.mode,
      home: const ExampleHomeScreen(),
    );
  }
}

class ExampleHomeScreen extends StatelessWidget {
  const ExampleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomiGo SDK')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            HomiGoGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'HomiGo SDK 1.0.1',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Reusable UI, platform adapters, core services, '
                    'networking and production infrastructure.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            HomiGoButton(
              text: 'HomiGo Button',
              onPressed: () {
                HomiGoSnackBar.show(
                  context: context,
                  message: 'HomiGo SDK is running.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
