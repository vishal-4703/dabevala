import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
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
      {'title': 'Order Placed', 'message': 'Your order has been successfully placed!'},
      {'title': 'Order Dispatched', 'message': 'Your order is on the way!'},
      {'title': 'Order Delivered', 'message': 'Your order has been delivered!'}
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.indigo]),
          ),
        ),
        actions: [
          if (selectedNotifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
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
          return Dismissible(
            key: Key(notification['id']),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            onDismissed: (direction) {
              _notificationsRef.child(notification['id']).remove();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: Hero(
                  tag: notification['id'],
                  child: CircleAvatar(
                    backgroundColor: notification['read'] ? Colors.grey[300] : Colors.blueAccent,
                    child: Icon(
                      notification['read'] ? Icons.notifications : Icons.notifications_active,
                      color: notification['read'] ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
                title: Text(notification['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notification['message']),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  if (!notification['read']) {
                    _markAsRead(notification['id']);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailPage(notification: notification),
                    ),
                  );
                },
                onLongPress: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    if (isSelected) {
                      selectedNotifications.remove(notification['id']);
                    } else {
                      selectedNotifications.add(notification['id']);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// 📌 Notification Detail Page
class NotificationDetailPage extends StatelessWidget {
  final Map<String, dynamic> notification;

  NotificationDetailPage({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(notification['title']),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.indigo]),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: notification['id'],
                child: Icon(
                  Icons.notifications_active,
                  size: 80,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              notification['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 10),
            Text(
              notification['message'],
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  notification['timestamp'].toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Notifications"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
