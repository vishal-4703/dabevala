import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Address Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddressPage(),
    );
  }
}

// Address Model
class Address {
  String id;
  String title;
  String fullAddress;
  String type;
  bool isDefault;

  Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.type,
    this.isDefault = false,
  });

  // Convert Address object to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'type': type,
      'isDefault': isDefault,
    };
  }

  // Create Address object from Firebase JSON data
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      type: json['type'] ?? 'home',
      isDefault: json['isDefault'] ?? false,
    );
  }
}

// Address Page
class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Address> _addresses = [];
  bool _isLoading = true;
  final DatabaseReference _addressesRef = FirebaseDatabase.instance.ref('addresses');

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // Load addresses from Firebase
  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user ID (in a real app, this would come from authentication)
      String userId = 'current_user_id';
      DatabaseReference userAddressesRef = _addressesRef.child(userId);

      // Listen for data changes
      userAddressesRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data == null) {
          setState(() {
            _addresses.clear();
            _isLoading = false;
          });
          return;
        }

        List<Address> loadedAddresses = [];
        data.forEach((key, value) {
          final addressData = Map<String, dynamic>.from(value as Map);
          loadedAddresses.add(Address.fromJson(addressData));
        });

        setState(() {
          _addresses.clear();
          _addresses.addAll(loadedAddresses);
          _isLoading = false;
        });
      }, onError: (error) {
        print('Error loading addresses: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Error setting up address listener: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save address to Firebase
  Future<void> _saveAddressToFirebase(Address address) async {
    try {
      // Get user ID (in a real app, this would come from authentication)
      String userId = 'current_user_id';

      // If this is set as default, update all other addresses to not be default
      if (address.isDefault) {
        for (var addr in _addresses) {
          if (addr.id != address.id && addr.isDefault) {
            addr.isDefault = false;
            await _addressesRef.child(userId).child(addr.id).update(addr.toJson());
          }
        }
      }

      // Save or update the address
      await _addressesRef.child(userId).child(address.id).set(address.toJson());
    } catch (e) {
      print('Error saving address: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save address: $e')),
      );
    }
  }

  // Delete address from Firebase
  Future<void> _deleteAddressFromFirebase(String addressId) async {
    try {
      // Get user ID (in a real app, this would come from authentication)
      String userId = 'current_user_id';
      await _addressesRef.child(userId).child(addressId).remove();
    } catch (e) {
      print('Error deleting address: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'My Addresses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: _addresses.isEmpty
                  ? _buildEmptyState()
                  : _buildAddressList(),
            ),
            _buildAddAddressButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No addresses saved yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your delivery addresses to make ordering faster',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return _buildAddressCard(address);
      },
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                address.type == 'home'
                    ? Icons.home_outlined
                    : address.type == 'work'
                    ? Icons.work_outline
                    : Icons.place_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        onTap: () => _editAddress(address),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        onTap: () => _deleteAddress(address),
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : Colors.grey[700];

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _addNewAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text(
              'Add New Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewAddress() async {
    final result = await Navigator.of(context).push<Address?>(
      MaterialPageRoute(
        builder: (context) => const AddEditAddressPage(isEditing: false),
      ),
    );

    if (result != null) {
      await _saveAddressToFirebase(result);
    }
  }

  void _editAddress(Address address) async {
    final result = await Navigator.of(context).push<Address?>(
      MaterialPageRoute(
        builder: (context) => AddEditAddressPage(
          isEditing: true,
          address: address,
        ),
      ),
    );

    if (result != null) {
      await _saveAddressToFirebase(result);
    }
  }

  void _deleteAddress(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAddressFromFirebase(address.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Add/Edit Address Page
class AddEditAddressPage extends StatefulWidget {
  final bool isEditing;
  final Address? address;

  const AddEditAddressPage({
    Key? key,
    required this.isEditing,
    this.address,
  }) : super(key: key);

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  String _selectedType = 'home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.isEditing ? widget.address!.title : '',
    );
    _addressController = TextEditingController(
      text: widget.isEditing ? widget.address!.fullAddress : '',
    );

    if (widget.isEditing) {
      _selectedType = widget.address!.type;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Address' : 'Add New Address',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Address Details'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _titleController,
                        label: 'Address Title',
                        hint: 'E.g., Home, Work, etc.',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an address title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Full Address',
                        hint: 'Street, Building, City, Zip Code',
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Address Type'),
                      const SizedBox(height: 16),
                      _buildAddressTypeSelector(),
                      const SizedBox(height: 24),
                      _buildDefaultAddressSwitch(),
                    ],
                  ),
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildAddressTypeSelector() {
    return Row(
      children: [
        _buildAddressTypeOption(
          type: 'home',
          icon: Icons.home_outlined,
          label: 'Home',
        ),
        const SizedBox(width: 16),
        _buildAddressTypeOption(
          type: 'work',
          icon: Icons.work_outline,
          label: 'Work',
        ),
        const SizedBox(width: 16),
        _buildAddressTypeOption(
          type: 'other',
          icon: Icons.place_outlined,
          label: 'Other',
        ),
      ],
    );
  }

  Widget _buildAddressTypeOption({
    required String type,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            )
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[700],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAddressSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Set as default address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: _isDefault,
          onChanged: (value) {
            setState(() {
              _isDefault = value;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _saveAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          widget.isEditing ? 'Update Address' : 'Save Address',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.isEditing ? widget.address!.id : Uuid().v4(),  // Generate a unique ID for new addresses
        title: _titleController.text,
        fullAddress: _addressController.text,
        type: _selectedType,
        isDefault: _isDefault,
      );

      Navigator.pop(context, address);
    }
  }
}