import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_preferences_provider.dart';
import '../screens/emergency/live_map_screen.dart';

class AnimatedSOSButton extends StatefulWidget {
  const AnimatedSOSButton({super.key});

  @override
  State<AnimatedSOSButton> createState() => _AnimatedSOSButtonState();
}

class _AnimatedSOSButtonState extends State<AnimatedSOSButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapUp(TapUpDetails _) {
    if (_controller.value >= 1.0) {
      setState(() => _isTriggered = true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveMapScreen()),
      ).then((_) {
        if (mounted) {
          setState(() {
            _isTriggered = false;
            _controller.reset();
          });
        }
      });
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AppPreferencesProvider>();

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.heavyImpact();
        _controller.forward();
      },
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                value: _controller.value,
                color: Colors.redAccent,
                strokeWidth: 8,
              ),
            ),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isTriggered ? Colors.orange : Colors.red,
              ),
              child: Center(
                child: Text(
                  _isTriggered ? prefs.translate('SENT', 'បានផ្ញើ') : 'SOS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
