import 'package:flutter/material.dart';
import 'package:trust_reservation_second/views/hotel/create_reservation.dart';

class PaymentSelection extends StatelessWidget {
  final VoidCallback onPaymentCompleted;

  const PaymentSelection({Key? key, required this.onPaymentCompleted}) : super(key: key);

  void _completePayment(BuildContext context) {
    onPaymentCompleted();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateReservation(),
        settings: RouteSettings(arguments: 3),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection du Moyen de Paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: Image.asset('assets/paypal.png', height: 40),
                title: const Text('PayPal'),
                onTap: () => _completePayment(context),
              ),
            ),
            Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: Image.asset('assets/carte_bleu.png', height: 40),
                title: const Text('Carte Bleu'),
                onTap: () => _completePayment(context),
              ),
            ),
            Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                leading: Image.asset('assets/payment_board.png', height: 40),
                title: const Text('Paiement à bord'),
                onTap: () => _completePayment(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
