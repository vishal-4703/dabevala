import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/dabbawala.dart';

class DabbawalaCard extends StatefulWidget {
  final Dabbawala dabbawala;
  final VoidCallback onTap;

  DabbawalaCard({required this.dabbawala, required this.onTap});

  @override
  _DabbawalaCardState createState() => _DabbawalaCardState();
}

class _DabbawalaCardState extends State<DabbawalaCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      child: GestureDetector(
        onTapDown: (_) => _animationController.reverse(),
        onTapUp: (_) => _animationController.forward(),
        onTapCancel: () => _animationController.forward(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            margin: EdgeInsets.all(12),
            elevation: 12,
            shadowColor: Colors.orange.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade100, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                leading: Pulse(
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange.shade200,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                    onBackgroundImageError: (_, __) {
                      setState(() {}); // Reload if image fails
                    },
                    child: Icon(Icons.person, color: Colors.white, size: 28), // Default icon
                  ),
                ),
                title: Text(
                  widget.dabbawala.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                subtitle: Text(
                  "Orders: ${widget.dabbawala.orderCount}",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                ),
                trailing: FadeInRight(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
