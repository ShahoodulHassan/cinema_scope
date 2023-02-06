import 'package:cinema_scope/pages/home_page.dart';
import 'package:cinema_scope/pages/search_page.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/app_lifecycle_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'architecture/config_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtil.init();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppInfo.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => ConfigViewModel()..checkConfigurations()),
  ], child: const MyApp()));
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var mainColor = Colors.deepPurple;
    var appBarItemColor = Colors.black87;
    return AppLifecycleManager(
      child: MaterialApp(
        title: 'Cinema scope',
        theme: ThemeData(
          primarySwatch: mainColor,
          highlightColor: mainColor.shade100.withOpacity(0.5),
          useMaterial3: true,
          fontFamily: GoogleFonts.lato().fontFamily,
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              color: appBarItemColor,
              fontSize: 24.0,
              fontFamily: GoogleFonts.lato().fontFamily,
              // fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(
              color: appBarItemColor,
            ),
            iconTheme: IconThemeData(
              color: appBarItemColor,
            ),
          )
          // textTheme: Theme.of(context).textTheme.apply(
          //   fontSizeFactor: 1.1,
          //   fontSizeDelta: 2.0,
          // ),
        ),
        navigatorObservers: [routeObserver],
        home: const MyHomePage(title: 'Cinema scope'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget  {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with GenericFunctions,
    RouteAware {
  @override
  void initState() {
    super.initState();
    // context.read<ConfigViewModel>().getConfigurations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPush() {
    logIfDebug('didPush called');
    super.didPush();
  }

  @override
  void didPushNext() {
    logIfDebug('didPushNext called');
    super.didPushNext();
  }

  @override
  void didPopNext() {
    logIfDebug('didPopNext called');
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Selector<ConfigViewModel, bool>(
        builder: (_, isConfigComplete, __) {
          logIfDebug('isConfigComplete:$isConfigComplete');
          return isConfigComplete
              ? Center(
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          // color: Theme.of(context).primaryColor,
                          label: const Text(
                            'HOME',
                            style: TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              getHomePageRoute(),
                              // getSearchPageRoute(),
                            );
                          }, icon: const Icon(Icons.home_outlined),
                        ),
                        const SizedBox(height: 16.0,),
                        ElevatedButton.icon(
                          // color: Theme.of(context).primaryColor,
                          label: const Text(
                            'SEARCH',
                            style: TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              getSearchPageRoute(),
                              // getSearchPageRoute(),
                            );
                          }, icon: const Icon(Icons.search_rounded),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
        selector: (_, cvm) {
          return cvm.isConfigComplete;
        },
      ),
    );
  }

  getSearchPageRoute() => MaterialPageRoute(
        builder: (_) => SearchPage(),
      );

  getHomePageRoute() => MaterialPageRoute(
        builder: (_) => HomePage(),
      );
}
