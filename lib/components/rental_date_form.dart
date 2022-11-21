import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class RentalDateForm extends StatefulWidget {
  final Function onSelectDate;
  const RentalDateForm(this.onSelectDate, {Key? key}) : super(key: key);

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
      widget.onSelectDate(_selectedPickupDate, _selectedReturnDate);
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
      widget.onSelectDate(_selectedPickupDate, _selectedReturnDate);
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

  Widget _DataTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'RobotCondensed',
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
        size: 32,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Text(
                'Período de Locação:',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          _DataTile(
              Icons.calendar_today,
              'Data Inicial: ${DateFormat('EEE, dd/MM/y - HH:mm', 'pt_BR').format(_selectedPickupDate)}',
              pickPickupDateTime),
          Divider(),
          _DataTile(
              Icons.calendar_today,
              'Data Final: ${DateFormat('EEE, dd/MM/y - HH:mm', 'pt_BR').format(_selectedReturnDate)}',
              pickReturnDateTime),
          Divider(),

          /*Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  dense: true,
                  onTap: () => pickPickupDateTime(),
                  title: Center(
                    child: Text(
                      'Data Inicial: ${DateFormat('EEEE, dd/MM/y - HH:mm').format(_selectedPickupDate)}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
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
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
