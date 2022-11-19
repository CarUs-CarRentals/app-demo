import 'package:carshare/components/cars_list_view.dart';
import 'package:carshare/models/car_list.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshCars(BuildContext context) {
    return Provider.of<CarList>(
      context,
      listen: false,
    ).loadCars();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final availableHeight = mediaQuery.size.height - kBottomNavigationBarHeight;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () => _refreshCars(context),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            SizedBox(
              width: mediaQuery.size.width,
              height: availableHeight,
              child: Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.hardEdge,
                children: [
                  Container(
                    height: availableHeight,
                    margin: const EdgeInsets.only(top: 150),
                    child: const LoaderOverlay(
                      overlayOpacity: 1,
                      overlayColor: Colors.white,
                      child: CarsListView(
                        titleList: 'Carros próximos de você',
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: 150,
                      child: ClipRRect(
                        child: Image(
                          image: AssetImage("assets/images/home-screen.jpg"),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          color: Color.fromARGB(255, 156, 156, 156),
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 10,
                    left: 10,
                    child: SizedBox(
                      width: mediaQuery.size.width,
                      child: Column(
                        children: [
                          Text(
                            "CarUs",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OutlineSearchBar(
                            margin: const EdgeInsets.all(10),
                            elevation: 3,
                            hintText: "Pesquise aqui",
                            borderColor: const Color.fromRGBO(179, 179, 179, 5),
                            borderWidth: 0.0,
                            searchButtonIconColor:
                                Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0.0)),
                            ignoreSpecialChar: true,
                            searchButtonPosition: SearchButtonPosition.leading,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
