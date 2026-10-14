import 'package:flutter/material.dart';
import 'mascot.dart';
import 'theme.dart';

/// A compact companion greeting. Content remains readable at large text scales.
class StudyIntro extends StatelessWidget {
  const StudyIntro(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      this.color = PookieColors.primaryDeep,
      this.pose});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final MascotPose? pose;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color == PookieColors.ok
                ? PookieColors.mint
                : color == PookieColors.accent
                    ? PookieColors.lilac
                    : PookieColors.pinkWash,
            borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child:
                    Text(title, style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(width: 12),
            if (pose != null)
              LiveMascot(pose: pose!, size: 64)
            else
              Icon(icon, color: color, size: 28),
          ]),
          const SizedBox(height: 10),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ]),
      );
}

class StudySection extends StatelessWidget {
  const StudySection(
      {super.key, required this.title, required this.child, this.subtitle});
  final String title;
  final String? subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: const TextStyle(color: PookieColors.muted))
        ],
        const SizedBox(height: 12),
        child,
      ]);
}

class StudyEmptyState extends StatelessWidget {
  const StudyEmptyState(
      {super.key,
      required this.title,
      required this.description,
      this.pose = MascotPose.greeting,
      this.action});
  final String title;
  final String description;
  final MascotPose pose;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          LiveMascot(pose: pose, size: 120),
          const SizedBox(height: 20),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PookieColors.muted, height: 1.6)),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ]),
      );
}
