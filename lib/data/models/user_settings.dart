class UserSettings {
  const UserSettings({
    this.useBnDigits = true,
    this.negativeMark = 0.25,
    this.reminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
  });

  final bool useBnDigits;
  final double negativeMark;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  UserSettings copyWith({
    bool? useBnDigits,
    double? negativeMark,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserSettings(
      useBnDigits: useBnDigits ?? this.useBnDigits,
      negativeMark: negativeMark ?? this.negativeMark,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      useBnDigits: json['use_bn_digits'] as bool? ?? true,
      negativeMark: (json['negative_mark'] as num?)?.toDouble() ?? 0.25,
      reminderEnabled: json['reminder_enabled'] as bool? ?? false,
      reminderHour: json['reminder_hour'] as int? ?? 20,
      reminderMinute: json['reminder_minute'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'use_bn_digits': useBnDigits,
        'negative_mark': negativeMark,
        'reminder_enabled': reminderEnabled,
        'reminder_hour': reminderHour,
        'reminder_minute': reminderMinute,
      };
}
