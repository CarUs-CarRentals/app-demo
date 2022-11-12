import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/models/rental_list.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/models/user_list.dart';
import 'package:carshare/pages/auth_screen.dart';
import 'package:carshare/pages/car_detail_screen.dart';
import 'package:carshare/pages/car_form_screen.dart';
import 'package:carshare/pages/car_history_screen.dart';
import 'package:carshare/pages/car_reviews_screen.dart';
import 'package:carshare/pages/isAuth_screen.dart';
import 'package:carshare/pages/my_cars_screen.dart';
import 'package:carshare/pages/my_reviews_screen.dart';
import 'package:carshare/pages/my_rentals_screen.dart';
import 'package:carshare/pages/profile_edit_screen.dart';
import 'package:carshare/pages/profile_screen.dart';
import 'package:carshare/pages/profile_user_screen.dart';
import 'package:carshare/pages/rental_detail_screen.dart';
import 'package:carshare/pages/review_form_screen.dart';
import 'package:carshare/pages/user_reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'utils/app_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    final ThemeData myTheme = ThemeData();
    //Intl.defaultLocale = 'pt_BR';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarReviewList(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserReviewList(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarList(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserList(),
        ),
        ChangeNotifierProvider(
          create: (_) => RentalList(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        title: _title,
        //home: const MainMenu(),
        theme: myTheme.copyWith(
          colorScheme: myTheme.colorScheme.copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.grey[700],
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.IS_AUTH: (context) => const IsAuthScreen(),
          //AppRoutes.HOME: (context) => const TabsScreen(),
          AppRoutes.MY_RENTALS: (context) => const MyRentalsScreen(),
          AppRoutes.PROFILE: (context) => const ProfileScreen(),
          AppRoutes.PROFILE_USER: (context) => const ProfileUserScreen(),
          AppRoutes.PROFILE_EDIT: (context) => const ProfileEditScreen(),
          AppRoutes.MY_REVIEWS: (context) => const MyReviewsScreen(),
          AppRoutes.MY_CARS: (context) => const MyCarsScreen(),
          AppRoutes.CAR_DETAIL: (context) => CarDetailScreen(),
          AppRoutes.CAR_REVIEW: (context) => CarReviewsScreen(),
          AppRoutes.USER_REVIEW: (context) => UserReviewsScreen(),
          AppRoutes.RENTAL_DETAIL: (context) => RentalDetailScreen(),
          AppRoutes.REVIEW_FORM: (context) => ReviewFormScreen(),
          AppRoutes.CAR_HISTORY: (context) => CarRentalsHistoryScreen(),
          AppRoutes.CAR_FORM: (context) => CarFormScreen(),
        },
      ),
    );
  }
}
