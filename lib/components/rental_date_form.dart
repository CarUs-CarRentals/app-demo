import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class RentalDateForm extends StatefulWidget {
  const RentalDateForm({Key? key}) : super(key: key);

  @override
  State<RentalDateForm> createState() => _RentalDateFormState();
}

class _RentalDateFormState extends State<RentalDateForm> {
  DateTime _currentDate = DateTime.now();
  DateTime _selectedPickupDate = DateTime.now();
  DateTime _selectedReturnDate = DateTime.now();

  Future pickPickupDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      _selectedPickupDate = dateTime;
      _selectedReturnDate = _selectedPickupDate;
      _currentDate = _selectedPickupDate;
    });
  }

  Future pickReturnDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      _selectedReturnDate = dateTime;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: _currentDate,
        lastDate: _currentDate.add(const Duration(days: 30)),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: _currentDate.hour,
          minute: _currentDate.minute,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(children: const [
            Text(
              'Período de Locação:',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ]),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  dense: true,
                  onTap: () => pickPickupDateTime(),
                  title: Center(
                      child: Text(
                    'Data Inicial: ${DateFormat('EEEE, dd/MM/y - HH:mm').format(_selectedPickupDate)}',
                    style: TextStyle(fontSize: 14),
                  )),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  dense: true,
                  onTap: () => pickReturnDateTime(),
                  title: Center(
                    child: Text(
                      'Data Final: ${DateFormat('EEEE, dd/MM/y - HH:mm').format(_selectedReturnDate)}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
