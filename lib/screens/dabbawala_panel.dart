import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class DabbawalaPanelPage extends StatefulWidget {
  @override
  _DabbawalaPanelPageState createState() => _DabbawalaPanelPageState();
}

class _DabbawalaPanelPageState extends State<DabbawalaPanelPage>
    with SingleTickerProviderStateMixin {
  final DatabaseReference _dabbawalaRef = FirebaseDatabase.instance.ref().child('dabbawalas');
  final DatabaseReference _orderRef = FirebaseDatabase.instance.ref().child('orders');

  List<Map<String, dynamic>> dabbawalas = [];
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String searchQuery = '';
  String statusFilter = 'All';
  late TabController _tabController;

  // Helper method for opacity conversion
  Color withCustomOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  // All possible status values
  final List<String> allStatusOptions = [
    'Pending',
    'Assigned',
    'In Transit',
    'Delivered',
    'Cancelled',
  ];

  // Status colors
  final Map<String, Color> statusColors = {
    'Pending': Colors.amber,
    'Assigned': Colors.purple,
    'In Transit': Colors.blue,
    'Delivered': Colors.green,
    'Cancelled': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch Dabbawalas
      final dabbawalaSnapshot = await _dabbawalaRef.get();
      if (dabbawalaSnapshot.exists && dabbawalaSnapshot.value is Map) {
        final data = Map<String, dynamic>.from(dabbawalaSnapshot.value as Map);
        setState(() {
          dabbawalas = data.entries.map((entry) {
            final dabbawalaData = Map<String, dynamic>.from(entry.value);
            return {
              'key': entry.key,
              'name': dabbawalaData['name'] ?? ' Name',
              'contact': dabbawalaData['contact'] ?? 'N/A',
              'orderCount': dabbawalaData['orderCount'] ?? 0,
              'area': dabbawalaData['area'] ?? 'Unknown Area',
              'rating': dabbawalaData['rating'] ?? 4.0,
              'isActive': dabbawalaData['isActive'] ?? true,
              'profileImage': dabbawalaData['profileImage'],
            };
          }).toList();
        });
      }

      // Fetch Orders
      final orderSnapshot = await _orderRef.get();
      if (orderSnapshot.exists && orderSnapshot.value is Map) {
        final data = Map<String, dynamic>.from(orderSnapshot.value as Map);
        setState(() {
          orders = data.entries.map((entry) {
            final orderData = Map<String, dynamic>.from(entry.value);
            return {
              'key': entry.key,
              'orderId': orderData['orderId'] ?? 'N/A',
              'dabbawalaId': orderData['dabbawalaId'] ?? 'N/A',
              'status': orderData['status'] ?? 'Pending',
              'totalPrice': orderData['totalPrice'] ?? 0,
              'timestamp': orderData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
              'customerName': orderData['customerName'] ?? ' Customer',
              'items': orderData['items'] ?? 1,
              'address': orderData['address'] ?? 'N/A',
              'paymentMethod': orderData['paymentMethod'] ?? 'Online',
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateOrderStatus(String orderKey, String newStatus) async {
    try {
      await _orderRef.child(orderKey).update({'status': newStatus});
      setState(() {
        final orderIndex = orders.indexWhere((order) => order['key'] == orderKey);
        if (orderIndex != -1) {
          orders[orderIndex]['status'] = newStatus;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $newStatus'),
          backgroundColor: withCustomOpacity(statusColors[newStatus] ?? Colors.black87, 0.8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      print("Error updating order status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get filteredOrders {
    return orders.where((order) {
      final matchesSearch = order['orderId'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          order['customerName'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == 'All' || order['status'] == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.teal.shade700,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Dabbawala Panel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black.withAlpha((0.3 * 255).round()),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.teal.shade700,
                            Colors.teal.shade700,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -50,
                      top: -20,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withAlpha((0.1 * 255).round()),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withAlpha((0.1 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.teal.shade700,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                "Loading data...",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.deepOrange,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: [
                  Tab(text: "Orders"),
                  Tab(text: "Dabbawalas"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.05 * 255).round()),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _showFilterDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(Icons.filter_list, color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_tabController.index == 0)
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip('All'),
                    ...allStatusOptions.map((status) => _buildFilterChip(status)),
                  ],
                ),
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersTab(),
                  _buildDabbawalasTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String status) {
    final isSelected = statusFilter == status;
    final color = status == 'All' ? Colors.grey.shade700 : (statusColors[status] ?? Colors.grey);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(status),
        selected: isSelected,
        checkmarkColor: Colors.white,
        selectedColor: color,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey.shade100,
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Colors.transparent : color.withAlpha((0.3 * 255).round()),
            width: 1,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            statusFilter = status;
          });
        },
      ),
    );
  }

  Widget _buildOrdersTab() {
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            SizedBox(height: 16),
            Text(
              "No orders found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              statusFilter != 'All' ? "Try changing your filter" : "Add new orders to get started",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        final dabbawala = dabbawalas.firstWhere(
              (d) => d['key'] == order['dabbawalaId'],
          orElse: () => {'name': 'Dabbawala'},
        );

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: Colors.black.withAlpha((0.1 * 255).round()),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withAlpha((0.1 * 255).round()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.receipt_long_outlined,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              order['orderId'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusBadge(order['status']),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(order['timestamp']),
                        ),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 8),
                    _buildInfoRow(Icons.person_outline, order['customerName']),
                    SizedBox(height: 12),
                    _buildInfoRow(Icons.shopping_bag_outlined, "${order['items']} items"),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.delivery_dining_outlined,
                      "Dabbawala: ${dabbawala['name']}",
                      trailing: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withAlpha((0.1 * 255).round()),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            dabbawala['name'].toString().substring(0, 1),
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      order['address'],
                      maxLines: 2,
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.payment_outlined,
                      "Payment: ${order['paymentMethod']}",
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "₹${order['totalPrice']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Status:",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: DropdownButton<String>(
                        value: allStatusOptions.contains(order['status']) ? order['status'] : 'Pending',
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down,
                            color: statusColors[order['status']] ?? Colors.grey),
                        style: TextStyle(
                          color: statusColors[order['status']] ?? Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        items: allStatusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: statusColors[value] ?? Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            _updateOrderStatus(order['key'], newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      label: "View Details",
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.print_outlined,
                      label: "Print",
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.phone_outlined,
                      label: "Call",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade700),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDabbawalasTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: dabbawalas.length,
      itemBuilder: (context, index) {
        final dabbawala = dabbawalas[index];
        final isActive = dabbawala['isActive'] ?? true;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: Colors.black.withAlpha((0.1 * 255).round()),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepOrange.shade300,
                          Colors.deepOrange.shade600,
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.deepOrange.withAlpha((0.1 * 255).round()),
                          backgroundImage: dabbawala['profileImage'] != null
                              ? NetworkImage(dabbawala['profileImage'])
                              : null,
                          child: dabbawala['profileImage'] == null
                              ? Text(
                            dabbawala['name'].toString().substring(0, 1),
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dabbawala['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          dabbawala['area'] ?? ' Area',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDabbawalaInfoRow("Contact:", dabbawala['contact']),
                        SizedBox(height: 8),
                        _buildDabbawalaInfoRow(
                          "Orders:",
                          dabbawala['orderCount'].toString(),
                          isHighlighted: true,
                        ),
                        SizedBox(height: 8),
                        _buildDabbawalaInfoRow(
                          "Rating:",
                          "",
                          trailing: Row(
                            children: [
                              Text(
                                (dabbawala['rating'] ?? 4.0).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4),
                              _buildRatingStars(dabbawala['rating'] ?? 4.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Details"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepOrange,
                            side: BorderSide(color: Colors.deepOrange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            _showDabbawalaOptions(dabbawala);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isActive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((0.7 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Inactive",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = statusColors[status] ?? Colors.grey;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha((0.3 * 255).round()), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Widget? trailing, int maxLines = 1}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 14,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildDabbawalaInfoRow(String label, String value, {Widget? trailing, bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing ?? (isHighlighted
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrange.shade200),
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepOrange.withAlpha((0.05 * 255).round()),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        )
            : Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        )),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating ? Icons.star_half : Icons.star_border),
          color: Colors.amber,
          size: 14,
        );
      }),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Filter Orders"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status:"),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: statusFilter == 'All',
                  onSelected: (selected) {
                    Navigator.pop(context);
                    setState(() {
                      statusFilter = 'All';
                    });
                  },
                ),
                ...allStatusOptions.map((status) => FilterChip(
                  label: Text(status),
                  selected: statusFilter == status,
                  onSelected: (selected) {
                    Navigator.pop(context);
                    setState(() {
                      statusFilter = status;
                    });
                  },
                )),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showDabbawalaOptions(Map<String, dynamic> dabbawala) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blue),
            title: Text("Edit Profile"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined, color: Colors.deepOrange),
            title: Text("View Orders"),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _tabController.animateTo(0);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.message_outlined, color: Colors.green),
            title: Text("Send Message"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              dabbawala['isActive'] == true ? Icons.block_outlined : Icons.check_circle_outline,
              color: dabbawala['isActive'] == true ? Colors.red : Colors.green,
            ),
            title: Text(dabbawala['isActive'] == true ? "Deactivate Account" : "Activate Account"),
            onTap: () {
              Navigator.pop(context);
              _toggleDabbawalaStatus(dabbawala);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _toggleDabbawalaStatus(Map<String, dynamic> dabbawala) async {
    try {
      final newStatus = !(dabbawala['isActive'] ?? true);
      await _dabbawalaRef.child(dabbawala['key']).update({'isActive': newStatus});

      setState(() {
        final index = dabbawalas.indexWhere((d) => d['key'] == dabbawala['key']);
        if (index != -1) {
          dabbawalas[index]['isActive'] = newStatus;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dabbawala ${newStatus ? 'activated' : 'deactivated'} successfully'),
          backgroundColor: newStatus ? Colors.green : Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Error updating dabbawala status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update dabbawala status: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}