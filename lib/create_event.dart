import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  final String selectedDate;

  const CreateEventScreen({super.key, required this.selectedDate});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String eventName = '';
  String eventDescription = '';
  TimeOfDay? selectedTime;

  // Function to open the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Default time
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Date & Time'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Center(
                            child: Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : "HH:MM",
                          style: TextStyle(
                              color: selectedTime != null
                                  ? Colors.black
                                  : Colors.black26,
                              fontSize: 14),
                        )),
                      ),
                    ),
                  ),
                  Text(widget.selectedDate),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Name'),
                onSaved: (value) {
                  eventName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  eventDescription = value!;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final data = {
                        "time": selectedTime,
                        "eventName": eventName,
                        "eventDesc": eventDescription
                      };

                      Navigator.pop(context, eventName);
                      //Navigator.pop(context, data);
                    }
                  },
                  child: const Text('Save',
                      style:
                          TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
