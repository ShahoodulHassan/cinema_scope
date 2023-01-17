import 'package:cinema_scope/pages/home_page.dart';
import 'package:cinema_scope/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'architecture/config_view_model.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ConfigViewModel()),
    // ChangeNotifierProvider(create: (_) => HeroViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var mainColor = Colors.indigo;
    return MaterialApp(
      title: 'Cinema scope',
      theme: ThemeData(
        primarySwatch: mainColor,
        highlightColor: mainColor.shade100.withOpacity(0.5),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cinema scope'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    context.read<ConfigViewModel>().getConfigurations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Selector<ConfigViewModel, bool>(
        builder: (_, isConfigFetched, __) {
          return isConfigFetched
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        child: const Text(
                          'HOME',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            getHomePageRoute(),
                            // getSearchPageRoute(),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        },
        selector: (_, cvm) {
          return cvm.isConfigFetched;
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  getSearchPageRoute() => MaterialPageRoute(
        builder: (_) => SearchPage(),
      );

  getHomePageRoute() => MaterialPageRoute(
        builder: (_) => HomePage(),
      );
}
