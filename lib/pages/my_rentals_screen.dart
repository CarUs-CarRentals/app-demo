import 'package:carshare/components/rental_item.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class MyRentalsScreen extends StatefulWidget {
  const MyRentalsScreen({Key? key}) : super(key: key);

  @override
  State<MyRentalsScreen> createState() => _MyRentalsScreenState();
}

class _MyRentalsScreenState extends State<MyRentalsScreen> {
  bool _isLoading = true;
  List<Rental> _rentalsUser = [];
  int _tryCount = 0;

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   _isLoading = true;
    // });

    // Provider.of<Rentals>(context, listen: false)
    //     .loadRentalsByUser()
    //     .then((value) {
    //   setState(() {
    //     if (_isLoading) {
    //       _isLoading = false;
    //     }
    //   });
    // });
  }

  Future<void> _refreshRentals(BuildContext context) {
    setState(() {
      _isLoading = true;
      _rentalsUser = [];
      _tryCount = 0;
    });
    return Provider.of<Rentals>(
      context,
      listen: false,
    ).loadRentalsByUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rentalsUser.isEmpty && _tryCount < 3) {
      final provider = Provider.of<Rentals>(context);
      final List<Rental> rentalsUser = provider.rentalsFromUser;
      _tryCount = _tryCount + 1;
      if (rentalsUser.isEmpty) {
        _rentalsUser = rentalsUser;
        Provider.of<Rentals>(context, listen: false).loadRentalsByUser();
      } else {
        _rentalsUser = rentalsUser;
      }
    }

    if (_rentalsUser.isNotEmpty || _tryCount >= 3) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;

    //final provider = Provider.of<Rentals>(context);
    //final List<Rental> rentalsUser = provider.rentalsFromUser;

    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () => _refreshRentals(context),
        child: LoaderOverlay(
          overlayOpacity: 1,
          overlayColor: Colors.white,
          child: SizedBox(
            width: mediaQuery.size.width,
            height: availableHeight,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _rentalsUser.isNotEmpty
                    ? ListView.builder(
                        itemCount: _rentalsUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              RentalItem(
                                rentalDetail: _rentalsUser[index],
                                car: _rentalsUser[index].car,
                                currentUserId: '',
                              ),
                              Divider(),
                            ],
                          );
                        },
                      )
                    : LoaderOverlay(
                        overlayOpacity: 1,
                        overlayColor: Colors.white,
                        child: SizedBox(
                          width: mediaQuery.size.width,
                          height: availableHeight,
                          child: Center(
                            child: Text('Sem registros'),
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
