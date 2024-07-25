import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/location_service.dart';
import 'package:trust_reservation_second/widgets/custom_button.dart';


Widget buildVehicleSelectionStep(
  List<dynamic> vehicles,
  String selectedVehicle,
  String estimation,
  ValueChanged<String> onVehicleSelected,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Center(
        child: Text(
          'Choisir un véhicule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      ...vehicles.map((vehicle) {
        return buildVehicleOption(
          vehicle['typeVehicule'],
          vehicle['capacite_passagers'].toString(),
          vehicle['capacite_chargement'],
          vehicle['type_carburant'],
          estimation,
          vehicle['galerie'],
          selectedVehicle,
          onVehicleSelected,
        );
      }).toList(),
    ],
  );
}

Widget buildVehicleOption(
  String type,
  String seats,
  String trunk,
  String fuel,
  String price,
  String imagePath,
  String selectedVehicle,
  ValueChanged<String> onVehicleSelected,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Image.network(imagePath, height: 200, fit: BoxFit.cover),
        const SizedBox(height: 16),
        Text(
          type,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Type: $type | Pass: $seats | Bags: $trunk'),
        Text('Fuel: $fuel'),
        Text('Price: $price€'),
        const SizedBox(height: 8),
        CustomButton(
          onPressed: () {
            onVehicleSelected(type);
          },
          text: 'Choisir',
          backgroundColor: type == selectedVehicle ? Colors.orange : Colors.grey,
        ),
      ],
    ),
  );
}
Widget buildDateTimeSelectionStep(
  BuildContext context,
  DateTime? selectedDate,
  TimeOfDay? selectedTime,
  TextEditingController addressController,
  TextEditingController destinationController,
  bool isDefaultAddress,
  String estimation,
  String distParcourt,
  String durParcourt,
  ValueChanged<DateTime> onDateSelected,
  ValueChanged<TimeOfDay> onTimeSelected,
  VoidCallback onAddressSelected,
  VoidCallback onDestinationSelected,
  VoidCallback swapAddress,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  onDateSelected(pickedDate);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date', style: TextStyle(color: Colors.grey)),
                    Text(
                      selectedDate != null
                          ? DateFormat.yMMMMd('fr_FR').format(selectedDate)
                          : 'date',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  onTimeSelected(pickedTime);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Heure', style: TextStyle(color: Colors.grey)),
                    Text(
                      selectedTime != null ? selectedTime.format(context) : 'heure',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Autocomplete<Place>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<Place>.empty();
                          }
                          return LocationService.getSuggestions(textEditingValue.text)
                              .then((suggestions) => suggestions);
                        },
                        displayStringForOption: (Place option) => option.description,
                        onSelected: (Place selection) {
                          addressController.text = selection.description;
                          onAddressSelected();
                        },
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Adresse de départ',
                              border: InputBorder.none,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: const Icon(Icons.swap_horiz, color: ColorsApp.primaryColor),
              onPressed: swapAddress,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      if (!isDefaultAddress) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.69,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Autocomplete<Place>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<Place>.empty();
                      }
                      return LocationService.getSuggestions(textEditingValue.text)
                          .then((suggestions) => suggestions);
                    },
                    displayStringForOption: (Place option) => option.description,
                    onSelected: (Place selection) {
                      destinationController.text = selection.description;
                      onDestinationSelected();
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Adresse de destination',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.69,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$$estimation',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$distParcourt km',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$durParcourt',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

Widget buildStep3Content(
  List<int> passengerOptions,
  List<int> baggageOptions,
  List<String> paymentMethods,
  String? selectedPassengerCount,
  String? selectedBaggageCount,
  String? selectedPaymentMethod,
  TextEditingController flightTrainNumberController,
  TextEditingController caseNumberController,
  TextEditingController notesController,
  ValueChanged<String?> onPassengerCountChanged,
  ValueChanged<String?> onBaggageCountChanged,
  ValueChanged<String?> onPaymentMethodChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Center(
        child: Text(
          'Choisir un véhicule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Nombre de passagers'),
        value: passengerOptions.contains(int.tryParse(selectedPassengerCount ?? '')) 
            ? selectedPassengerCount 
            : null,
        items: passengerOptions
            .map((count) => DropdownMenuItem(
                  value: count.toString(),
                  child: Text(count.toString()),
                ))
            .toList(),
        onChanged: onPassengerCountChanged,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Nombre de bagages'),
        value: baggageOptions.contains(int.tryParse(selectedBaggageCount ?? '')) 
            ? selectedBaggageCount 
            : null,
        items: baggageOptions
            .map((count) => DropdownMenuItem(
                  value: count.toString(),
                  child: Text(count.toString()),
                ))
            .toList(),
        onChanged: onBaggageCountChanged,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Méthode de paiement'),
        value: paymentMethods.contains(selectedPaymentMethod) 
            ? selectedPaymentMethod 
            : null,
        items: paymentMethods
            .map((method) => DropdownMenuItem(
                  value: method,
                  child: Text(_formatPaymentMethodName(method)),
                ))
            .toList(),
        onChanged: onPaymentMethodChanged,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: flightTrainNumberController,
        decoration: const InputDecoration(
          labelText: 'Numéro de vol/train',
          hintText: 'Entrez le numéro de vol ou de train',
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Laissez le champ vide si vous n\'avez pas pris de vol ou de train',
        style: TextStyle(color: Colors.orange),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: caseNumberController,
        decoration: const InputDecoration(
          labelText: 'Numéro de dossier',
          hintText: 'Entrez le numéro de dossier',
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Laissez le champ vide si vous n\'avez pas de numéro de dossier',
        style: TextStyle(color: Colors.orange),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: notesController,
        decoration: const InputDecoration(
          labelText: 'Notes',
          hintText: 'Votre note',
        ),
      ),
    ],
  );
}

String _formatPaymentMethodName(String method) {
  switch (method) {
    case 'payement_paypal':
      return 'Paiement par PayPal';
    case 'payement_stripe':
      return 'Paiement par Stripe';
    case 'payement_abord':
      return 'Paiement à bord (espèce ou CB)';
    case 'payement_virement':
      return 'Paiement par virement bancaire';
    case 'payment_en_compte':
      return 'Paiement en compte';
    default:
      return method;
  }
}
Widget buildClientSelectionStep(
  bool isNewClient,
  List<Map<String, dynamic>> clients,
  String selectedClientId,
  ValueChanged<String?> onClientSelected,
  ValueChanged<bool> onClientTypeChanged,
  TextEditingController nameController,
  TextEditingController phoneController,
  TextEditingController emailController,
  TextEditingController addressController,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onClientTypeChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: !isNewClient ? ColorsApp.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    'ANCIEN CLIENT',
                    style: TextStyle(
                      color: !isNewClient ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => onClientTypeChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isNewClient ? ColorsApp.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    'NOUVEAU CLIENT',
                    style: TextStyle(
                      color: isNewClient ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      if (!isNewClient)
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Client',
            prefixIcon: Icon(Icons.person),
          ),
          value: selectedClientId,
          items: clients.map((client) {
            return DropdownMenuItem(
              value: client['id'].toString(),
              child: Text('${client['first_name']} ${client['last_name']}'),
            );
          }).toList(),
          onChanged: onClientSelected,
        ),
      if (isNewClient) ...[
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom du client',
            hintText: 'Entrez le nom du client',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Numéro de téléphone',
            hintText: 'Entrez le numéro de téléphone',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Adresse e-mail',
            hintText: 'Entrez l\'adresse e-mail',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Adresse du client',
            hintText: 'Entrez l\'adresse du client',
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
      ],
    ],
  );
}
