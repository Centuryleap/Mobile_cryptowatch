import 'package:flutter/foundation.dart';
import 'package:likeplay/core/app/app.locator.dart';
import 'package:likeplay/core/repositories/hive_repository.dart';
import 'package:likeplay/core/repositories/playground_repository.dart';
import 'package:likeplay/core/repositories/navigation_handler.dart';
import 'package:likeplay/core/repositories/user_repository.dart';

class BaseChangeNotifier extends ChangeNotifier {
  late UserRepository userRepository;
  late PlayGroundRepository playgroundRepository;
  late HiveRepository hiveRepository;
  late NavigationHandler navigationHandler;

  BaseChangeNotifier({
    UserRepository? userRepository,
    PlayGroundRepository? playgroundRepository,
    HiveRepository? hiveRepository,
    NavigationHandler? navigationHandler,
  }) {
    this.userRepository = userRepository ?? locator();
    this.playgroundRepository = playgroundRepository ?? locator();
    this.hiveRepository = hiveRepository ?? locator();
    this.navigationHandler = navigationHandler ?? locator();
  }

  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  String _loadingType = "";
  String get loadingType => _loadingType;
  set loadingType(String value) {
    _loadingType = value;
    notifyListeners();
  }
}
