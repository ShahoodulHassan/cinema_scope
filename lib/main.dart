import 'package:cinema_scope/architecture/app_provider.dart';
import 'package:cinema_scope/pages/home_page.dart';
import 'package:cinema_scope/utilities/generic_functions.dart';
import 'package:cinema_scope/utilities/utilities.dart';
import 'package:cinema_scope/widgets/app_lifecycle_manager.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'architecture/config_view_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Global application level context
var appContext = navigatorKey.currentState!.overlay!.context;

final ThemeData _kThemeData = Theme.of(appContext);

final ColorScheme kColorScheme = _kThemeData.colorScheme;

final Color kScaffoldBackgroundColor = _kThemeData.scaffoldBackgroundColor;
final Color kPrimary = kColorScheme.primary;
final Color kPrimaryContainer = kColorScheme.primaryContainer;

final Color kBackgroundColor = kPrimary.lighten2(88);

final double kScaffoldPaddingTop = MediaQuery.paddingOf(appContext).top;

void main() async {
  debugPrint('main called');
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtil.init();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppInfo.init();
  runApp(MyProviders());
}

class MyProviders extends MultiProvider {
  MyProviders({super.key})
      : super(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ConfigViewModel()..checkConfigurations(),
            ),
            ChangeNotifierProvider(
              create: (_) => AppProvider(),
            ),
          ],
          child: MyApp(),
        );
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget with GenericFunctions {
  MyApp({super.key});

  late final primarySwatch = buildMaterialColor(getColorFromHexCode('#895EA0'));

  // late final _defaultLightColorScheme =
  //     ColorScheme.fromSeed(seedColor: getColorFromHexCode('#895EA0'));
  //
  // late final _defaultDarkColorScheme = ColorScheme.fromSwatch(
  //     primarySwatch: primarySwatch, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    logIfDebug('build called');
    // var primarySwatch = Colors.amber;
    var primaryColor = getColorFromHexCode('#452665'); // 174378
    var appBarItemColor = Colors.black87;
    var fontFamily = 'Poppins';
    return AppLifecycleManager(
      child: DynamicColorBuilder(
        builder: (light, dark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Cinema scope',
            theme: ThemeData(
              colorSchemeSeed: primaryColor,
              highlightColor: primaryColor.withValues(alpha: 0.10),
              splashColor: primaryColor.withValues(alpha: 0.10),
              useMaterial3: true,
              fontFamily: fontFamily,
              scrollbarTheme: Theme.of(context).scrollbarTheme.copyWith(
                    thumbColor: const WidgetStatePropertyAll(Colors.black26),
                    radius: const Radius.circular(12.0),
                  ),
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                  color: appBarItemColor,
                  fontSize: 22,
                  fontFamily: fontFamily,
                  height: 1.2,
                  // fontWeight: FontWeight.bold,
                ),
                actionsIconTheme: IconThemeData(
                  color: appBarItemColor,
                ),
                iconTheme: IconThemeData(
                  color: appBarItemColor,
                ),
              ),
            ),
            navigatorObservers: [routeObserver],
            builder: (ctx, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
            home: Selector<ConfigViewModel, bool>(
              builder: (_, isConfigComplete, __) {
                logIfDebug('isConfigComplete:$isConfigComplete');
                return isConfigComplete ? HomePage() : const SizedBox.shrink();
              },
              selector: (_, cvm) => cvm.isConfigComplete,
            ),
            // home: const MyHomePage(title: 'Cinema scope'),
          );
        },
      ),
    );
  }
}
