import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CupertinoListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 4.0),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            trailing,
          ],
        ),
      ),
    );
  }
}
