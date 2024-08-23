import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/reservation_service.dart';
import 'package:trust_reservation_second/views/hotel/resevation_details_screen.dart';
import 'package:flutter/foundation.dart';

class HistoryReservations extends StatefulWidget {
  const HistoryReservations({super.key});

  @override
  State<HistoryReservations> createState() => _HistoryReservationsState();
}

class _HistoryReservationsState extends State<HistoryReservations> {
  final ReservationService _reservationService = ReservationService();
  List<Map<String, dynamic>> reservations = [];
  final Set<int> _selectedReservations = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final response = await _reservationService.getReservations();
      setState(() {
        reservations = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load reservations: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showInvoiceOptions(BuildContext context, Map<String, dynamic> reservation) {
    if (_selectedReservations.isEmpty) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text('Options'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ReservationDetailsScreen(reservation: reservation),
                    ),
                  );
                },
                child: const Text('Voir Reservation'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to modification screen
                },
                child: const Text('Demander Facture'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          );
        },
      );
    }
  }

  void _showBulkInvoiceOptions(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Demande de Facture'),
          content: const Text('Voulez-vous demander une facture pour les réservations sélectionnées ?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                for (var index in _selectedReservations) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ReservationDetailsScreen(reservation: reservations[index]),
                    ),
                  );
                }
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedReservations.contains(index)) {
        _selectedReservations.remove(index);
      } else {
        _selectedReservations.add(index);
      }
    });
  }

  void _handleLongPress(int index) {
    setState(() {
      _selectedReservations.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Historique reservations'),
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: _selectedReservations.isNotEmpty
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showBulkInvoiceOptions(context),
                child: const Icon(CupertinoIcons.doc_text),
              )
            : null,
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  final isSelected = _selectedReservations.contains(index);
                  return Card(
                    color: const Color.fromARGB(213, 255, 255, 255),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CupertinoListTile(
                      leading: const Icon(CupertinoIcons.calendar, color: ColorsApp.primaryColor),
                      title: Text(
                        reservation['numero_reservation']?.toString() ?? 'Inconnu',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adresse: ${reservation['lieuxPriseEnCharge']?.toString() ?? 'Inconnu'}', style: const TextStyle(color: Colors.blue)),
                          Text('Heure: ${reservation['datePriseEnCharge']?.toString() ?? 'Inconnu'}', style: const TextStyle(color: Colors.red)),
                          Text('Destination: ${reservation['lieuxDestination']?.toString() ?? 'Inconnu'}', style: const TextStyle(color: Colors.green)),
                          Text('Coût: ${reservation['coutTransport']?.toString() ?? 'Inconnu'} €', style: const TextStyle(color: Colors.orange)),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green)
                          : const Icon(CupertinoIcons.circle),
                      onTap: () {
                        if (_selectedReservations.isEmpty) {
                          _showInvoiceOptions(context, reservation);
                        } else {
                          _toggleSelection(index);
                        }
                      },
                      onLongPress: () {
                        _handleLongPress(index);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CupertinoListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 4.0),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            trailing,
          ],
        ),
      ),
    );
  }
}
