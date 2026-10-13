import 'package:flutter/material.dart';

import '../../core/mascot.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/study_widgets.dart';
import '../../data/repository/pookie_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.repository});
  final PookieRepository repository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final settings = repository.settings;
        final text = Theme.of(context).textTheme;
        return PookieScaffold(
          appBar: AppBar(title: const Text('সেটিংস')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              const StudyIntro(
                title: 'তোমার মতো করে পড়ো',
                description:
                    'ছোট কিছু পছন্দ, যাতে প্রতিদিনের চর্চা আরও আপন লাগে।',
                icon: Icons.tune_rounded,
                pose: MascotPose.greeting,
              ),
              const SizedBox(height: 28),
              StudySection(
                title: 'পড়ার পছন্দ',
                child: Material(
                  color: PookieColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(children: [
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      title: Text('বাংলা সংখ্যা ব্যবহার করো',
                          style: text.titleMedium),
                      subtitle: Text(settings.useBnDigits
                          ? 'বর্তমানে: ১২৩৪৫'
                          : 'বর্তমানে: 12345'),
                      value: settings.useBnDigits,
                      onChanged: (val) => repository
                          .updateSettings(settings.copyWith(useBnDigits: val)),
                    ),
                    const Divider(height: 1, indent: 18, endIndent: 18),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      title: Text('দৈনিক পড়ার তাগিদ (অনুস্মারক)',
                          style: text.titleMedium),
                      subtitle: const Text(
                          'অনুস্মারকের পছন্দ সংরক্ষণ করো। এই সংস্করণে ফোনে বিজ্ঞপ্তি পাঠানো হয় না।'),
                      value: settings.reminderEnabled,
                      onChanged: (val) {
                        repository.updateSettings(
                            settings.copyWith(reminderEnabled: val));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(val
                                  ? 'অনুস্মারকের পছন্দ সংরক্ষিত হয়েছে'
                                  : 'অনুস্মারকের পছন্দ বন্ধ করা হয়েছে')),
                        );
                      },
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 28),
              StudySection(
                title: 'পরীক্ষার নিয়ম',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: PookieColors.apricot,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('নেগেটিভ মার্কিং',
                            style: text.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(
                            'সঠিক উত্তরে +১, প্রতি ভুলে −০.২৫। প্রশ্ন বাদ দিলে কোনো নম্বর কাটা যায় না।',
                            style: text.bodyLarge),
                        const SizedBox(height: 8),
                        Text(
                            'মেডিকেল ভর্তি পরীক্ষার মান অনুযায়ী কুইজের স্কোর হিসাব করা হয়।',
                            style: text.bodyMedium),
                      ]),
                ),
              ),
              const SizedBox(height: 28),
              const StudySection(
                title: 'সিলেবাস ও তথ্য',
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SyllabusGroup(
                        title: 'বাংলাদেশ বিষয়াবলী (৬টি বিষয়)',
                        description:
                            'ইতিহাস, মুক্তিযুদ্ধ ও স্বাধীনতা, ভূগোল ও পরিবেশ, অর্থনীতি, সংবিধান, সংস্কৃতি ও ক্রীড়া',
                        icon: Icons.location_on_outlined,
                        color: PookieColors.mint,
                      ),
                      SizedBox(height: 16),
                      _SyllabusGroup(
                        title: 'আন্তর্জাতিক বিষয়াবলী (৪টি বিষয়)',
                        description:
                            'বিশ্ব ভূগোল, আন্তর্জাতিক সংস্থা, চুক্তি ও সম্মেলন, নোবেল ও বিশ্বনেতা',
                        icon: Icons.public_rounded,
                        color: PookieColors.lilac,
                      ),
                      SizedBox(height: 16),
                      _SyllabusGroup(
                        title: 'সাম্প্রতিক সাধারণ জ্ঞান (২টি বিষয়)',
                        description:
                            'সাম্প্রতিক জাতীয় ও সাম্প্রতিক আন্তর্জাতিক ঘটনাপঞ্জী',
                        icon: Icons.newspaper_rounded,
                        color: PookieColors.apricot,
                      ),
                    ]),
              ),
              const SizedBox(height: 32),
              const Divider(height: 1),
              const SizedBox(height: 24),
              Text('পুকি প্রেপ', style: text.titleLarge),
              const SizedBox(height: 6),
              Text('মেডিকেল ভর্তি পরীক্ষার সাধারণ জ্ঞান সহায়ক · সংস্করণ ০.১',
                  style: text.bodyMedium?.copyWith(color: PookieColors.muted)),
              const SizedBox(height: 12),
              Text(
                  'ভালোবাসার সাথে পড়াশোনা সহজ ও আনন্দময় করে তোলাই পুকির লক্ষ্য। তোমার চর্চায় পুকি পাশে আছে।',
                  style: text.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}

class _SyllabusGroup extends StatelessWidget {
  const _SyllabusGroup(
      {required this.title,
      required this.description,
      required this.icon,
      required this.color});
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: PookieColors.ink, size: 22),
      ),
      const SizedBox(width: 12),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
      ])),
    ]);
  }
}
