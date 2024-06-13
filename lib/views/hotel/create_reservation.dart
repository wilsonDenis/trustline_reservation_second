import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReservation extends StatefulWidget {
  const CreateReservation({super.key});

  @override
  State<CreateReservation> createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _departureController.text = prefs.getString('departure_address') ?? 'Adresse de départ';
      _arrivalController.text = prefs.getString('arrival_address') ?? 'Adresse d\'arrivée';
    });
  }

  void _swapLocations() {
    setState(() {
      String temp = _departureController.text;
      _departureController.text = _arrivalController.text;
      _arrivalController.text = temp;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: const Locale('fr', 'FR'),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/carousel_image_4.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Réservation",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Heure',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      _selectedTime != null
                                          ? _selectedTime!.format(context)
                                          : 'Sélectionner l\'heure',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      _selectedDate != null
                                          ? DateFormat.yMMMMd('fr_FR').format(_selectedDate!)
                                          : 'Sélectionner la date',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _departureController,
                        decoration: InputDecoration(
                          labelText: 'Adresse de départ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _arrivalController,
                        decoration: InputDecoration(
                          labelText: 'Adresse d\'arrivée',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Builder(
                          builder: (BuildContext context) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_departureController.text.isNotEmpty &&
                                    _arrivalController.text.isNotEmpty &&
                                    _selectedDate != null &&
                                    _selectedTime != null) {
                                  // Handle the form submission
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(255, 0, 26, 51),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Confirmer la Réservation'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _departureController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }
}
