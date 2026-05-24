import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.legal_privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legal_privacyPolicy,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.legal_privacyLastUpdated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            _LegalSection(title: l10n.legal_privacy_section1_title, body: l10n.legal_privacy_section1_body),
            _LegalSection(title: l10n.legal_privacy_section2_title, body: l10n.legal_privacy_section2_body),
            _LegalSection(title: l10n.legal_privacy_section3_title, body: l10n.legal_privacy_section3_body),
            _LegalSection(title: l10n.legal_privacy_section4_title, body: l10n.legal_privacy_section4_body),
            _LegalSection(title: l10n.legal_privacy_section5_title, body: l10n.legal_privacy_section5_body),
            _LegalSection(title: l10n.legal_privacy_section6_title, body: l10n.legal_privacy_section6_body),
            _LegalSection(title: l10n.legal_privacy_section7_title, body: l10n.legal_privacy_section7_body),
            const SizedBox(height: AppSizes.spaceXL),
            _ContactText(contact: l10n.legal_termsContact),
            const SizedBox(height: AppSizes.spaceXXL),
          ],
        ),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

class _ContactText extends StatelessWidget {
  const _ContactText({required this.contact});

  final String contact;

  static const _email = 'hmn.corp.dev@gmail.com';

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );
    final emailStyle = style?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    final parts = contact.split(_email);
    if (parts.length != 2) {
      return Text(contact, style: style);
    }

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse('mailto:$_email');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  await Clipboard.setData(const ClipboardData(text: _email));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이메일 주소가 복사되었습니다.')),
                    );
                  }
                }
              },
              child: Text(_email, style: emailStyle),
            ),
          ),
          TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
