import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'bn.dart';
import 'theme.dart';

enum MascotPose {
  greeting,
  thinking,
  cheering,
  sleepy,
  encourage,
  // Score-based result poses
  dancing,    // 100%
  superHappy, // >=80%
  happy,      // >=60%
  crying,     // <50%
  fainted,    // <30%
}

/// Chooses a mascot pose based on a 0–100 accuracy percentage.
MascotPose poseForScore(int accuracyPercent) {
  if (accuracyPercent == 100) return MascotPose.dancing;
  if (accuracyPercent >= 80) return MascotPose.superHappy;
  if (accuracyPercent >= 60) return MascotPose.happy;
  if (accuracyPercent >= 30) return MascotPose.crying;
  return MascotPose.fainted;
}

/// A live mascot that continuously animates with pose-specific motions,
/// and smoothly cross-fades to a new pose when [pose] changes.
/// Perfect for ambient background mascots throughout the app.
class LiveMascot extends StatefulWidget {
  const LiveMascot({
    super.key,
    required this.pose,
    this.size = 100,
    this.interactive = true,
    this.speechBubble,
  });

  final MascotPose pose;
  final double size;
  final bool interactive;
  final String? speechBubble;

  @override
  State<LiveMascot> createState() => _LiveMascotState();
}

class _LiveMascotState extends State<LiveMascot>
    with TickerProviderStateMixin {
  // Pose crossfade
  late AnimationController _crossfadeCtrl;
  late Animation<double> _crossfade;
  MascotPose _fromPose = MascotPose.greeting;
  MascotPose _toPose = MascotPose.greeting;

  // Ambient continuous animation (pose-specific)
  late AnimationController _ambientCtrl;

  // Tap bounce
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceScale;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _fromPose = widget.pose;
    _toPose = widget.pose;

    _crossfadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
    _crossfade = CurvedAnimation(parent: _crossfadeCtrl, curve: Curves.easeInOut);

    _ambientCtrl = AnimationController(
      vsync: this,
      duration: _ambientDurationFor(widget.pose),
    );

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.14)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.14, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 65,
      ),
    ]).animate(_bounceCtrl);

    _bounceCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => _showHeart = false);
          _bounceCtrl.reset();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) {
        _startAmbient();
      }
    });
  }

  Duration _ambientDurationFor(MascotPose pose) {
    switch (pose) {
      case MascotPose.dancing:
        return const Duration(milliseconds: 500);
      case MascotPose.crying:
        return const Duration(milliseconds: 1800);
      case MascotPose.fainted:
        return const Duration(milliseconds: 3000);
      case MascotPose.superHappy:
        return const Duration(milliseconds: 800);
      case MascotPose.cheering:
        return const Duration(milliseconds: 700);
      default:
        return const Duration(milliseconds: 2200);
    }
  }

  void _startAmbient() {
    _ambientCtrl.duration = _ambientDurationFor(_toPose);
    _ambientCtrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LiveMascot old) {
    super.didUpdateWidget(old);
    if (old.pose != widget.pose) {
      _fromPose = old.pose;
      _toPose = widget.pose;
      _crossfadeCtrl.value = 0.0;
      _crossfadeCtrl.forward();
      _ambientCtrl.stop();
      _ambientCtrl.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !MediaQuery.disableAnimationsOf(context)) {
          _startAmbient();
        }
      });
    }
  }

  @override
  void dispose() {
    _crossfadeCtrl.dispose();
    _ambientCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    if (!widget.interactive || MediaQuery.disableAnimationsOf(context)) return;
    if (_bounceCtrl.isAnimating) return;
    setState(() => _showHeart = true);
    _bounceCtrl.forward(from: 0.0);
  }

  Offset _ambientOffset(MascotPose pose, double t) {
    switch (pose) {
      case MascotPose.dancing:
        // Fast side-to-side sway
        return Offset(math.sin(t * math.pi) * 5.0, 0);
      case MascotPose.crying:
        // Slow sad droop
        return Offset(0, math.sin(t * math.pi) * 3.0);
      case MascotPose.fainted:
        // Almost still, tiny micro-twitch
        return Offset(math.sin(t * math.pi) * 1.0, 0);
      case MascotPose.superHappy:
        // Big bouncy jump
        return Offset(0, -math.sin(t * math.pi) * 9.0);
      case MascotPose.cheering:
        // Jump + sway
        return Offset(math.sin(t * math.pi * 2) * 3, -math.sin(t * math.pi) * 7.0);
      case MascotPose.happy:
        return Offset(0, -math.sin(t * math.pi) * 5.0);
      case MascotPose.encourage:
      case MascotPose.greeting:
        return Offset(0, math.sin(t * math.pi) * 5.0);
      default:
        return Offset(0, math.sin(t * math.pi) * 4.0);
    }
  }

  double _ambientRotation(MascotPose pose, double t) {
    switch (pose) {
      case MascotPose.dancing:
        return math.sin(t * math.pi * 2) * 0.18;
      case MascotPose.cheering:
        return math.sin(t * math.pi * 3) * 0.10;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.disableAnimationsOf(context);

    Widget buildPuppet(MascotPose pose) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(painter: _PuppyPainter(pose: pose)),
        );

    Widget body;

    if (disabled) {
      body = buildPuppet(_toPose);
    } else {
      body = AnimatedBuilder(
        animation: Listenable.merge([_ambientCtrl, _crossfadeCtrl, _bounceCtrl]),
        builder: (context, _) {
          final t = _ambientCtrl.value;
          final offset = _ambientOffset(_toPose, t);
          final rotation = _ambientRotation(_toPose, t);
          final crossfadeV = _crossfade.value;

          Widget mascotContent;
          if (crossfadeV < 1.0) {
            mascotContent = Stack(
              alignment: Alignment.center,
              children: [
                Opacity(opacity: 1.0 - crossfadeV, child: buildPuppet(_fromPose)),
                Opacity(opacity: crossfadeV, child: buildPuppet(_toPose)),
              ],
            );
          } else {
            mascotContent = buildPuppet(_toPose);
          }

          // Heart pop on tap
          final heartOpacity = _bounceCtrl.isAnimating
              ? TweenSequence<double>([
                  TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
                  TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 70),
                ]).evaluate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.linear))
              : 0.0;
          final heartOffsetY = _bounceCtrl.isAnimating
              ? Tween<double>(begin: 0.0, end: -22.0)
                  .evaluate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeOutQuad))
              : 0.0;

          return Transform.rotate(
            angle: rotation,
            child: Transform.translate(
              offset: offset,
              child: Transform.scale(
                scale: _bounceCtrl.isAnimating ? _bounceScale.value : 1.0,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    mascotContent,
                    if (_showHeart)
                      Positioned(
                        top: heartOffsetY,
                        right: widget.size * 0.12,
                        child: Opacity(
                          opacity: heartOpacity.clamp(0.0, 1.0),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: PookieColors.primaryDeep,
                            size: (widget.size * 0.22).clamp(14.0, 28.0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (widget.interactive) {
      body = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _triggerBounce,
        child: body,
      );
    }

    if (widget.speechBubble == null) return body;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: PookieColors.primaryDeep.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: PookieColors.blush, width: 1.5),
          ),
          child: Text(
            widget.speechBubble!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PookieColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
        body,
      ],
    );
  }
}

