import 'package:flutter/material.dart';

import '../main.dart';


/// Any class that extends this class can then listen to navigation events by
/// overriding methods like didPush(), didPop() etc.
///
/// It provides a standard way to perform tasks while leaving for the next page,
/// coming back from the next page or going back to the previous page.

abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware {


  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }



}
