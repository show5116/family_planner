import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.legal_termsOfService)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legal_termsOfService,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.legal_termsLastUpdated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            _LegalSection(title: l10n.legal_terms_section1_title, body: l10n.legal_terms_section1_body),
            _LegalSection(title: l10n.legal_terms_section2_title, body: l10n.legal_terms_section2_body),
            _LegalSection(title: l10n.legal_terms_section3_title, body: l10n.legal_terms_section3_body),
            _LegalSection(title: l10n.legal_terms_section4_title, body: l10n.legal_terms_section4_body),
            _LegalSection(title: l10n.legal_terms_section5_title, body: l10n.legal_terms_section5_body),
            _LegalSection(title: l10n.legal_terms_section6_title, body: l10n.legal_terms_section6_body),
            _LegalSection(title: l10n.legal_terms_section7_title, body: l10n.legal_terms_section7_body),
            const SizedBox(height: AppSizes.spaceXL),
            Text(
              l10n.legal_termsContact,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
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
