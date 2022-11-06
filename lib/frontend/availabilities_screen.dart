import 'package:appointment_scheduler_flutterweb/backend/handler.dart';
import 'package:appointment_scheduler_flutterweb/backend/constants.dart'
    as constants;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AvailabilitiesScreen extends StatefulWidget {
  const AvailabilitiesScreen({super.key});

  @override
  AvailabilitiesScreenState createState() => AvailabilitiesScreenState();
}

class AvailabilitiesScreenState extends State<AvailabilitiesScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _resDelEmailController = TextEditingController();
  final TextEditingController _resDelRefController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedStartTime = DateTime(1999);
  DateTime _selectedEndTime = DateTime(1999);
  final NumberFormat _formatter = NumberFormat("00");

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Initialize all fields
  void initialize() {
    _dateController.text = '';
    _titleController.text = '';
    _emailController.text = '';
    _resDelEmailController.text = '';
    _resDelRefController.text = '';
    _selectedDate = DateTime.now();
    _selectedStartTime = DateTime(1999);
    _selectedEndTime = DateTime(1999);
  }

  // Fetch available time slots
  Future<void> _fetchAvailabilities() async {
    await Provider.of<Handler>(context, listen: false).fetchAvailabilities();
  }

  // Shows an altert dialog with title and text
  void _showDialog(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Attempts to delete the selected reservation
  Future<void> _deleteReservation() async {
    var prov = Provider.of<Handler>(
      context,
      listen: false,
    );
    if (_resDelRefController.text == '') {
      _showDialog('Error', 'Please select a valid reference.');
      return;
    }
    if (!prov.validateEmail(_resDelEmailController.text)) {
      _showDialog('Error', 'Please select an appropriate email.');
      return;
    }
    bool res = await prov.deleteReservation(
      _resDelRefController.text,
      _resDelEmailController.text,
    );
    res
        ? _showDialog('Success', 'Reservation deleted successfully')
        : _showDialog('Error', 'Please make sure this is a valid reference');
    if (res) {
      setState(() {
        _resDelEmailController.text = '';
        _resDelRefController.text = '';
      });
    }
  }

  // Attempts to reserve the selected time slot
  Future<void> _attemptReserve() async {
    if (_selectedStartTime.isAtSameMomentAs(DateTime(1999))) {
      _showDialog('Error', 'Please select an appropriate start date.');
      return;
    }
    if (_selectedEndTime.isAtSameMomentAs(DateTime(1999))) {
      _showDialog('Error', 'Please select an appropriate end date.');
      return;
    }
    if (_titleController.text == '') {
      _showDialog('Error', 'Please select an appropriate title.');
      return;
    }
    var prov = Provider.of<Handler>(
      context,
      listen: false,
    );
    if (!prov.validateEmail(_emailController.text)) {
      _showDialog('Error', 'Please select an appropriate email.');
      return;
    }
    String ref = await prov.createReservation(
      _selectedStartTime,
      _selectedEndTime,
      _titleController.text,
      _emailController.text,
    );
    setState(() {
      initialize();
    });
    _showDialog(
      'Success',
      'Reservation created successfully. Your reservation reference is $ref. Please keep this reference',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Schedule',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _fetchAvailabilities(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _fetchAvailabilities(),
                child: Consumer<Handler>(
                  builder: (context, prov, child) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.calendar_today,
                                  ),
                                  labelText: "Enter Reservation Date",
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: constants.START_DATE,
                                    lastDate: constants.END_DATE,
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat("dd/MM/yyyy")
                                            .format(pickedDate);
                                    setState(() {
                                      _dateController.text =
                                          formattedDate.toString();
                                      _selectedDate = pickedDate;
                                    });
                                  }
                                }),
                            SizedBox(
                              height: 45,
                            ),
                            prov.dayMap.containsKey(_selectedDate)
                                ? SizedBox(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Select a starting time for your reservation:',
                                        ),
                                        SizedBox(height: 15),
                                        DropdownButton(
                                          value: _selectedStartTime,
                                          items: [
                                            DropdownMenuItem(
                                              value: DateTime(1999),
                                              child: Text('Select a time slot'),
                                            ),
                                            ...(prov.dayMap[_selectedDate]!
                                                .map((dt) => DropdownMenuItem(
                                                      value: dt,
                                                      child: Text(
                                                          '${_formatter.format(dt.hour)}:${_formatter.format(dt.minute)}'),
                                                    ))
                                                .toList())
                                          ],
                                          onChanged: (value) => setState(() {
                                            _selectedStartTime = value!;
                                            _selectedEndTime = DateTime(1999);
                                          }),
                                        )
                                      ],
                                    ),
                                  )
                                : Text(
                                    'There are no appointments available for this day.',
                                  ),
                            _selectedStartTime.isAtSameMomentAs(DateTime(1999))
                                ? Container()
                                : SizedBox(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Select an ending time for your reservation:',
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        DropdownButton(
                                          value: _selectedEndTime,
                                          items: [
                                            DropdownMenuItem(
                                              value: DateTime(1999),
                                              child: Text('Select a time slot'),
                                            ),
                                            ...(prov
                                                .getTimesGivenStart(
                                                    _selectedStartTime)
                                                .map((dt) => DropdownMenuItem(
                                                      value: dt,
                                                      child: Text(
                                                          '${_formatter.format(dt.hour)}:${_formatter.format(dt.minute)}'),
                                                    ))
                                                .toList())
                                          ],
                                          onChanged: (value) => setState(
                                              () => _selectedEndTime = value!),
                                        )
                                      ],
                                    ),
                                  ),
                            _selectedEndTime.isAtSameMomentAs(DateTime(1999))
                                ? Container()
                                : SizedBox(
                                    height: 110,
                                    width: 200,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextField(
                                            controller: _titleController,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  "Enter Reservation Title",
                                            ),
                                          ),
                                          TextField(
                                            decoration: const InputDecoration(
                                              labelText:
                                                  "Enter Reservation Email",
                                            ),
                                            controller: _emailController,
                                          )
                                        ]),
                                  ),
                            SizedBox(
                              height: 30,
                            ),
                            TextButton(
                              onPressed: _attemptReserve,
                              child: const Text('Reserve'),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Or delete a reservation:',
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 150,
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Enter Reservation Reference",
                                    ),
                                    controller: _resDelRefController,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Enter Reservation Email",
                                    ),
                                    controller: _resDelEmailController,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextButton(
                                    onPressed: _deleteReservation,
                                    child: Text('Delete Reservation'),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
