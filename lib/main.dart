import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/models/user_list.dart';
import 'package:carshare/pages/auth_screen.dart';
import 'package:carshare/pages/car_detail_screen.dart';
import 'package:carshare/pages/car_reviews_screen.dart';
import 'package:carshare/pages/isAuth_screen.dart';
import 'package:carshare/pages/my_cars_screen.dart';
import 'package:carshare/pages/my_reviews_screen.dart';
import 'package:carshare/pages/my_trips_screen.dart';
import 'package:carshare/pages/profile_edit_screen.dart';
import 'package:carshare/pages/profile_screen.dart';
import 'package:carshare/pages/profile_user_screen.dart';
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
        },
      ),
    );
  }
}

// class MainMenu extends StatefulWidget {
//   const MainMenu({Key? key}) : super(key: key);

//   @override
//   State<MainMenu> createState() => _MainMenuState();
// }

// class _MainMenuState extends State<MainMenu> {
//   int _selectedIndex = 0;
//   // static const TextStyle optionStyle =
//   //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _screenOptions = <Widget>[
//     HomeScreen(),
//     MyTripsScreen(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screenOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.speed),
//             label: 'Minhas Viagens',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Conta',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Theme.of(context).colorScheme.primary,
//         unselectedItemColor: Theme.of(context).colorScheme.secondary,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//}