/// A delightful, vector-drawn white puppy mascot with expressive poses.
/// Responsive to touch with spring bounce and heart pop.
class PookieMascot extends StatefulWidget {
  const PookieMascot({
    super.key,
    this.pose = MascotPose.greeting,
    this.size = 100,
    this.speechBubble,
    this.interactive = true,
    this.onTap,
  });

  final MascotPose pose;
  final double size;
  final String? speechBubble;
  final bool interactive;
  final VoidCallback? onTap;

  @override
  State<PookieMascot> createState() => _PookieMascotState();
}

class _PookieMascotState extends State<PookieMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _heartOpacity;
  late final Animation<double> _heartOffset;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.12, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 65,
      ),
    ]).animate(_bounceController);

    _heartOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 70,
      ),
    ]).animate(_bounceController);

    _heartOffset = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOutQuad,
      ),
    );

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => _showHeart = false);
          _bounceController.reset();
        }
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    widget.onTap?.call();
    if (!widget.interactive || MediaQuery.disableAnimationsOf(context)) return;
    if (_bounceController.isAnimating) return;
    setState(() => _showHeart = true);
    _bounceController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.disableAnimationsOf(context);

    Widget mascotBody = SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _PuppyPainter(pose: widget.pose),
      ),
    );

    if (!disabled && widget.interactive) {
      mascotBody = AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                child!,
                if (_showHeart)
                  Positioned(
                    top: _heartOffset.value,
                    right: widget.size * 0.15,
                    child: Opacity(
                      opacity: _heartOpacity.value.clamp(0.0, 1.0),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: PookieColors.primaryDeep,
                        size: (widget.size * 0.22).clamp(14.0, 26.0),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        child: mascotBody,
      );
    }

    if (widget.interactive) {
      mascotBody = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _triggerBounce,
        child: mascotBody,
      );
    }

    if (widget.speechBubble == null) {
      return mascotBody;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: PookieColors.primaryDeep.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: PookieColors.blush, width: 1.5),
          ),
          child: Text(
            widget.speechBubble!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PookieColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
        mascotBody,
      ],
    );
  }
}

