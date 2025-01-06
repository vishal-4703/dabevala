import 'package:flutter/material.dart';
class payment extends StatefulWidget {
  @override
  _paymentState createState() => _paymentState();
}

class _paymentState extends State<payment> {
  String selectedAddress = 'Home';
  String selectedPaymentMethod = 'Credit card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, 'card');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '02',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping to',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            AddressCard(
              title: 'Home',
              phone: '',
              address: '',
              isSelected: selectedAddress == 'Home',
              onSelect: () {
                setState(() {
                  selectedAddress = 'Home';
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            PaymentMethod(
              icon: Icons.credit_card,
              title: 'Credit card',
              isSelected: selectedPaymentMethod == 'Credit card',
              onSelect: () {
                setState(() {
                  selectedPaymentMethod = '';
                });
              },
            ),
            PaymentMethod(
              icon: Icons.account_balance_wallet,
              title: 'Paypal',
              isSelected: selectedPaymentMethod == 'Paypal',
              onSelect: () {
                setState(() {
                  selectedPaymentMethod = 'Paypal';
                });
              },
            ),
            PaymentMethod(
              icon: Icons.payment,
              title: 'Google pay',
              isSelected: selectedPaymentMethod == 'Google pay',
              onSelect: () {
                setState(() {
                  selectedPaymentMethod = 'Google pay';
                });
              },
            ),
            Spacer(),
            Summary(
              onPlaceOrder: () {
                Navigator.pushNamed(context, '/orderConfirmation');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final String phone;
  final String address;
  final bool isSelected;
  final VoidCallback onSelect;

  AddressCard({
    required this.title,
    required this.phone,
    required this.address,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Radio(
                value: isSelected,
                groupValue: true,
                onChanged: (value) {
                  onSelect();
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onSelect;

  PaymentMethod({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Radio(
        value: isSelected,
        groupValue: true,
        onChanged: (value) {
          onSelect();
        },
      ),
      onTap: onSelect,
    );
  }
}

class Summary extends StatelessWidget {
  final VoidCallback onPlaceOrder;

  Summary({required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sub total'),
                Text(
                  '\₹550',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text(
                  '\₹550',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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