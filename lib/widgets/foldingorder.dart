import 'package:flutter/material.dart';

class FoldingOrder extends StatefulWidget {
  final Widget header; // Top: Order ID + Status
  final Widget content; // Middle: Order Items
  final Widget footer; // Bottom: Date, Total, Reorder button

  const FoldingOrder({
    super.key,
    required this.header,
    required this.content,
    required this.footer,
  });

  @override
  State<FoldingOrder> createState() => _FoldingOrderState();
}

class _FoldingOrderState extends State<FoldingOrder>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _foldAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _foldAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section (always visible)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: widget.header,
            ),

            // Animated fold (middle section)
            SizeTransition(
              sizeFactor: _foldAnim,
              axisAlignment: -1.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: widget.content,
              ),
            ),

            // Divider (only visible when expanded)
            SizeTransition(
              sizeFactor: _foldAnim,
              axisAlignment: -1.0,
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: Colors.grey.shade300,
              ),
            ),

            // Footer (only visible when expanded)
            SizeTransition(
              sizeFactor: _foldAnim,
              axisAlignment: -1.0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: widget.footer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
