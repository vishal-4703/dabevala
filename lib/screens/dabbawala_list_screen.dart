import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/dabbawala.dart';
import '../services/dabbawala_service.dart';
import '../widgets/dabbawala_card.dart';
import 'order_details_screen.dart';

class DabbawalaListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  DabbawalaListScreen({required this.cartItems, required this.totalPrice});

  @override
  _DabbawalaListScreenState createState() => _DabbawalaListScreenState();
}

class _DabbawalaListScreenState extends State<DabbawalaListScreen> {
  final DabbawalaService dabbawalaService = DabbawalaService();
  List<Dabbawala> allDabbawalas = [];
  List<Dabbawala> filteredDabbawalas = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Dabbawala> dabbawalas = await dabbawalaService.fetchDabbawalas();
      print("Fetched Dabbawalas: ${dabbawalas.length}"); // Debug log
      setState(() {
        allDabbawalas = dabbawalas;
        filteredDabbawalas = dabbawalas;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching data: $error"); // Debug log
      setState(() {
        hasError = true;
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  void filterSearch(String query) {
    List<Dabbawala> results = allDabbawalas
        .where((dabbawala) =>
    dabbawala.name.toLowerCase().contains(query.toLowerCase()) ||
        dabbawala.contact.contains(query))
        .toList();

    setState(() {
      filteredDabbawalas = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Stack(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'Dabbawala List',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        color: Colors.red,
        child: isLoading
            ? Center(
          child: Lottie.asset(
            'assets/animations/loading.json', // Add a Lottie loading animation
            width: 150,
            height: 150,
          ),
        )
            : hasError
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/error.json',
                    width: 200, height: 200), // Error animation
                SizedBox(height: 10),
                Text(
                  'Oops! Something went wrong.',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text("Retry",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          ),
        )
            : Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => filterSearch(value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.red),
                    hintText: "Search Dabbawala...",
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // Dabbawala List
            Expanded(
              child: filteredDabbawalas.isNotEmpty
                  ? ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredDabbawalas.length,
                itemBuilder: (context, index) {
                  final dabbawala = filteredDabbawalas[index];
                  print(
                      "Displaying Dabbawala: ${dabbawala.name}"); // Debug log
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsScreen(
                                dabbawala: dabbawala,
                                cartItems: widget.cartItems, // Pass cartItems
                                totalPrice: widget.totalPrice, // Pass totalPrice
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: DabbawalaCard(dabbawala: dabbawala),
                    ),
                  );
                },
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/no_data.json',
                      width: 150,
                      height: 150,
                    ), // No Data Animation
                    SizedBox(height: 10),
                    Text(
                      "No Dabbawalas found.",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}