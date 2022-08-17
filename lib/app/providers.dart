import 'package:likeplay/core/app/baseNotifier.dart';
import 'package:likeplay/core/view_model/drawer_viewmodel.dart';
import 'package:likeplay/core/view_model/message_viewmodel.dart';
import 'package:likeplay/core/view_model/play_ground_viewmodel.dart';
import 'package:likeplay/features/onboard/view_model/onboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/verification/view_model/verification_viewmodel.dart';
import '../view_model/home_viewmodel.dart';
import '../view_model/splash_viewmodel.dart';
import '../view_model/subscription_viewmodel.dart';
import '../view_model/success_viewmodel.dart';
import '../view_model/user_viewmodel.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => BaseChangeNotifier()),
  ChangeNotifierProvider(create: (_) => UserViewModel()),
  ChangeNotifierProvider(create: (_) => SplashViewModel()),
  ChangeNotifierProvider(create: (_) => SuccessViewModel()),
  ChangeNotifierProvider(create: (_) => HomeViewModel()),
  ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
  ChangeNotifierProvider(create: (_) => PlaygroundViewModel()),
  ChangeNotifierProvider(create: (_) => MessageViewModel()),
  ChangeNotifierProvider(create: (_) => OnBoardViewModel()),
  ChangeNotifierProvider(create: (_) => VerificationViewModel()),
  ChangeNotifierProvider(create: (_) => DrawerViewModel())
];