/// Continuously floating mascot for ambient life feel.
class FloatingMascot extends StatefulWidget {
  const FloatingMascot({
    super.key,
    required this.pose,
    required this.size,
    this.speechBubble,
    this.interactive = true,
    this.floatAmplitude = 6.0,
    this.floatDuration = const Duration(milliseconds: 2200),
  });

  final MascotPose pose;
  final double size;
  final String? speechBubble;
  final bool interactive;
  final double floatAmplitude;
  final Duration floatDuration;

  @override
  State<FloatingMascot> createState() => _FloatingMascotState();
}

class _FloatingMascotState extends State<FloatingMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: widget.floatDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) {
        _floatController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return PookieMascot(
        pose: widget.pose,
        size: widget.size,
        speechBubble: widget.speechBubble,
        interactive: widget.interactive,
      );
    }

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final dy = math.sin(_floatController.value * math.pi) *
            widget.floatAmplitude;
        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
      child: PookieMascot(
        pose: widget.pose,
        size: widget.size,
        speechBubble: widget.speechBubble,
        interactive: widget.interactive,
      ),
    );
  }
}

class _MascotFeedback {
  const _MascotFeedback(this.title, this.quote);
  final String title;
  final String quote;
}

/// Full-screen dramatic result mascot reveal overlay.
/// Score thresholds: 100=dancing, >=80=superHappy, >=60=happy, >=30=crying, <30=fainted
class ResultMascotOverlay extends StatefulWidget {
  const ResultMascotOverlay({
    super.key,
    required this.scorePercent,
    required this.onDismiss,
  });

  final int scorePercent;
  final VoidCallback onDismiss;

  @override
  State<ResultMascotOverlay> createState() => _ResultMascotOverlayState();
}

