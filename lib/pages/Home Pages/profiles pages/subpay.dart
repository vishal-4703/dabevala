import 'package:flutter/material.dart';
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
  PaymentConfiguration? _gpayConfig;

  final DatabaseReference _subscriptionRef = FirebaseDatabase.instance
      .ref()
      .child('subscriptions')
      .child('GihS4gXKbJSXjkgs03rwLzYCCXo1'); // Updated User ID

  String _plan = "Loading...";
  double _price = 0.0;

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
      final gpayConfig =
      await PaymentConfiguration.fromAsset('assets/gpay.json');
      setState(() {
        _gpayConfig = gpayConfig;
      });
    } catch (e) {
      debugPrint("Google Pay config error: $e");
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
    String priceString =
    priceValue.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(priceString) ?? 0.0;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Payment Failed: ${response.code} - ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay Key
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
        amount: _price.toStringAsFixed(2),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Plan: $_plan',
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ₹${_price.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 16),

              SizedBox(height: 24),
              GestureDetector(
                onTap: openCheckout,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TColor.primary.withAlpha(128), // 50% opacity
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Successful via GPay')),
                    );
                  },
                  loadingIndicator: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
