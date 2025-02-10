import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final DatabaseReference _notificationsRef = FirebaseDatabase.instance.ref('notifications');
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  Set<String> selectedNotifications = {};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _addRandomNotifications();
  }

  void _loadNotifications() {
    _notificationsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          notifications = data.entries.map((e) {
            final value = e.value as Map<dynamic, dynamic>;
            return {
              'id': e.key,
              'title': value['title'] ?? 'No Title',
              'message': value['message'] ?? 'No Message',
              'timestamp': value['timestamp'] ?? DateTime.now().toString(),
              'read': value['read'] ?? false,
            };
          }).toList();
          notifications.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _addRandomNotifications() {
    List<Map<String, String>> sampleNotifications = [
      { 'title': 'Order Placed', 'message': 'Your order has been successfully placed!' },
      { 'title': 'Order Dispatched', 'message': 'Your order is on the way!' },
      { 'title': 'Order Delivered', 'message': 'Your order has been delivered!' }
    ];

    for (var notification in sampleNotifications) {
      String id = Random().nextInt(100000).toString();
      _notificationsRef.child(id).set({
        'title': notification['title'],
        'message': notification['message'],
        'timestamp': DateTime.now().toString(),
        'read': false,
      });
    }
  }

  void _markAsRead(String id) {
    _notificationsRef.child(id).update({'read': true});
  }

  void _deleteSelectedNotifications() {
    for (String id in selectedNotifications) {
      _notificationsRef.child(id).remove();
    }
    setState(() {
      selectedNotifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (selectedNotifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelectedNotifications,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/empty.json', width: 200, height: 200),
            Text('No Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isSelected = selectedNotifications.contains(notification['id']);
          return GestureDetector(
            onLongPress: () {
              setState(() {
                if (isSelected) {
                  selectedNotifications.remove(notification['id']);
                } else {
                  selectedNotifications.add(notification['id']);
                }
              });
            },
            child: Card(
              margin: EdgeInsets.all(8),
              elevation: 4,
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
              child: ListTile(
                leading: Icon(
                  notification['read'] ? Icons.notifications : Icons.notifications_active,
                  color: notification['read'] ? Colors.grey : Colors.blue,
                ),
                title: Text(notification['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notification['message']),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : Icon(Icons.arrow_forward, color: Colors.grey),
                onTap: () {
                  if (!notification['read']) {
                    _markAsRead(notification['id']);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
