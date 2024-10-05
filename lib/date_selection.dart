import 'package:flutter/material.dart';

import 'create_event.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  String selectedYear = 'Select Year';
  String selectedMonth = 'Select Month';

  Map<String, String> events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Date')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),

                  onPressed: () => _showYearPicker(context),
                  child: Text(selectedYear,
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
              SizedBox(width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _showMonthPicker(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: Text(selectedMonth != 'Select Month' ?
                    selectedMonth.toString().substring(0, 3) : 'Select Month',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child:
                selectedYear != 'Select Year' && selectedMonth != 'Select Month'
                    ? ListView.builder(
                        itemCount: _daysInMonth(),
                        itemBuilder: (context, index) {
                          int day = index + 1;
                          String dateKey = "$selectedYear-$selectedMonth-$day";
                          return ListTile(
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      '$day \n${selectedMonth.toString().substring(0, 3)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Container(
                                          height: 45,
                                          width: 2,
                                          color: Colors.black45),
                                    ),
                                    Text(events[dateKey] ?? ''),
                                  ],
                                ),
                                const Divider()
                              ],
                            ),
                            onTap: () => _navigateToCreateEvent(context, day),
                          );
                        },
                      )
                    : const Center(child: Text('Please select year and month')),
          ),
        ],
      ),
    );
  }

  int _daysInMonth() {
    int year = int.parse(selectedYear);
    int month =
        DateTime.parse("2023-${_monthToNumber(selectedMonth)}-01").month;
    return DateTime(year, month + 1, 0).day;
  }

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            int year = 2016 + index;
            return ListTile(
              title: Text('$year'),
              onTap: () {
                setState(() {
                  selectedYear = '$year';
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: List.generate(12, (index) {
            String month = _monthNames[index];
            return ListTile(
              title: Text(month),
              onTap: () {
                setState(() {
                  selectedMonth = month;
                });
                Navigator.pop(context);
              },
            );
          }),
        );
      },
    );
  }

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _monthToNumber(String month) {
    return (_monthNames.indexOf(month) + 1).toString().padLeft(2, '0');
  }

  void _navigateToCreateEvent(BuildContext context, int day) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventScreen(
          selectedDate: "$selectedYear-$selectedMonth-$day",
        ),
      ),
    );

    if (result != null) {
      setState(() {
        events["$selectedYear-$selectedMonth-$day"] = result;
      });
    }
  }
}
