import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/reservation_service.dart';
import 'package:trust_reservation_second/views/hotel/contact_form.dart';
import 'package:trust_reservation_second/views/hotel/payement_selection.dart';
import 'package:trust_reservation_second/views/hotel/voiture_choice.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/reservation_widgets.dart'; // Import des widgets

class CreateReservation extends StatefulWidget {
  const CreateReservation({super.key});

  @override
  State<CreateReservation> createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isDefaultAddress = true;
  int _currentStep = 0;

  String _selectedVehicle = '';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _estimation = '';
  String _distParcourt = '';
  String _durParcourt = '';

  List<dynamic> _vehicles = [];
  List<dynamic> _paymentMethods = [];

  final ReservationService _reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _reservationService.loadAddresses(_addressController);
    _reservationService.getCurrentLocation(_addressController);
    _addressController.addListener(_calculateEstimation);
    _destinationController.addListener(_calculateEstimation);
    _loadVehicles();
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _addressController.removeListener(_calculateEstimation);
    _destinationController.removeListener(_calculateEstimation);
    _addressController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _calculateEstimation() {
    _reservationService.calculateEstimation(
      _selectedDate,
      _selectedTime,
      _addressController,
      _destinationController,
      (distParcourt, durParcourt, estimation) {
        setState(() {
          _distParcourt = distParcourt;
          _durParcourt = durParcourt;
          _estimation = estimation;
        });
      },
    );
  }

  void _handleContactSubmitted(String name, String phone, String email) {
    setState(() {
      _name = name;
      _phone = phone;
      _email = email;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSelection(
          onPaymentCompleted: () {
            setState(() {
              _currentStep = 3;
            });
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateReservation(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _continue() async {
    if (_currentStep < 3) {
      if (_currentStep == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoitureChoice(
              onCarSelected: (car) {
                setState(() {
                  _selectedVehicle = car;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactForm(
                      onContactSubmitted: (name, phone, email) {
                        _handleContactSubmitted(name, phone, email);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        setState(() {
          _currentStep += 1;
        });
      }

      await _reservationService.saveReservationData(
        _currentStep,
        _addressController.text,
        _destinationController.text,
        _selectedDate,
        _selectedTime,
        context,
      );
    } else {
      // Handle form submission
    }
  }

  void _cancel() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
      await _reservationService.removeReservationData();
    }
  }

  void _loadVehicles() async {
    try {
      final vehicles = await _reservationService.getVehicules();
      setState(() {
        _vehicles = vehicles;
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  void _loadPaymentMethods() async {
    try {
      final methods = await _reservationService.getPaymentMethods();
      setState(() {
        _paymentMethods = methods;
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  List<Widget> _getStepContents(BuildContext context) {
    return [
      buildDateTimeSelectionStep(
        context,
        _selectedDate,
        _selectedTime,
        _addressController,
        _destinationController,
        isDefaultAddress,
        _estimation,
        _distParcourt,
        _durParcourt,
        (pickedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
          _calculateEstimation();
        },
        (pickedTime) {
          setState(() {
            _selectedTime = pickedTime;
          });
          _calculateEstimation();
        },
        () {
          _calculateEstimation();
        },
        () {
          _calculateEstimation();
        },
        () {
          _reservationService.swapAddress(
            _addressController,
            _destinationController,
            isDefaultAddress,
            _calculateEstimation,
          );
          setState(() {
            isDefaultAddress = !isDefaultAddress;
          });
        },
      ),
      buildVehicleSelectionStep(
        _vehicles,
        (vehicleType) {
          setState(() {
            _selectedVehicle = vehicleType;
          });
        },
      ),
      // Add other steps here...
    ];
  }

  Widget _buildStepIndicator(int step) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Row(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step == index ? ColorsApp.primaryColor : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (index < 3)
                Container(
                  height: 2,
                  width: 65,
                  color: Colors.grey,
                ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text(
              '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Reservation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 96),
                  _buildStepIndicator(_currentStep),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Étape ${_currentStep + 1}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _getStepContents(context)[_currentStep],
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: CustomButton(
                                onPressed: _continue,
                                text: _currentStep == 3 ? 'Confirmer' : 'Continuer',
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancel,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  minimumSize: const Size(50, 50),
                                ),
                                child: const Text('Annuler'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
