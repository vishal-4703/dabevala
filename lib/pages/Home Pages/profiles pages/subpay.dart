import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pay/pay.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class TColor {
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFFFFFFF);
  static const Color textfield = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF0F954D);
}

class Subpay extends StatefulWidget {
  const Subpay({Key? key}) : super(key: key);

  @override
  State<Subpay> createState() => _SubpayState();
}

class _SubpayState extends State<Subpay> {
  late Razorpay _razorpay;
  static const platform = MethodChannel('com.example.payment/phonepe');
  PaymentConfiguration? _gpayConfig;

  DatabaseReference _subscriptionRef = FirebaseDatabase.instance
      .ref()
      .child('subscriptions')
      .child('mHgwiq1U2pc2rNQ8JHjhdkCQhrH2'); // Correct User ID

  String _plan = "Loading...";
  double _price = 0.0;
  List<String> _features = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadGooglePayConfiguration();
    _fetchSubscriptionDetails();
  }

  Future<void> _loadGooglePayConfiguration() async {
    try {
      final gpayConfig = await PaymentConfiguration.fromAsset('assets/gpay.json');
      setState(() {
        _gpayConfig = gpayConfig;
      });
    } catch (e) {
      print("Google Pay config error: $e");
    }
  }

  Future<void> _fetchSubscriptionDetails() async {
    _subscriptionRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _plan = data['plan'] ?? "No Plan Available";
          _price = _parsePrice(data['price']);

        });
      } else {
        setState(() {
          _plan = "No Plan Found";
          _price = 0.0;
        });
      }
    });
  }

  double _parsePrice(dynamic priceValue) {
    if (priceValue == null || priceValue.toString().trim().isEmpty) {
      return 0.0;
    }
    String priceString = priceValue.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(priceString) ?? 0.0;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.code} - ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': (_price * 100).toInt(),
      'name': 'DABBAWALA',
      'description': 'Subscription Payment',
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
        amount: _price.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription Payment',
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColor.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plan: $_plan',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Price: ₹$_price',
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 10),
            if (_features.isNotEmpty)
              Column(
                children: _features
                    .map((feature) => Text(
                  "• $feature",
                  style: GoogleFonts.poppins(fontSize: 16),
                ))
                    .toList(),
              ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: openCheckout,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  'Pay with Razorpay',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_gpayConfig != null)
              GooglePayButton(
                paymentConfiguration: _gpayConfig!,
                paymentItems: _paymentItems,
                onPaymentResult: (result) {
                  print('Google Pay result: $result');
                },
                loadingIndicator: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
