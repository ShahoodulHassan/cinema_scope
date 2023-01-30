import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../architecture/config_view_model.dart';
import '../utilities/generic_functions.dart';

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
    context.read<ConfigViewModel>().appState = state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
