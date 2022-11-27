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

    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    Provider.of<Rentals>(context, listen: false)
        .loadRentalsByUser()
        .then((value) {
      setState(() {
        if (_isLoading) {
          context.loaderOverlay.hide();
          _isLoading = context.loaderOverlay.visible;
        }
        /*setState(() {
        });*/
      });
    });
  }

  Future<void> _refreshRentals(BuildContext context) {
    return Provider.of<Rentals>(
      context,
      listen: false,
    ).loadRentalsByUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;

    final provider = Provider.of<Rentals>(context);
    final List<Rental> rentalsUser = provider.rentalsFromUser;
    print(rentalsUser.length);

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
                : rentalsUser.isNotEmpty
                    ? ListView.builder(
                        itemCount: rentalsUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              RentalItem(
                                rentalDetail: rentalsUser[index],
                                car: rentalsUser[index].car,
                                currentUserId: '',
                              ),
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
