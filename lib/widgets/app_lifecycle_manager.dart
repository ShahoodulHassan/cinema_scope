import 'package:cinema_scope/providers/configuration_provider.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLifecycleManager extends StatefulWidget {
  const AppLifecycleManager({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManager();
}

class _AppLifecycleManager extends State<AppLifecycleManager>
    with GenericFunctions, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // context.read<ConfigViewModel>().getConfigurations();
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logIfDebug('lifecycle state:$state');
    context.read<ConfigurationProvider>().appState = state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