class _ResultMascotOverlayState extends State<ResultMascotOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _dancCtrl;

  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _slideY;
  late final Animation<double> _float;

  late MascotPose _pose;
  late String _title;
  late String _advisoryQuote;
  late Color _glowColor;
  late List<Color> _particleColors;

  final List<_Particle> _particles = [];
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _resolvePose();
    _spawnParticles();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _dancCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_entranceCtrl);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _slideY = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
    );

    _float = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceCtrl.forward();
        _floatCtrl.repeat(reverse: true);
        _particleCtrl.forward();
        if (_pose == MascotPose.dancing) {
          _dancCtrl.repeat(reverse: true);
        }
      }
    });
  }

  void _resolvePose() {
    final s = widget.scorePercent;
    late final List<_MascotFeedback> feedbackPool;

    if (s == 100) {
      _pose = MascotPose.dancing;
      _glowColor = const Color(0xFFFFD700);
      _particleColors = [
        const Color(0xFFFFD700),
        const Color(0xFFFF6FD8),
        const Color(0xFF3813C2),
        Colors.white,
      ];
      feedbackPool = const [
        _MascotFeedback(
          'অবিশ্বাস্য! তুমি তো সুপারস্টার! 🏆',
          'সাফল্য কোনো চূড়ান্ত গন্তব্য নয়, এটি ধরে রাখাই আসল কৃতিত্ব। এই একাগ্রতা বজায় রেখো!',
        ),
        _MascotFeedback(
          'পারফেক্ট স্কোর! একশোতে একশো! 🌟',
          'নিখুঁত প্রস্তুতি! আত্মবিশ্বাস ধরে রেখে প্রতিটি অধ্যায় নিয়মিত রিভিশনে রাখো।',
        ),
        _MascotFeedback(
          'তুখোড় ফলাফল! তুমি সেরা! 🎉',
          'তোমার একাগ্রতা ও অধ্যবসায় সত্যিই প্রশংসনীয়। মেডিকেল ভর্তি পরীক্ষায় এই ছন্দ ধরে রেখো!',
        ),
      ];
    } else if (s >= 80) {
      _pose = MascotPose.superHappy;
      _glowColor = const Color(0xFFFF6FD8);
      _particleColors = [PookieColors.primaryDeep, const Color(0xFFFF6FD8), Colors.white];
      feedbackPool = const [
        _MascotFeedback(
          'অসাধারণ ফলাফল! শাবাশ! ✨',
          'ধারাবাহিক অনুশীলনই সাফল্যের গোপন চাবিকাঠি। যে সামান্য ভুলগুলো হয়েছে, এখনই ঝালিয়ে নাও।',
        ),
        _MascotFeedback(
          'তুখোড় প্রস্তুতি! লক্ষ্যের খুব কাছে! 🎯',
          'ছোট ছোট খুঁটিনাটি ভুলগুলো কাটিয়ে উঠলে তোমার ফুল মার্কস নিশ্চিত!',
        ),
        _MascotFeedback(
          'চমৎকার পারফরম্যান্স! এগিয়ে যাও! 👏',
          'নেগেটিভ মার্কিং এড়িয়ে নির্ভুলতার দিকে নজর রাখো। তোমার সাফল্য সুনিশ্চিত!',
        ),
      ];
    } else if (s >= 60) {
      _pose = MascotPose.happy;
      _glowColor = PookieColors.primaryDeep;
      _particleColors = [PookieColors.primaryDeep, PookieColors.blush];
      feedbackPool = const [
        _MascotFeedback(
          'দারুণ চেষ্টা! আরেকটু এগিয়ে চলো! 🌸',
          'যেসব প্রশ্নে দ্বিধা ছিল, ব্যাখ্যাগুলো দেখে কনসেপ্টগুলো এখনই পরিষ্কার করে নাও।',
        ),
        _MascotFeedback(
          'বেশ ভালো! আরও উপরে উঠতে হবে! 📘',
          'প্রতিটি ভুল উত্তর একটি নতুন কিছু শেখার সুযোগ। ভুল খাতায় চোখ বুলিয়ে প্রস্তুতি মজবুত করো।',
        ),
        _MascotFeedback(
          'ভালো লড়াই! গতি বাড়াও! 🚀',
          'অনুশীলনের গতি ও নির্ভুলতা বাড়াও; নিয়মিত রিভিশনই সাধারণ প্রস্তুতিকে তুখোড় করে তোলে।',
        ),
      ];
    } else if (s >= 30) {
      _pose = MascotPose.crying;
      _glowColor = const Color(0xFF6BADE2);
      _particleColors = [const Color(0xFF6BADE2), Colors.white70];
      feedbackPool = const [
        _MascotFeedback(
          'মন খারাপ করো না! ঘুরে দাঁড়াও! 💪',
          'আজকের ভুলগুলোই আগামীকালের সঠিক উত্তরের ভিত্তি। শান্ত মাথায় ব্যাখ্যাগুলো পড়ে নাও।',
        ),
        _MascotFeedback(
          'হাল ছেড়ো না! শেখার মাত্র শুরু! 🌱',
          'কঠিন অধ্যায়গুলোতে একটু বেশি সময় দাও। নিয়মিত অনুশীলনেই ভয় দূর হবে।',
        ),
        _MascotFeedback(
          'ভয় পেও না! পরের ধাপে আরও ভালো হবে! 🌈',
          'পড়ে যাওয়া ব্যর্থতা নয়, থেমে যাওয়াই ব্যর্থতা। ভুলগুলো থেকে শিক্ষা নিয়ে আবার চেষ্টা করো!',
        ),
      ];
    } else {
      _pose = MascotPose.fainted;
      _glowColor = const Color(0xFFB0BEC5);
      _particleColors = [const Color(0xFFB0BEC5), Colors.white54];
      feedbackPool = const [
        _MascotFeedback(
          'উফ্! শক্ত হও, আবার শুরু করি! 🐾',
          'ভয় পেও না! নেগেটিভ মার্কিং কমাতে আন্দাজে উত্তর দেওয়া পরিহার করো। শান্ত মাথায় আবার শুরু করো!',
        ),
        _MascotFeedback(
          'হতাশ হয়ো না! পুকি পাশে আছে! ❤️🩹',
          'কঠোর পরিশ্রম কখনো বৃথা যায় না। ভুল প্রশ্নগুলো নোট খাতায় জমা হয়েছে, আরেকবার পড়ে নাও।',
        ),
        _MascotFeedback(
          'ধৈর্য ধরো! নতুন উদ্যমে শুরু হোক! ☀️',
          'বড় বিজয়ের আগে ছোটখাটো ধাক্কা আসতেই পারে। হাল ছেড়ো না, তোমার স্বপ্ন জয় করতেই হবে!',
        ),
      ];
    }

    final selected = feedbackPool[_rng.nextInt(feedbackPool.length)];
    _title = selected.title;
    _advisoryQuote = selected.quote;
  }

  void _spawnParticles() {
    for (int i = 0; i < 18; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: 4.0 + _rng.nextDouble() * 7,
        speed: 0.3 + _rng.nextDouble() * 0.7,
        angle: _rng.nextDouble() * math.pi * 2,
        delay: _rng.nextDouble() * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _particleCtrl.dispose();
    _dancCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final disabled = MediaQuery.disableAnimationsOf(context);

    if (disabled) {
      return GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          color: Colors.black54,
          child: Center(child: _buildCard()),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onDismiss,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _entranceCtrl,
          _floatCtrl,
          _particleCtrl,
          _dancCtrl,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.55 * _opacity.value),
                ),
              ),
              ..._buildParticles(screenSize),
              Center(
                child: Opacity(
                  opacity: _opacity.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, _slideY.value + _float.value),
                    child: Transform.scale(
                      scale: _scale.value,
                      child: _buildCard(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: (_opacity.value * (_entranceCtrl.value > 0.8 ? 1.0 : 0.0)).clamp(0.0, 1.0),
                  child: const Text(
                    'এগিয়ে যেতে যেকোনো জায়গায় ট্যাপ করো',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    final dancRotation = _pose == MascotPose.dancing
        ? math.sin(_dancCtrl.value * math.pi * 2) * 0.12
        : 0.0;

    return Container(
      width: 295,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _glowColor.withOpacity(0.35),
            blurRadius: 36,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _glowColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _glowColor.withOpacity(0.4)),
            ),
            child: Text(
              '${toBn(widget.scorePercent)}% নির্ভুলতা',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _glowColor == const Color(0xFFFFD700)
                    ? const Color(0xFFB8860B)
                    : _glowColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Transform.rotate(
            angle: dancRotation,
            child: SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(painter: _PuppyPainter(pose: _pose)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: PookieColors.ink,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: PookieColors.blush.withOpacity(0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PookieColors.blush, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 16,
                    color: PookieColors.primaryDeep,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _advisoryQuote,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: PookieColors.ink,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                'চালিয়ে যেতে ট্যাপ করো',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    if (_pose != MascotPose.dancing &&
        _pose != MascotPose.superHappy &&
        _pose != MascotPose.happy) { return []; }

    return List.generate(_particles.length, (i) {
      final p = _particles[i];
      final progress = (_particleCtrl.value - p.delay).clamp(0.0, 1.0);
      if (progress <= 0) return const SizedBox.shrink();

      final x = p.x * size.width +
          math.cos(p.angle) * progress * size.width * 0.3 * p.speed;
      final y = p.y * size.height - progress * size.height * 0.6 * p.speed;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final color = _particleColors[i % _particleColors.length];

      return Positioned(
        left: x,
        top: y,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: p.size,
            height: p.size,
            decoration: BoxDecoration(
              color: color,
              shape: i % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: i % 3 == 0 ? null : BorderRadius.circular(2),
            ),
          ),
        ),
      );
    });
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.delay,
  });
  final double x;
  final double y;
  final double size;
  final double speed;
  final double angle;
  final double delay;
}

// --- Painter -----------------------------------------------------------------

class _PuppyPainter extends CustomPainter {
  _PuppyPainter({required this.pose});
  final MascotPose pose;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scale = math.min(w, h) / 100;
    canvas.save();
    canvas.translate((w - 100 * scale) / 2, (h - 100 * scale) / 2);
    canvas.scale(scale, scale);

    final whitePaint = Paint()..color = const Color(0xFFFCFCFC);
    final shadowPaint = Paint()..color = const Color(0xFFF0E5EB);
    final earInnerPaint = Paint()..color = const Color(0xFFFFD1DF);
    final blushPaint = Paint()..color = const Color(0xFFFFB6CE).withOpacity(0.55);
    final inkPaint = Paint()..color = PookieColors.ink;
    final eyePaint = Paint()..color = const Color(0xFF2C1820);
    final whiteDot = Paint()..color = Colors.white;
    final collarPaint = Paint()..color = PookieColors.primaryDeep;
    final bellPaint = Paint()..color = const Color(0xFFFFD54F);
    final tearPaint = Paint()..color = const Color(0xFF6BADE2);

    canvas.drawOval(
      const Rect.fromLTWH(18, 88, 64, 10),
      Paint()..color = PookieColors.primary.withOpacity(0.2),
    );

    // --- Fainted: rotated sideways ---
    if (pose == MascotPose.fainted) {
      canvas.save();
      canvas.translate(50, 50);
      canvas.rotate(math.pi / 2);
      canvas.translate(-50, -50);
      final bodyPath = Path()
        ..moveTo(30, 68)
        ..cubicTo(26, 85, 30, 92, 42, 92)
        ..lineTo(58, 92)
        ..cubicTo(70, 92, 74, 85, 70, 68)
        ..close();
      canvas.drawPath(bodyPath, shadowPaint);
      canvas.drawPath(bodyPath, whitePaint);
      canvas.drawCircle(const Offset(22, 50), 6, whitePaint);
      canvas.drawCircle(const Offset(78, 50), 6, whitePaint);
      canvas.drawCircle(const Offset(42, 92), 6, whitePaint);
      canvas.drawCircle(const Offset(58, 92), 6, whitePaint);
      canvas.drawOval(const Rect.fromLTWH(22, 16, 56, 52), shadowPaint);
      canvas.drawOval(const Rect.fromLTWH(22, 16, 56, 52), whitePaint);
      _drawXEye(canvas, 39, 39, inkPaint);
      _drawXEye(canvas, 61, 39, inkPaint);
      _drawText(canvas, 'z', 10, 5, 12, PookieColors.accent);
      _drawText(canvas, 'Z', 75, 3, 16, PookieColors.primaryDeep);
      canvas.restore();
      canvas.restore();
      return;
    }

    // Body
    final bodyPath = Path()
      ..moveTo(30, 68)
      ..cubicTo(26, 85, 30, 92, 42, 92)
      ..lineTo(58, 92)
      ..cubicTo(70, 92, 74, 85, 70, 68)
      ..close();
    canvas.drawPath(bodyPath, shadowPaint);
    canvas.drawPath(bodyPath, whitePaint);

    // Collar
    canvas.drawPath(
      Path()
        ..moveTo(32, 66)
        ..quadraticBezierTo(50, 72, 68, 66)
        ..lineTo(67, 71)
        ..quadraticBezierTo(50, 77, 33, 71)
        ..close(),
      collarPaint,
    );
    canvas.drawCircle(const Offset(50, 75), 3.5, bellPaint);

    // Paws & accessories
    switch (pose) {
      case MascotPose.dancing:
        canvas.drawCircle(const Offset(20, 32), 7, whitePaint);
        canvas.drawCircle(const Offset(80, 32), 7, whitePaint);
        _drawSparkle(canvas, 10, 18, const Color(0xFFFFD700));
        _drawSparkle(canvas, 88, 18, PookieColors.primaryDeep);
        _drawSparkle(canvas, 50, 10, const Color(0xFFFF6FD8));
        _drawText(canvas, '?', 5, 40, 12, PookieColors.primaryDeep);
        _drawText(canvas, '?', 80, 45, 14, const Color(0xFFFF6FD8));
      case MascotPose.superHappy:
        canvas.drawCircle(const Offset(24, 38), 6, whitePaint);
        canvas.drawCircle(const Offset(76, 38), 6, whitePaint);
        _drawSparkle(canvas, 16, 22, PookieColors.primaryDeep);
        _drawSparkle(canvas, 84, 22, PookieColors.accent);
        _drawSparkle(canvas, 50, 8, const Color(0xFFFFD700));
      case MascotPose.happy:
        canvas.drawCircle(const Offset(24, 38), 6, whitePaint);
        canvas.drawCircle(const Offset(76, 38), 6, whitePaint);
        _drawHeart(canvas, 14, 20, 5);
        _drawSparkle(canvas, 82, 22, PookieColors.accent);
      case MascotPose.cheering:
        canvas.drawCircle(const Offset(24, 38), 6, whitePaint);
        canvas.drawCircle(const Offset(76, 38), 6, whitePaint);
        _drawSparkle(canvas, 16, 22, PookieColors.primaryDeep);
        _drawSparkle(canvas, 84, 22, PookieColors.accent);
      case MascotPose.crying:
        canvas.drawCircle(const Offset(36, 58), 6, whitePaint);
        canvas.drawCircle(const Offset(62, 58), 6, whitePaint);
        _drawTear(canvas, 36, 52, tearPaint);
        _drawTear(canvas, 62, 52, tearPaint);
      case MascotPose.greeting:
        canvas.drawCircle(const Offset(38, 86), 6, whitePaint);
        canvas.drawCircle(const Offset(76, 54), 6, whitePaint);
        _drawFlower(canvas, 85, 50);
      case MascotPose.thinking:
        canvas.drawCircle(const Offset(36, 86), 6, whitePaint);
        canvas.drawCircle(const Offset(58, 64), 6, whitePaint);
        _drawText(canvas, '?', 80, 24, 18, PookieColors.primaryDeep);
      case MascotPose.encourage:
        canvas.drawCircle(const Offset(36, 86), 6, whitePaint);
        canvas.drawCircle(const Offset(72, 72), 7, whitePaint);
        _drawHeart(canvas, 82, 58, 7);
      default:
        canvas.drawCircle(const Offset(38, 87), 6, whitePaint);
        canvas.drawCircle(const Offset(62, 87), 6, whitePaint);
    }

    // Head tilt
    canvas.save();
    if (pose == MascotPose.thinking) {
      canvas.translate(50, 42);
      canvas.rotate(0.12);
      canvas.translate(-50, -42);
    } else if (pose == MascotPose.crying) {
      canvas.translate(50, 42);
      canvas.rotate(-0.08);
      canvas.translate(-50, -42);
    }

    // Ears
    canvas.drawPath(
      Path()
        ..moveTo(26, 26)
        ..cubicTo(12, 34, 14, 58, 24, 60)
        ..cubicTo(29, 60, 32, 45, 34, 32)
        ..close(),
      whitePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(24, 32)
        ..cubicTo(16, 38, 17, 52, 23, 54)
        ..cubicTo(26, 54, 28, 44, 28, 36)
        ..close(),
      earInnerPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(74, 26)
        ..cubicTo(88, 34, 86, 58, 76, 60)
        ..cubicTo(71, 60, 68, 45, 66, 32)
        ..close(),
      whitePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(76, 32)
        ..cubicTo(84, 38, 83, 52, 77, 54)
        ..cubicTo(74, 54, 72, 44, 72, 36)
        ..close(),
      earInnerPaint,
    );

    // Head
    canvas.drawOval(const Rect.fromLTWH(22, 16, 56, 52), shadowPaint);
    canvas.drawOval(const Rect.fromLTWH(22, 16, 56, 52), whitePaint);

    // Blush
    canvas.drawOval(const Rect.fromLTWH(28, 44, 11, 7), blushPaint);
    canvas.drawOval(const Rect.fromLTWH(61, 44, 11, 7), blushPaint);

    // Eyes
    final linePaint = Paint()
      ..color = eyePaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    switch (pose) {
      case MascotPose.sleepy:
        canvas.drawPath(Path()..moveTo(34, 40)..quadraticBezierTo(39, 44, 44, 40), linePaint);
        canvas.drawPath(Path()..moveTo(56, 40)..quadraticBezierTo(61, 44, 66, 40), linePaint);
        _drawText(canvas, 'z', 76, 16, 12, PookieColors.accent);
        _drawText(canvas, 'Z', 84, 8, 16, PookieColors.primaryDeep);
      case MascotPose.crying:
        canvas.drawCircle(const Offset(39, 40), 4.5, eyePaint);
        canvas.drawCircle(const Offset(61, 40), 4.5, eyePaint);
        canvas.drawCircle(const Offset(37.5, 38.5), 1.6, whiteDot);
        canvas.drawCircle(const Offset(59.5, 38.5), 1.6, whiteDot);
        final browPaint = Paint()
          ..color = eyePaint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(Path()..moveTo(32, 33)..lineTo(44, 35), browPaint);
        canvas.drawPath(Path()..moveTo(56, 35)..lineTo(68, 33), browPaint);
      case MascotPose.dancing:
      case MascotPose.superHappy:
        _drawStarEye(canvas, 39, 39);
        _drawStarEye(canvas, 61, 39);
      case MascotPose.happy:
        canvas.drawPath(Path()..moveTo(34, 42)..quadraticBezierTo(39, 36, 44, 42), linePaint);
        canvas.drawPath(Path()..moveTo(56, 42)..quadraticBezierTo(61, 36, 66, 42), linePaint);
      default:
        canvas.drawCircle(const Offset(39, 39), 4.5, eyePaint);
        canvas.drawCircle(const Offset(61, 39), 4.5, eyePaint);
        canvas.drawCircle(const Offset(37.5, 37.5), 1.6, whiteDot);
        canvas.drawCircle(const Offset(40.5, 40.5), 0.8, whiteDot);
        canvas.drawCircle(const Offset(59.5, 37.5), 1.6, whiteDot);
        canvas.drawCircle(const Offset(62.5, 40.5), 0.8, whiteDot);
    }

    // Nose
    canvas.drawPath(
      Path()
        ..moveTo(47.5, 46)
        ..lineTo(52.5, 46)
        ..quadraticBezierTo(50, 49.5, 47.5, 46)
        ..close(),
      inkPaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = inkPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    switch (pose) {
      case MascotPose.crying:
        canvas.drawPath(
          Path()..moveTo(44, 53)..quadraticBezierTo(50, 49, 56, 53),
          mouthPaint,
        );
      case MascotPose.dancing:
      case MascotPose.superHappy:
      case MascotPose.happy:
      case MascotPose.cheering:
        final bigMouth = Paint()
          ..color = const Color(0xFFE91E8C)
          ..style = PaintingStyle.fill;
        canvas.drawOval(const Rect.fromLTWH(44, 49, 12, 8), bigMouth);
        canvas.drawOval(const Rect.fromLTWH(44.5, 49.5, 11, 4),
            Paint()..color = Colors.white70);
      default:
        canvas.drawPath(
          Path()..moveTo(46, 50)..quadraticBezierTo(48, 53, 50, 49),
          mouthPaint,
        );
        canvas.drawPath(
          Path()..moveTo(50, 49)..quadraticBezierTo(52, 53, 54, 50),
          mouthPaint,
        );
    }

    canvas.restore();
    canvas.restore();
  }

  void _drawXEye(Canvas canvas, double x, double y, Paint paint) {
    final p = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x - 3, y - 3), Offset(x + 3, y + 3), p);
    canvas.drawLine(Offset(x + 3, y - 3), Offset(x - 3, y + 3), p);
  }

  void _drawStarEye(Canvas canvas, double x, double y) {
    final p = Paint()..color = const Color(0xFFFFD700);
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;
      if (i == 0) {
        path.moveTo(x + 4.5 * math.cos(outerAngle), y + 4.5 * math.sin(outerAngle));
      } else {
        path.lineTo(x + 4.5 * math.cos(outerAngle), y + 4.5 * math.sin(outerAngle));
      }
      path.lineTo(x + 2.0 * math.cos(innerAngle), y + 2.0 * math.sin(innerAngle));
    }
    path.close();
    canvas.drawPath(path, p);
  }

  void _drawTear(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    path.moveTo(x, y);
    path.cubicTo(x - 2, y + 4, x - 2, y + 8, x, y + 10);
    path.cubicTo(x + 2, y + 8, x + 2, y + 4, x, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSparkle(Canvas canvas, double x, double y, Color color) {
    final p = Paint()..color = color;
    canvas.drawPath(
      Path()
        ..moveTo(x, y - 5)
        ..quadraticBezierTo(x, y, x + 5, y)
        ..quadraticBezierTo(x, y, x, y + 5)
        ..quadraticBezierTo(x, y, x - 5, y)
        ..quadraticBezierTo(x, y, x, y - 5)
        ..close(),
      p,
    );
  }

  void _drawFlower(Canvas canvas, double x, double y) {
    final petalPaint = Paint()..color = const Color(0xFFFFB6CE);
    final centerPaint = Paint()..color = const Color(0xFFFFD54F);
    for (int i = 0; i < 5; i++) {
      final angle = i * (2 * math.pi / 5);
      canvas.drawCircle(Offset(x + 3.5 * math.cos(angle), y + 3.5 * math.sin(angle)), 2.2, petalPaint);
    }
    canvas.drawCircle(Offset(x, y), 2, centerPaint);
  }

  void _drawHeart(Canvas canvas, double x, double y, double sz) {
    final paint = Paint()..color = PookieColors.primaryDeep;
    final path = Path();
    path.moveTo(x, y);
    path.cubicTo(x - sz, y - sz, x - sz * 1.4, y + sz * 0.4, x, y + sz * 1.2);
    path.cubicTo(x + sz * 1.4, y + sz * 0.4, x + sz, y - sz, x, y);
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, double x, double y, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant _PuppyPainter old) => old.pose != pose;
}
