import 'package:carshare/models/rental.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class RentalTile extends StatefulWidget {
  Rental rental;
  bool rentalAction;
  bool rentalLabel;
  Function()? onTap;
  RentalTile(
      {Key? key,
      required this.rental,
      this.rentalAction = false,
      this.rentalLabel = false,
      this.onTap})
      : super(key: key);

  @override
  State<RentalTile> createState() => _RentalTileState();
}

class _RentalTileState extends State<RentalTile> {
  final _formData = <String, Object>{};
  bool _isLoading = false;

  Future<void> _updateRentalStatus(
    Rental rental,
    RentalStatus newStatus,
  ) async {
    final currentStatus = rental.status;
    rental.status = newStatus;

    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    try {
      await Provider.of<Rentals>(
        context,
        listen: false,
      ).updateRental(rental);
      await Provider.of<Rentals>(context, listen: false).loadRentalsByUser();
      widget.onTap!();
    } catch (error) {
      rental.status = currentStatus;
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } finally {
      if (_isLoading) {
        context.loaderOverlay.hide();
      }
      setState(() {
        _isLoading = context.loaderOverlay.visible;
        _labelTile();
      });
    }
  }

  _labelTile() {
    switch (widget.rental.status) {
      case RentalStatus.REFUSED:
        return ListTile(
          leading: Icon(
            Icons.close,
            size: 24,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          dense: true,
        );
      case RentalStatus.IN_PROGRESS:
        return ListTile(
          leading: Icon(
            Icons.directions_car_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}...",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          dense: true,
        );
      case RentalStatus.RENTED:
        return ListTile(
          leading: Icon(
            Icons.no_crash_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}!",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          dense: true,
        );
      case RentalStatus.LATE:
        return ListTile(
          leading: Icon(
            Icons.access_time_filled_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          dense: true,
        );
      case RentalStatus.PENDING:
        return ListTile(
          leading: Icon(
            Icons.pending_actions_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          dense: true,
        );
      case RentalStatus.RESERVED:
        return ListTile(
          leading: Icon(
            Icons.check_circle_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          dense: true,
        );
      default:
        return ListTile(
          title: Text(
            "${Rental.getRentalStatusText(widget.rental.status)}",
            style: TextStyle(
              fontFamily: 'RobotCondensed',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          dense: true,
        );
    }
  }

  _actionTile() {
    switch (widget.rental.status) {
      case RentalStatus.IN_PROGRESS:
        return ListTile(
          // leading: Icon(
          //   Icons.directions_car_rounded,
          //   size: 24,
          //   color: Theme.of(context).colorScheme.secondary,
          // ),
          tileColor: Theme.of(context).colorScheme.primary,
          title: Center(
            child: Text(
              "Confirmar devolução do veículo",
              style: TextStyle(
                fontFamily: 'RobotCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          dense: true,
          onTap: () {
            print("Mudar status para concluído");
            _updateRentalStatus(widget.rental, RentalStatus.RENTED);
          },
        );

      case RentalStatus.LATE:
        return ListTile(
          tileColor: Theme.of(context).colorScheme.error,
          title: Center(
            child: Text(
              "Confirmar devolução do veículo",
              style: TextStyle(
                fontFamily: 'RobotCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          dense: true,
          onTap: () {
            print("Mudar status para concluído");
             _updateRentalStatus(widget.rental, RentalStatus.RENTED);
          },
        );
      case RentalStatus.PENDING:
        return Column(
          children: [
            ListTile(
              tileColor: Theme.of(context).colorScheme.primary,
              title: Center(
                child: Text(
                  "Aprovar solicitação de locação do veículo",
                  style: TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              dense: true,
              onTap: () {
                print("Mudar status para aprovado");
                _updateRentalStatus(widget.rental, RentalStatus.RESERVED);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.error,
              title: Center(
                child: Text(
                  "Negar solicitação de locação do veículo",
                  style: TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              dense: true,
              onTap: () {
                print("Mudar status para aprovado");
                _updateRentalStatus(widget.rental, RentalStatus.REFUSED);
              },
            ),
            Divider(
              height: 10,
            ),
          ],
        );
      case RentalStatus.RESERVED:
        return ListTile(
          tileColor: Theme.of(context).colorScheme.primary,
          title: Center(
            child: Text(
              "Confirmar retirada do veículo",
              style: TextStyle(
                fontFamily: 'RobotCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          dense: true,
          onTap: () {
            print("Mudar status para Em andamento");
            _updateRentalStatus(widget.rental, RentalStatus.IN_PROGRESS);
          },
        );
      default:
        return Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rentalLabel) {
      return _labelTile();
    }

    if (widget.rentalAction) {
      return _actionTile();
    }

    return Center();
  }
}
