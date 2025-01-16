import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          // List of users
          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var data = user.data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(data['name']![0]),
                ),
                title: Text(data['name'] ?? 'N/A'),
                subtitle: Text(data['email'] ?? 'N/A'),
                trailing: DropdownButton<String>(
                  value: data['role'] ?? 'user',
                  items: ['admin', 'user']
                      .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  ))
                      .toList(),
                  onChanged: (newRole) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.id)
                        .update({'role': newRole});
                  },
                ),
                onLongPress: () {
                  // Confirm delete user
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete User'),
                        content: Text('Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
