import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/emergency_contact.dart';
import '../contacts/contact_list_screen.dart';
import '../emergency/live_map_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Dynamic colors based on theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      // 2. Use theme-provided background
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background glows (adjust opacity for dark mode if needed)
          Positioned(top: -100, right: -50, child: _buildGlow(Colors.red.withOpacity(isDark ? 0.05 : 0.08))),
          Positioned(bottom: 50, left: -100, child: _buildGlow(Colors.blue.withOpacity(isDark ? 0.05 : 0.06))),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  _buildHeader(textColor),
                  const SizedBox(height: 40),
                  Align(alignment: Alignment.centerLeft, child: Text("Emergency Assistance", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textColor))),
                  const SizedBox(height: 20),
                  _buildFloatingGrid(context, textColor),
                  
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Are you in emergency?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                          const SizedBox(height: 40),
                          // 3. Removed 'const' because this widget now depends on theme state
                          AnimatedSOSButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add this method inside your HomePage class
  Widget _buildGlow(Color color) {
    return Container(
      height: 400, 
      width: 400, 
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: color
      ),
    );
  }

  Widget _buildHeader(Color textColor) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.redAccent, width: 2)),
            child: const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person, size: 30, color: Colors.grey)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome,", style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
              Text("SARAH", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textColor)),
            ],
          ),
        ],
      );

  Widget _buildFloatingGrid(BuildContext context, Color textColor) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,
        children: [
          _buildFloatingItem(context, Icons.local_fire_department_rounded, "Fire", ContactCategory.fire, textColor),
          _buildFloatingItem(context, Icons.local_police_rounded, "Police", ContactCategory.police, textColor),
          _buildFloatingItem(context, Icons.groups_rounded, "Family", ContactCategory.family, textColor),
          _buildFloatingItem(context, Icons.car_crash_rounded, "Accident", ContactCategory.roadSafety, textColor),
          _buildFloatingItem(context, Icons.medical_services_rounded, "Medical", ContactCategory.medical, textColor),
          _buildFloatingItem(context, Icons.traffic_rounded, "Road", ContactCategory.roadSafety, textColor),
        ],
      );

  Widget _buildFloatingItem(BuildContext context, IconData icon, String label, ContactCategory category, Color textColor) => Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactListScreen(category: category))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.redAccent),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
            ],
          ),
        ),
      );
}

// DEFINED OUTSIDE OF HomePage CLASS
class AnimatedSOSButton extends StatefulWidget {
  const AnimatedSOSButton({super.key});
  @override
  State<AnimatedSOSButton> createState() => _AnimatedSOSButtonState();
}

class _AnimatedSOSButtonState extends State<AnimatedSOSButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapUp(_) {
    if (_controller.value >= 1.0) {
      setState(() => _isTriggered = true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveMapScreen())).then((_) {
        if (mounted) setState(() { _isTriggered = false; _controller.reset(); });
      });
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) { HapticFeedback.heavyImpact(); _controller.forward(); },
        onTapUp: _onTapUp,
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(height: 150, width: 150, child: CircularProgressIndicator(value: _controller.value, color: Colors.redAccent, strokeWidth: 8)),
              Container(
                height: 120, width: 120,
                decoration: BoxDecoration(shape: BoxShape.circle, color: _isTriggered ? Colors.orange : Colors.red),
                child: Center(child: Text(_isTriggered ? "SENT" : "SOS", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))),
              ),
            ],
          ),
        ),
      );
}