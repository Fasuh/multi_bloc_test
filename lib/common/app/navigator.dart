import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final FluroRouter router = FluroRouter();
  static final List<String> _routeList = <String>[];
  static const defaultTransition = TransitionType.material;
  static const initRoute = "/";

  // static Future _navigatorReplace(Widget widget, BuildContext context, String path, TODO - check it
  //     {TransitionType transition = defaultTransition}) {
  //   _defineRoute(path, transition);
  //   return Navigator.pushReplacementNamed(context, path, arguments: widget);
  // }

  static Future _navigatorPost(Widget widget, BuildContext context, String path,
      {TransitionType transition = defaultTransition}) {
    _defineRoute(path, transition);
    return Navigator.pushNamed(context, path, arguments: widget);
  }

  // static void _navigatorPostAndRemoveUntil(Widget widget, BuildContext context, String path, String removePath,TODO - check it
  //     {TransitionType transition = defaultTransition}) {
  //   if (!_routeList.contains(path)) {
  //     _defineRoute(path, transition);
  //     _routeList.add(path);
  //   }
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     path,
  //     (Route r) => _removeUntilHelper(r, removePath),
  //     arguments: widget,
  //   );
  // }

  static Future _setAsBaseScreenWithKey(Widget widget, String path,
      {TransitionType transition = defaultTransition}) {
    return _setAsBaseScreenCommon(widget, navigatorKey.currentState, path,
        transition: transition);
  }

  // static void _setAsBaseScreen(Widget widget, BuildContext context, String path,TODO - check it
  //     {TransitionType transition = defaultTransition}) {
  //   _setAsBaseScreenCommon(widget, Navigator.of(context), path, transition: transition);
  // }

  static Future _setAsBaseScreenCommon(
      Widget widget, NavigatorState navigator, String path,
      {TransitionType transition = defaultTransition}) {
    if (!_routeList.contains(path)) {
      _defineRoute(path, transition);
      _routeList.add(path);
    }
    return navigator?.pushNamedAndRemoveUntil(
      path,
      (_) => false,
      arguments: widget,
    );
  }

  // static bool _removeUntilHelper(Route r, String removePath) {TODO - check it
  //   if (r?.settings?.name?.isEmpty ?? true) {
  //     return false;
  //   } else {
  //     return removePath.contains(r.settings.name);
  //   }
  // }

  static void _defineRoute(String path, TransitionType transition) {
    router.define(path, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ModalRoute.of(context).settings.arguments;
    }), transitionType: transition);
  }
}
