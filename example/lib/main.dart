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

class ExampleHomeScreen extends StatefulWidget {
  const ExampleHomeScreen({super.key});

  @override
  State<ExampleHomeScreen> createState() => _ExampleHomeScreenState();
}

class _ExampleHomeScreenState extends State<ExampleHomeScreen> {
  String _view = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomiGo SDK 1.1.0')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HomiGoSpacing.xl),
          children: [
            HomiGoSegmentedControl<String>(
              value: _view,
              items: const [
                HomiGoSegmentItem(value: 'active', label: 'Active'),
                HomiGoSegmentItem(value: 'completed', label: 'Completed'),
              ],
              onChanged: (value) {
                setState(() => _view = value);
              },
            ),
            const SizedBox(height: HomiGoSpacing.xl),
            HomiGoCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomiGoElevatedIcon(icon: Icons.schedule_rounded),
                  const SizedBox(width: HomiGoSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _view == 'active'
                              ? 'Custom request card'
                              : 'Completed request card',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: HomiGoSpacing.sm),
                        Text(
                          'This content belongs to the host application. '
                          'HomiGo supplies the visual primitives.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: HomiGoSpacing.md),
                        HomiGoStatusBadge(
                          label: _view == 'active' ? 'In progress' : 'Completed',
                          status: _view == 'active'
                              ? HomiGoStatus.info
                              : HomiGoStatus.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HomiGoSpacing.xl),
            HomiGoButton(
              text: 'HomiGo Button',
              onPressed: () {
                HomiGoSnackBar.show(
                  context: context,
                  message: 'HomiGo Native UI is running.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
