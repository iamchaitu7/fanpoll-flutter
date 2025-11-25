import 'package:fan_poll/app/modules/search/controllers/search_controller.dart';
import 'package:fan_poll/app/routes/auth_guard.dart';
import 'package:get/get.dart';

import '../modules/comment/bindings/comment_binding.dart';
import '../modules/comment/views/comment_view.dart';
import '../modules/createpoll/bindings/createpoll_binding.dart';
import '../modules/createpoll/views/createpoll_view.dart';
import '../modules/editprofile/bindings/editprofile_binding.dart';
import '../modules/editprofile/views/editprofile_view.dart';
import '../modules/followers/bindings/followers_binding.dart';
import '../modules/followers/views/followers_view.dart';
import '../modules/following/bindings/following_binding.dart';
import '../modules/following/views/following_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/mypoll/bindings/mypoll_binding.dart';
import '../modules/mypoll/views/mypoll_view.dart';
import '../modules/mypolldetails/bindings/mypolldetails_binding.dart';
import '../modules/mypolldetails/controllers/mypolldetails_controller.dart';
import '../modules/mypolldetails/views/mypolldetails_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search/views/search_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/shared_poll/bindings/shared_poll_binding.dart';
import '../modules/shared_poll/views/shared_poll_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    // GetPage(
    //   name: _Paths.COMMENT,
    //   page: () => CommentView(pollId: Get.arguments),
    //   binding: CommentBinding(),
    //   transition: Transition.rightToLeftWithFade,
    //   transitionDuration: Duration(milliseconds: 400),
    // ),
    GetPage(
      name: _Paths.COMMENT,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return CommentView(pollId: args['poll_id']);
      },
      binding: CommentBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),

    GetPage(
      name: _Paths.CREATEPOLL,
      page: () => CreatepollView(),
      binding: CreatepollBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => const EditprofileView(),
      binding: EditprofileBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.MYPOLL,
      page: () => const MypollView(),
      binding: MypollBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => const ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.FOLLOWING,
      page: () => const FollowingView(),
      binding: FollowingBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.FOLLOWERS,
      page: () => const FollowersView(),
      binding: FollowersBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return SearchView(searchParam: args["search"], hashtagParam: args["hashtag"]);
      },
      binding: BindingsBuilder(() {
        Get.put(SearchController());
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.MYPOLLDETAILS,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return MypolldetailsView(
          pollId: args['poll_id'],
          selectedIndex: RxnInt(),
          option_id: RxnInt(),
          screenshotController: Get.find<MypolldetailsController>().screenshotController,
        );
      },
      binding: MypolldetailsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: _Paths.SHAREDPOLL,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return SharedPollView(
          pollId: args['pollId'],
          isGuest: args['isGuest'] ?? false,
        );
      },
      binding: SharedPollBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
  ];
}
