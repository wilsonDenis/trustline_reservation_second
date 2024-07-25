import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/reservation_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';
import 'package:trust_reservation_second/widgets/reservation_widgets.dart';

class CreateReservation extends StatefulWidget {
  const CreateReservation({super.key});

  @override
  State<CreateReservation> createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _flightTrainNumberController = TextEditingController();
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _clientAddressController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isDefaultAddress = true;
  int _currentStep = 0;
  bool _isNewClient = true;
  

  String _selectedVehicle = '';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _estimation = '';
  String _distParcourt = '';
  String _durParcourt = '';

  String _selectedPassengerCount = '';
  String _selectedBaggageCount = '';
  String? _selectedPaymentMethod;
  String? _selectedClientId;

  List<dynamic> _vehicles = [];
  List<String> _paymentMethods = [];
  List<Map<String, dynamic>> _clients = [];

  final ReservationService _reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    _loadClients();
    _reservationService.loadAddresses(_addressController);
    _reservationService.getCurrentLocation(_addressController);
    _addressController.addListener(_calculateEstimation);
    _destinationController.addListener(_calculateEstimation);
    _flightTrainNumberController.addListener(_calculateEstimation);
    _caseNumberController.addListener(_calculateEstimation);
    _notesController.addListener(_calculateEstimation);
    _loadVehicles();
    _loadPaymentMethods();
    _selectedPaymentMethod = null;
  }

  @override
  void dispose() {
    _addressController.removeListener(_calculateEstimation);
    _destinationController.removeListener(_calculateEstimation);
    _flightTrainNumberController.removeListener(_calculateEstimation);
    _caseNumberController.removeListener(_calculateEstimation);
    _notesController.removeListener(_calculateEstimation);
    _addressController.dispose();
    _destinationController.dispose();
    _flightTrainNumberController.dispose();
    _caseNumberController.dispose();
    _notesController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _clientAddressController.dispose();
    super.dispose();
  }

  void _calculateEstimation() {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _addressController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
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
  }

  void _continue() async {
    if (_currentStep == 3) {
      // Handle form submission or final step actions
    } else {
      setState(() {
        _currentStep += 1;
      });
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
        _paymentMethods = methods.map((method) => method['nom'].toString()).toList();
        if (_paymentMethods.isNotEmpty) {
          _selectedPaymentMethod = _paymentMethods.first;
        }
      });
    } catch (e) {
      // Gérer l'erreur
      if (kDebugMode) {
        print('Erreur lors du chargement des méthodes de paiement : $e');
      }
    }
  }
void _loadClients() async {
  try {
    final response = await _reservationService.getClients();
    setState(() {
      _clients = List<Map<String, dynamic>>.from(
        response.map((client) {
          return {
            'id': client['id'] is int ? client['id'] : int.tryParse(client['id'].toString()) ?? 0,
            'first_name': client['first_name'],
            'last_name': client['last_name'],
            // ajouter les autres champs nécessaires ici
          };
        }).toList(),
      );
    });
  } catch (e) {
    // Gérer l'erreur
    if (kDebugMode) {
      print('Erreur lors du chargement des clients : $e');
    }
  }
}


  Widget _buildClientSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isNewClient = true;
                    _selectedClientId = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isNewClient ? ColorsApp.primaryColor : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  'NOUVEAU CLIENT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isNewClient = false;
                    _selectedClientId = _clients.isNotEmpty ? _clients.first['id'].toString() : null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isNewClient ? ColorsApp.primaryColor : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  'ANCIEN CLIENT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isNewClient) ...[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom du client',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Numéro de téléphone',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Adresse e-mail',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          TextFormField(
            controller: _clientAddressController,
            decoration: const InputDecoration(
              labelText: 'Adresse du client',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ] else ...[
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Client',
              prefixIcon: Icon(Icons.person),
            ),
            value: _selectedClientId,
            items: _clients.map((client) {
              return DropdownMenuItem(
                value: client['id'].toString(),
                child: Text('${client['first_name']} ${client['last_name']}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedClientId = value;
              });
            },
          ),
        ],
      ],
    );
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
        _calculateEstimation,
        _calculateEstimation,
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
        _selectedVehicle,
        _estimation,
        (vehicleType) {
          setState(() {
            _selectedVehicle = vehicleType;
          });
        },
      ),
      buildStep3Content(
        [1, 2, 3, 4],
        [1, 2, 3, 4],
        _paymentMethods,
        _selectedPassengerCount,
        _selectedBaggageCount,
        _selectedPaymentMethod,
        _flightTrainNumberController,
        _caseNumberController,
        _notesController,
        (value) {
          setState(() {
            _selectedPassengerCount = value!;
          });
        },
        (value) {
          setState(() {
            _selectedBaggageCount = value!;
          });
        },
        (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
      ),
      _buildClientSelection(),
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
                  const SizedBox(height: 20),
                  _buildStepIndicator(_currentStep),
                  const SizedBox(height: 40),
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
                                backgroundColor: Colors.blue,
                                onPressed: _continue,
                                text: _currentStep == 3 ? 'Confirmer' : 'Continuer',
                                disabled: !(_selectedDate != null &&
                                    _selectedTime != null &&
                                    _addressController.text.isNotEmpty &&
                                    _destinationController.text.isNotEmpty), // Désactivé si les conditions ne sont pas remplies
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancel,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
