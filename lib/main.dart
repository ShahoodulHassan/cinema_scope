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

class MyApp extends StatelessWidget with GenericFunctions {
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
        home: Selector<ConfigViewModel, bool>(
          builder: (_, isConfigComplete, __) {
            logIfDebug('isConfigComplete:$isConfigComplete');
            return isConfigComplete
                ? HomePage()
                : const SizedBox.shrink();
          },
          selector: (_, cvm) => cvm.isConfigComplete,
        ),
        // home: const MyHomePage(title: 'Cinema scope'),
      ),
    );
  }
}

// class ConfigCheckerPage extends StatelessWidget with GenericFunctions {
//   const ConfigCheckerPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Selector<ConfigViewModel, bool>(
//       builder: (_, isConfigComplete, __) {
//         logIfDebug('isConfigComplete:$isConfigComplete');
//         return isConfigComplete
//             ? HomePage()
//             : const SizedBox.shrink();
//       },
//       selector: (_, cvm) {
//         return cvm.isConfigComplete;
//       },
//     );
//   }
// }

