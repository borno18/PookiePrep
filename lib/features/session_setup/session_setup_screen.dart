import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/mascot.dart';
import 'session_config.dart';
import 'topics.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({
    super.key,
    required this.onStart,
    this.initialTopicSlugs,
    this.initialMistakesOnly = false,
    this.initialCurrentOnly = false,
  });

  final void Function(SessionConfig config) onStart;
  final List<String>? initialTopicSlugs;
  final bool initialMistakesOnly;
  final bool initialCurrentOnly;

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  late bool _all;
  final Set<String> _selected = {};
  int _count = 20;
  int _minutes = SessionConfig.defaultMinutes(20);

  bool _onlyUnseen = false;
  late bool _includeMistakes;
  late bool _onlyCurrent;

  @override
  void initState() {
    super.initState();
    _includeMistakes = widget.initialMistakesOnly;
    _onlyCurrent = widget.initialCurrentOnly;

    if (widget.initialTopicSlugs != null &&
        widget.initialTopicSlugs!.isNotEmpty) {
      _all = false;
      _selected.addAll(widget.initialTopicSlugs!);
    } else {
      _all = true;
    }
  }

  void _toggleAll() => setState(() {
        _all = true;
        _selected.clear();
      });

  void _toggleTopic(String slug, bool on) => setState(() {
        if (on) {
          _selected.add(slug);
          _all = false;
        } else {
          _selected.remove(slug);
          if (_selected.isEmpty) _all = true;
        }
      });

  void _start() {
    widget.onStart(SessionConfig(
      topicSlugs: _all ? allTopicSlugs : _selected.toList(),
      questionCount: _count,
      minutes: _minutes,
      onlyUnseen: _onlyUnseen,
      includeMistakes: _includeMistakes,
      onlyCurrent: _onlyCurrent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final secondsPerQuestion = (_minutes * 60 / _count).round();
    return PookieScaffold(
      appBar: AppBar(title: const Text('নিজের মতো অনুশীলন')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: _start,
                    label: const Text('অনুশীলন শুরু করো'),
                  )),
            )),
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('তোমার প্রস্তুতি,\nতোমার গতি।',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    const Text('বিষয় আর সময় বেছে নাও। পুকি তোমার সঙ্গেই আছে।',
                        style: TextStyle(color: PookieColors.muted)),
                  ])),
              const SizedBox(width: 8),
              const PookieMascot(pose: MascotPose.thinking, size: 80),
            ]),
            const SizedBox(height: 24),
            _SetupSection(
                title: 'বিষয় বেছে নাও',
                subtitle: 'সব বিষয় একসঙ্গে, অথবা আজকের পছন্দের বিষয়।',
                children: [
                  FilterChip(
                      label: const Text('সব বিষয়'),
                      selected: _all,
                      onSelected: (_) => _toggleAll()),
                  for (final group in topicGroups) ...[
                    Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(group.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: PookieColors.primaryDeep))),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final topic in group.topics)
                        FilterChip(
                            label: Text(topic.label),
                            selected: _selected.contains(topic.slug),
                            onSelected: (on) => _toggleTopic(topic.slug, on)),
                    ]),
                  ],
                ]),
            const SizedBox(height: 24),
            _SetupSection(
                title: 'প্রশ্ন ও সময়',
                subtitle: 'ছোট সেশনও প্রস্তুতিতে এগিয়ে দেয়।',
                children: [
                  const SizedBox(height: 4),
                  SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<int>(
                        showSelectedIcon: false,
                        segments: [
                          for (final n in SessionConfig.countOptions)
                            ButtonSegment(
                                value: n, label: Text('${toBn(n)} টি'))
                        ],
                        selected: {_count},
                        onSelectionChanged: (s) => setState(() {
                          _count = s.first;
                          _minutes = SessionConfig.defaultMinutes(_count);
                        }),
                      )),
                  const SizedBox(height: 20),
                  Row(children: [
                    const Icon(Icons.timer_outlined,
                        color: PookieColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text('সময়: ${toBn(_minutes)} মিনিট',
                            style: Theme.of(context).textTheme.titleMedium))
                  ]),
                  Slider(
                      min: SessionConfig.minMinutes.toDouble(),
                      max: SessionConfig.maxMinutes.toDouble(),
                      divisions:
                          SessionConfig.maxMinutes - SessionConfig.minMinutes,
                      value: _minutes.toDouble(),
                      label: '${toBn(_minutes)} মিনিট',
                      onChanged: (v) => setState(() => _minutes = v.round())),
                  Text(
                      'প্রতি প্রশ্নে গড়ে প্রায় ${toBn(secondsPerQuestion)} সেকেন্ড সময় পাবে',
                      style: const TextStyle(color: PookieColors.muted)),
                ]),
            const SizedBox(height: 24),
            _SetupSection(title: 'বিশেষ পছন্দ (ফিল্টার)', children: [
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('শুধু নতুন প্রশ্ন'),
                  subtitle: const Text('যে প্রশ্নগুলো আগে অনুশীলন করোনি'),
                  value: _onlyUnseen,
                  onChanged: (v) => setState(() => _onlyUnseen = v)),
              const Divider(),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('আমার ভুলগুলো অগ্রাধিকার দাও'),
                  subtitle:
                      const Text('পূর্বে ভুল হওয়া প্রশ্ন অন্তর্ভুক্ত করবে'),
                  value: _includeMistakes,
                  onChanged: (v) => setState(() => _includeMistakes = v)),
              const Divider(),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('শুধু সাম্প্রতিক ঘটনা'),
                  subtitle: const Text('জাতীয় ও আন্তর্জাতিক সমসাময়িক প্রশ্ন'),
                  value: _onlyCurrent,
                  onChanged: (v) => setState(() => _onlyCurrent = v)),
            ]),
            const SizedBox(height: 24),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: PookieColors.blush,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  const Icon(Icons.checklist_rounded,
                      color: PookieColors.primaryDeep),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(
                          '${toBn(_count)}টি প্রশ্ন · ${toBn(_minutes)} মিনিট\n${_all ? 'সব বিষয়' : '${toBn(_selected.length)}টি বিষয়'} নিয়ে আজকের অনুশীলন',
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                ])),
          ]),
    );
  }
}

class _SetupSection extends StatelessWidget {
  const _SetupSection(
      {required this.title, required this.children, this.subtitle});
  final String title;
  final String? subtitle;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: PookieColors.surface,
            borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(color: PookieColors.muted))
          ],
          const SizedBox(height: 12),
          ...children,
        ]),
      );
}
