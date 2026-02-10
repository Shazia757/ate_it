import 'package:get/get.dart';
import 'app_routes.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/main_view.dart';
import '../views/home/restaurant_details_view.dart';
import '../views/orders/orders_view.dart';
import '../views/wallet/wallet_view.dart';
import '../views/auth/onboarding_view.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
    ),
    GetPage(
      name: Routes.RESTAURANT_DETAILS,
      page: () => const RestaurantDetailsView(),
    ),
    GetPage(
      name: Routes.REPORT_ISSUE,
      page: () => const ReportIssueView(),
    ),
    GetPage(
      name: Routes.WALLET_TOPUP,
      page: () => const TopupView(),
    ),
    GetPage(
      name: Routes.WALLET_TOPUP_REQUESTS,
      page: () => const TopupRequestsView(),
    ),
    GetPage(
      name: Routes.WALLET_TRANSACTIONS,
      page: () => const TransactionsView(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
    ),
  ];
}
