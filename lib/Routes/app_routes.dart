// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const DASHBOARD = _Paths.DASHBOARD;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const PRODUCT = _Paths.PRODUCT;
  static const PRODUCTDETAIL = _Paths.PRODUCTDETAIL;
  static const CART = _Paths.CART;
  // static const WAITING = _Paths.WAITING;
  // static const SEARCH = _Paths.SEARCH;
  // static const SAVED = _Paths.SAVED;
}

abstract class _Paths {
  _Paths._();
  static const DASHBOARD = '/';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PRODUCT = '/product';
  static const PRODUCTDETAIL = '/product/detail';
  static const CART = '/cart';
  // static const WAITING = '/waiting';
  // static const SEARCH = '/search';
  // static const SAVED = '/saved';
}
