import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/hotel/facture_details_screen.dart';

class HistoryReservations extends StatefulWidget {
  const HistoryReservations({Key? key}) : super(key: key);

  @override
  State<HistoryReservations> createState() => _HistoryReservationsState();
}

class _HistoryReservationsState extends State<HistoryReservations> {
  final List<Map<String, String>> reservations = [
    {
      'name': 'Reservation 1',
      'address': '123 Main St',
      'time': '10:00 AM',
      'reservedBy': 'Will Smith',
    },
    {
      'name': 'Reservation 2',
      'address': '456 Elm St',
      'time': '12:00 PM',
      'reservedBy': 'Will Smith',
    },
    {
      'name': 'Reservation 3',
      'address': '789 Maple St',
      'time': '2:00 PM',
      'reservedBy': 'Will Smith',
    },
  ];

  final Set<int> _selectedReservations = {};

  void _showInvoiceOptions(BuildContext context, Map<String, String> reservation) {
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
                    builder: (context) => FactureDetailsScreen(reservation: reservation),
                  ),
                );
              },
              child: const Text('Facture'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to modification screen
              },
              child: const Text('Modify Reservation'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle cancellation
              },
              child: const Text('Cancel Reservation'),
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
                      builder: (context) => FactureDetailsScreen(reservation: reservations[index]),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            final isSelected = _selectedReservations.contains(index);
            return Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: CupertinoListTile(
                leading: const Icon(CupertinoIcons.calendar, color: CupertinoColors.systemBlue),
                title: Text(
                  reservation['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address: ${reservation['address']}'),
                    Text('Time: ${reservation['time']}'),
                    Text('Reserved by: ${reservation['reservedBy']}'),
                  ],
                ),
                trailing: isSelected
                    ? const Icon(CupertinoIcons.check_mark_circled_solid, color: CupertinoColors.systemBlue)
                    : const Icon(CupertinoIcons.circle),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedReservations.remove(index);
                    } else {
                      _selectedReservations.add(index);
                    }
                  });
                },
                onLongPress: () => _showInvoiceOptions(context, reservation),
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
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
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