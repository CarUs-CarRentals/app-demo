import 'package:carshare/components/cars_list_view.dart';
import 'package:carshare/providers/cars.dart';
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
  bool _isLoading = true;

  Future<void> _refreshCars(BuildContext context) {
    return Provider.of<Cars>(
      context,
      listen: false,
    ).loadCars();
  }

  Future<void> _searchButton(String value) async {
    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });
    print(value);
    await Provider.of<Cars>(
      context,
      listen: false,
    ).loadCarsBySearch(value, "address");
    setState(() {
      if (_isLoading) {
        context.loaderOverlay.hide();
      }
      setState(() {
        _isLoading = context.loaderOverlay.visible;
      });
    });
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
                      height: 115,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 7,
                                child: OutlineSearchBar(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 0, right: 5, bottom: 10),
                                  elevation: 3,
                                  hintText: "Endereço, UF, Cidade ou Bairro",
                                  borderColor:
                                      const Color.fromRGBO(179, 179, 179, 5),
                                  borderWidth: 0.0,
                                  searchButtonIconColor:
                                      Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0.0)),
                                  ignoreSpecialChar: true,
                                  searchButtonPosition:
                                      SearchButtonPosition.leading,
                                  onTap: () {
                                    print("pesquisa");
                                  },
                                  onClearButtonPressed: (_) {
                                    _refreshCars(context);
                                  },
                                  onSearchButtonPressed: (value) async {
                                    _searchButton(value);
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: PhysicalModel(
                                  elevation: 3,
                                  shape: BoxShape.rectangle,
                                  shadowColor: Color.fromRGBO(179, 179, 179, 5),
                                  color: Theme.of(context).colorScheme.surface,
                                  child: IconButton(
                                    splashRadius: 1,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    icon: const Icon(Icons.filter_list_alt),
                                    tooltip: 'Filtros Avaçados',
                                    onPressed: () {
                                      print("Filtros");
                                    },
                                  ),
                                ),
                              ),
                            ],
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
