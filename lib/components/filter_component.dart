import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final List<bool> _selectedGearshift = <bool>[false, false, true];
  final List<bool> _isSelectedCategory = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<String> _carCategoryList =
      CarCategory.values.map((category) => category.name).toList();
  final List<String> _carGearshiftList =
      CarGearShift.values.map((gearshift) => gearshift.name).toList();
  String _gearshiftFilter = "";
  String _categoryFilter = "";
  bool _isLoading = false;

  Future<void> _applyFilter() async {
    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });
    await Provider.of<Cars>(
      context,
      listen: false,
    ).loadCarsBySearch(category: _categoryFilter, gearShift: _gearshiftFilter);
    setState(() {
      if (_isLoading) {
        context.loaderOverlay.hide();
      }
      setState(() {
        _isLoading = context.loaderOverlay.visible;
      });
    });
  }

  _resetFilter() {
    for (var i = 0; i < _selectedGearshift.length; i++) {
      setState(() {
        _selectedGearshift[i] = false;
      });
    }

    for (var i = 0; i < _isSelectedCategory.length; i++) {
      setState(() {
        _isSelectedCategory[i] = false;
      });
    }
  }

  _transmissionFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < _selectedGearshift.length; i++) {
                _selectedGearshift[i] = i == index;
              }

              if (_gearshiftFilter == _carGearshiftList[index] ||
                  _carGearshiftList[index] == "BOTH") {
              } else {
                _gearshiftFilter = _carGearshiftList[index];
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Theme.of(context).colorScheme.primary,
          selectedColor: Colors.white,
          fillColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.primary,
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 120.0,
          ),
          isSelected: _selectedGearshift,
          children: CarGearShift.values.map((CarGearShift gearshift) {
            return Text("${Car.getGearShiftText(gearshift)}");
          }).toList(),
        ),
      ],
    );
  }

  _carCategoryFilter() {
    return SizedBox(
      height: 397,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
          children: List.generate(_isSelectedCategory.length, (index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < _isSelectedCategory.length; i++) {
                      _isSelectedCategory[i] = i == index;
                    }
                    if (_categoryFilter == _carCategoryList[index]) {
                      _categoryFilter = "";
                    } else {
                      _categoryFilter = _carCategoryList[index];
                    }
                  });
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: _isSelectedCategory[index]
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40, bottom: 10),
                          child: Icon(
                            Icons.directions_car_rounded,
                            size: 24,
                            color: _isSelectedCategory[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                            Car.getCategoryText(
                                CarCategory.values.elementAt(index)),
                            style: TextStyle(
                              color: _isSelectedCategory[index]
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  ),
                ));
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height * 0.9 - kBottomNavigationBarHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: Text('Fechar'),
          ),
          title: Center(
              child: Text(
            "Filtros Avançados",
            style: Theme.of(context).textTheme.headline6,
          )),
          trailing: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: _isLoading
                ? null
                : () {
                    _resetFilter();
                  },
            child: const Text('Redefinir'),
          ),
        ),
        _isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.transparent,
              )
            : Divider(
                color: Colors.transparent,
                height: 4,
              ),
        SizedBox(
          width: mediaQuery.size.width,
          height: availableHeight,
          child: ListView(
            padding: EdgeInsets.only(bottom: 10, top: 0, left: 8, right: 8),
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Transmissão',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _transmissionFilter(),
              Divider(
                height: 50,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Categoria do Veículo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _carCategoryFilter(),
              Divider(
                height: 50,
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _applyFilter();
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Aplicar Filtro',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
