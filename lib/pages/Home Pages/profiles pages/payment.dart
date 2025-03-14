import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pay/pay.dart';
import 'package:flutter/services.dart';

class TColor {
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFFFFFFF);
  static const Color textfield = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF0F954D);
}

class payment extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const payment({Key? key, required this.cartItems, required this.totalPrice}) : super(key: key);

  @override
  State<payment> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<payment> {
  late Razorpay _razorpay;
  static const platform = MethodChannel('com.example.payment/phonepe');
  PaymentConfiguration? _gpayConfig;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadGooglePayConfiguration();
  }

  Future<void> _loadGooglePayConfiguration() async {
    final gpayConfig = await PaymentConfiguration.fromAsset('gpay.json');
    setState(() {
      _gpayConfig = gpayConfig;
    });
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
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay API key
      'amount': (widget.totalPrice * 100).toInt(), // Total amount in paise
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
        amount: widget.totalPrice.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: TColor.primary,
      ),
      body: Column(
        children: [
          // Display Cart Items
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  leading: Image.asset(item['image']), // Display image
                  title: Text(item['name']),
                  subtitle: Text('Day: ${item['day']} - Price: \$${item['price']}'),
                );
              },
            ),
          ),
          // Display Total Price
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '\$${widget.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Payment Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: GestureDetector(
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
        ],
      ),
    );
  }
}