import 'package:carshare/firebase_options.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/providers/addresses.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/providers/drive_licenses.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:carshare/providers/users.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

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
          create: (_) => Cars(),
        ),
        ChangeNotifierProvider(
          create: (_) => Users(),
        ),
        ChangeNotifierProvider(
          create: (_) => Addresses(),
        ),
        ChangeNotifierProvider(
          create: (_) => DriverLicenses(),
        ),
        ChangeNotifierProvider(
          create: (_) => Rentals(),
        ),
        ChangeNotifierProvider(
          create: (_) => Reviews(),
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
            textTheme: myTheme.textTheme.copyWith(
                subtitle2: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.normal))),
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
