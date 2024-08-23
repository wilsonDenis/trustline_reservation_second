// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _clientAddressController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool isDefaultAddress = true;
  int _currentStep = 0;
  bool _isNewClient = true;

  String _selectedVehicle = '';
  String _selectedVehicleName = '';
  String _estimation = '';
  String _distParcourt = '';
  String _durParcourt = '';

  String _selectedPassengerCount = '';
  String _selectedBaggageCount = '';
  String? _selectedPaymentMethod;
  String? _selectedClientId;
  String? _selectedClientType;

  List<dynamic> _vehicles = [];
  List<String> _paymentMethods = [];
  List<Map<String, dynamic>> _clients = [];
  int? _userId;  // Ajoutez cette ligne

  final ReservationService _reservationService = ReservationService();
  void _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  setState(() {
    _userId = userId;

  });
}


  @override
  void initState() {
    super.initState();
    _loadClients();
    _loadUserData();
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _clientAddressController.dispose();
    super.dispose();
    _reservationService.clearLocalStorage();
  }

  void _calculateEstimation() async {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _addressController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
      final estimation = await _reservationService.calculateEstimation(
        _selectedDate!,
        _selectedTime!,
        _addressController.text,
        _destinationController.text,
      );
      if (estimation != null) {
        setState(() {
          _distParcourt = estimation['distance']!;
          _durParcourt = estimation['duration']!;
          _estimation = estimation['cost']!;
        });
      }
    }
  }

  bool _validateStepFields() {
    switch (_currentStep) {
      case 0:
        return _selectedDate != null && _selectedTime != null && _addressController.text.isNotEmpty && _destinationController.text.isNotEmpty;
      case 1:
        return _selectedVehicle.isNotEmpty;
      case 2:
        return _selectedPassengerCount.isNotEmpty && _selectedBaggageCount.isNotEmpty && _selectedPaymentMethod != null;
      case 3:
        return (_isNewClient && _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty && _phoneController.text.isNotEmpty && _emailController.text.isNotEmpty && _clientAddressController.text.isNotEmpty) ||
            (!_isNewClient && _selectedClientId != null);
      default:
        return false;
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _reservationService.clearLocalStorage();
                setState(() {
                  _currentStep = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

 void _continue() async {
  if (_validateStepFields()) {
    if (_currentStep == 3) {
      // Assurez-vous que l'ID du client est bien défini
      if (!_isNewClient && _selectedClientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez choisir un client existant')),
        );
        return;
      }

      await _showSummary();
    } else {
      setState(() {
        _currentStep += 1;
      });
    }
  } else {
    await _showErrorDialog('Veuillez remplir tous les champs nécessaires.');
  }
}
Future<void> _showSummary() async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Résumé de la réservation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Client: ${_isNewClient ? '${_firstNameController.text} ${_lastNameController.text}' : _clients.firstWhere((client) => client['id'].toString() == _selectedClientId)['first_name']}'),
              Text('Départ: ${_addressController.text}'),
              Text('Destination: ${_destinationController.text}'),
              Text('Date de prise en charge: ${DateFormat.yMMMMd('fr_FR').format(_selectedDate!)} à ${_selectedTime!.format(context)}'),
              Text('Distance: $_distParcourt km'),
              Text('Durée: $_durParcourt'),
              Text('Véhicule: $_selectedVehicleName'), // Affichage du nom du véhicule
              Text('Passagers: $_selectedPassengerCount'),
              Text('Bagages: $_selectedBaggageCount'),
              Text('Mode de paiement: $_selectedPaymentMethod'),
              Text('N° de vol/train: ${_flightTrainNumberController.text.isEmpty ? 'N/A' : _flightTrainNumberController.text}'),
              Text('N° de dossier: ${_caseNumberController.text.isEmpty ? 'N/A' : _caseNumberController.text}'),
              Text('Notes: ${_notesController.text.isEmpty ? 'Aucune note' : _notesController.text}'),
              Text('Coût total de la réservation: $_estimation €'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Retour'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
       TextButton(
  child: const Text('Réserver'),
  onPressed: () async {
    try {
      if (_isNewClient) {
        if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty || _clientAddressController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez remplir tous les champs pour créer un nouveau client')),
          );
          return;
        }

        final clientId = await _reservationService.createClient({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'address': _clientAddressController.text,
          'type_client': _selectedClientType ?? 'client_simple',
          'type_utilisateur': 'client',
        });

        setState(() {
          _selectedClientId = clientId.toString();
        });
      }

      await _reservationService.createReservation({
        'client': {'id': int.parse(_selectedClientId!)},
        'depart': _addressController.text,
        'destination': _destinationController.text,
        'datePriseEnCharge': _selectedDate!.toIso8601String(),
        'heurePriseEnCharge': _selectedTime!.format(context),
        'distance': _distParcourt,
        'duree': _durParcourt,
        'vehicule': _selectedVehicle,
        'passagers': _selectedPassengerCount,
        'bagages': _selectedBaggageCount,
        'modeDePaiement': _selectedPaymentMethod,
        'numeroVolTrain': _flightTrainNumberController.text,
        'numeroDossier': _caseNumberController.text,
        'notes': _notesController.text,
        'coutTransport': '0',
        'coutMajorer': '0',
        'lieuxPriseEnCharge': _addressController.text,
        'lieuxDestination': _destinationController.text,
        'typeReservation': 'Standard',
        'coutTotal': _estimation,
        'totalAttributCost': '0',
        'destinationInputs': 'Default',
        'utilisateur': _userId,
      });

      await _reservationService.clearLocalStorage();
      if (!mounted) return;
      Navigator.of(context).pop();
      setState(() {
        _currentStep = 0;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Réservation créée avec succès!')),
          );
        }
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la réservation: $e')),
      );
    }
  },
),
        ],
      );
    },
  );
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
            };
          }).toList(),
        );
      });
    } catch (e) {
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
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Type de client',
              prefixIcon: Icon(Icons.account_box),
            ),
            value: _selectedClientType,
            items: const [
              DropdownMenuItem(value: 'client_simple', child: Text('Client Simple')),
              DropdownMenuItem(value: 'client_liee_agence', child: Text('Client Liée à une Agence')),
              DropdownMenuItem(value: 'client_liee_societe', child: Text('Client Liée à une Société')),
              DropdownMenuItem(value: 'client_societe', child: Text('Client Société')),
              DropdownMenuItem(value: 'client_agence', child: Text('Client Agence')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedClientType = value;
              });
            },
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Prénom du client',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nom du client',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
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
        _selectedVehicleName,
        _estimation,
        (vehicleType, vehicleName) {
          setState(() {
            _selectedVehicle = vehicleType;
            _selectedVehicleName = vehicleName;
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
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: step == index ? ColorsApp.primaryColor : Color.fromARGB(255, 116, 114, 114),
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
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width * 0.9;

    if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
      containerWidth = width * 0.6;
    }
    if (ResponsiveBreakpoints.of(context).largerThan(DESKTOP)) {
      containerWidth = width * 0.4;
    }

    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/carousel_image_4.jpg',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      // const SizedBox(height: 130),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Reservation',
                          style: TextStyle(
                            fontSize: 20,
                            color:ColorsApp.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildStepIndicator(_currentStep),
                      const SizedBox(height: 20),
                      Container(
                        width: containerWidth,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 10,
                            ),
                          ],
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
                                    disabled: !_validateStepFields(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _cancel,
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
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
          ],
        ),
      ),
    );
  }
}