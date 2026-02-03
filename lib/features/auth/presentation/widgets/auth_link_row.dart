import 'package:flutter/material.dart';

/// 인증 화면용 링크 행 위젯
class AuthLinkRow extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const AuthLinkRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            animationDuration: Duration.zero,
          ),
          onPressed: onPressed,
          child: Text(linkText),
        ),
      ],
    );
  }
}
