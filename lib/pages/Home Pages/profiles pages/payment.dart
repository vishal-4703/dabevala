import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pay/pay.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class TColor {
  static const Color primaryText = Color(0xFF000000);
  static const Color secondaryText = Color(0xFF888888);
  static const Color textfield = Color(0xFFE0E0E0);
  static const Color primary = Color(0xFF00FF00);
}

class payment extends StatefulWidget {
  const payment({Key? key}) : super(key: key);

  @override
  State<payment> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<payment> {
  late Razorpay _razorpay;
  static const platform = MethodChannel('com.example.payment/phonepe');
  PaymentConfiguration? _gpayConfig;

  DatabaseReference _cartRef = FirebaseDatabase.instance.ref().child('user_cart');
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadGooglePayConfiguration();
    _fetchCartItems();
  }

  Future<void> _loadGooglePayConfiguration() async {
    final gpayConfig = await PaymentConfiguration.fromAsset('gpay.json');
    setState(() {
      _gpayConfig = gpayConfig;
    });
  }

  void _updateTotalPriceInFirebase(double totalPrice) {
    _cartRef.child('totalPrice').set(totalPrice);
  }

  Future<void> _fetchCartItems() async {
    _cartRef.onValue.listen((event) {
      List<Map<String, dynamic>> cartItems = [];
      double totalPrice = 0.0;

      for (var item in event.snapshot.children) {
        Map<String, dynamic> cartItem = {
          'name': item.child('name').value,
          'price': item.child('price').value,
          'quantity': item.child('quantity').value,
        };
        cartItems.add(cartItem);
        totalPrice += (cartItem['price'] as double) * (cartItem['quantity'] as int);
      }

      setState(() {
        _cartItems = cartItems;
        _totalPrice = totalPrice;
      });

      // Update total price in Firebase
      _updateTotalPriceInFirebase(totalPrice);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.code} - ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay API key
      'amount': (_totalPrice * 100).toInt(), // Total amount in paise
      'name': 'DABBAWALA',
      'description': 'Payment for Order',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: _totalPrice.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor: TColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var item in _cartItems)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['name']} (x${item['quantity']})', style: TextStyle(fontSize: 16)),
                            Text('₹${item['price'] * item['quantity']}', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$_totalPrice',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Pay with Razorpay',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (_gpayConfig != null)
              GooglePayButton(
                paymentConfiguration: _gpayConfig!,
                paymentItems: _paymentItems,
                onPaymentResult: (result) {
                  print('Google Pay result: $result');
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
