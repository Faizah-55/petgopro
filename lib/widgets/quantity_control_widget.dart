import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

//  عداد للكمية 


class QuantityControlWidget extends StatefulWidget {
  final int initialCount;
  final Function(int) onCountChanged;

  const QuantityControlWidget({
    Key? key,
    this.initialCount = 0,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  State<QuantityControlWidget> createState() => _QuantityControlWidgetState();
}

class _QuantityControlWidgetState extends State<QuantityControlWidget> {
  late int count;

  @override
void didUpdateWidget(covariant QuantityControlWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.initialCount != widget.initialCount) {
    setState(() {
      count = widget.initialCount;
    });
  }
}

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  void _increment() {
    setState(() {
      count++;
    });
    widget.onCountChanged(count);
  }

  void _decrement() {
    setState(() {
      if (count > 1) {
        count--;
      } else {
        count = 0;
      }
    });
    widget.onCountChanged(count);
  }

  void _reset() {
    setState(() {
      count = 0;
    });
    widget.onCountChanged(count);
  }

  @override
  Widget build(BuildContext context) {
    final bool isInitial = count == 0;

    // ألوان وحجم حسب الحالة
    final Color borderColor = AppTheme.borderColor;
    final Color containerColor = isInitial ? Colors.white : AppTheme.primaryColor;
    final Color iconActiveColor = AppTheme.yellowColor;
    final Color iconColor = isInitial ? AppTheme.primaryColor: iconActiveColor;
    final double width = isInitial ? 32 : 68.86;
    final double height = 26;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isInitial
          ? InkWell(
              onTap: _increment,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: iconColor,
                  size: 15,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _increment,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: iconActiveColor,
                      size: 15,
                    ),
                  ),
                ),

                Text(
                  '$count',
                  style: TextStyle(
                    color: AppTheme.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),

                InkWell(
                  onTap: count == 1 ? _reset : _decrement,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    child: Icon(
                      count == 1 ? Icons.delete : Icons.remove,
                      color: iconActiveColor,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
