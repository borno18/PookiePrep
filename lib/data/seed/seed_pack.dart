import '../models/question.dart';
import '../models/digest_item.dart';

/// Bundled seed content pack as specified in architecture.md §8.1 and §9.
/// Contains high-yield medical admission GK questions across all 12 syllabus topics,
/// with an expanded verified dataset on the 1971 Liberation War of Bangladesh.
class SeedPack {
  static const String packId = 'seed_pack_2026_w42';
  static const int version = 2;

  static final List<DigestItem> digestItems = [
    const DigestItem(
      id: 'd_001',
      title: 'চিকিৎসাবিজ্ঞানে ২০২৬ সালের নোবেল পুরস্কার',

      fact: 'চিকিৎসাবিজ্ঞানে মাইক্রো-আরএনএ এবং জিন নিয়ন্ত্রণ আবিষ্কারের জন্য যৌথভাবে নোবেল পুরস্কার প্রদান করা হয়।',

      topic: 'recent_international',
      date: '2026-10-07',
      sources: [QuestionSource(name: 'NobelPrize.org', url: 'https://nobelprize.org')],
    ),
    const DigestItem(
      id: 'd_002',
      title: 'পদ্মা সেতু রেল সংযোগ প্রকল্প সম্পন্ন',

      fact: 'ঢাকা থেকে যশোর পর্যন্ত ১৬৯ কিলোমিটার রেলপথের পুরো অংশে বাণিজ্যিকভাবে ট্রেন চলাচল শুরু হয়েছে।',

      topic: 'recent_national',
      date: '2026-09-28',
      sources: [QuestionSource(name: 'বাংলাদেশ রেলওয়ে', url: 'https://railway.gov.bd')],
    ),
    const DigestItem(
      id: 'd_003',
      title: 'ইউনেস্কোর বিশ্ব ঐতিহ্যে সুন্দরবনের সংরক্ষণ অবস্থা',

      fact: 'ইউনেস্কো সুন্দরবনের রয়েল বেঙ্গল টাইগার ও জীববৈচিত্র্য সংরক্ষণে নতুন আন্তর্জাতিক সহায়তা তহবিল ঘোষণা করেছে।',

      topic: 'recent_national',
      date: '2026-10-02',
      sources: [QuestionSource(name: 'UNESCO News', url: 'https://unesco.org')],
    ),
    const DigestItem(
      id: 'd_004',
      title: 'বিশ্ব স্বাস্থ্য সংস্থার বৈশ্বিক টিকাদান কর্মসূচি',

      fact: 'ডব্লিউএইচও ২০২৬-২৭ সেশনের জন্য ম্যালেরিয়া ভ্যাকসিনের দ্বিতীয় প্রজন্মকে সর্বজনীন তালিকায় অন্তর্ভুক্ত করেছে।',

      topic: 'recent_international',
      date: '2026-10-10',
      sources: [QuestionSource(name: 'WHO Media Centre', url: 'https://who.int')],
    ),
    const DigestItem(
      id: 'd_005',
      title: 'বাংলাদেশের প্রথম গভীর সমুদ্রবন্দর মাতারবাড়ী',

      fact: 'কক্সবাজারের মহেশখালীতে নির্মিত মাতারবাড়ী গভীর সমুদ্রবন্দরে প্রথম বাণিজ্যিক মাদার ভেসেল ভিড়েছে।',

      topic: 'recent_national',
      date: '2026-10-05',
      sources: [QuestionSource(name: 'চট্টগ্রাম বন্দর কর্তৃপক্ষ', url: 'https://cpa.gov.bd')],
    ),
    const DigestItem(
      id: 'd_006',
      title: '১৯৭১ সালের মুক্তিযুদ্ধ জাদুঘরের ঐতিহাসিক স্মারক',

      fact: 'মুক্তিযুদ্ধ জাদুঘরে সংরক্ষিত স্বাধীনতার ঘোষণাপত্র ও মুজিবনগর সরকারের মূল নথি ইউনেস্কোর মেমোরি অব দ্য ওয়ার্ল্ড আঞ্চলিক তালিকায় বিবেচনার জন্য মনোনীত হয়েছে।',

      topic: 'bd_liberation_war',
      date: '2026-10-12',
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org')],
    ),
  ];

  static final List<Question> questions = [
    // =========================================================================
    // ১. মুক্তিযুদ্ধ ও স্বাধীনতা (bd_liberation_war) — Verified 1971 Research Bank
    // =========================================================================

    // --- Provisional Government & Proclamation ---
    const Question(
      id: 'q_war_001',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: '১৯৭১ সালের ঐতিহাসিক মুজিবনগর সরকার কত তারিখে আনুষ্ঠানিকভাবে শপথ গ্রহণ করে?',

      options: ['১০ এপ্রিল ১৯৭১', '১৭ এপ্রিল ১৯৭১', '২৫ মার্চ ১৯৭১', '২৬ মার্চ ১৯৭১'],
      answerIndex: 1,
      explanation: 'মুজিবনগর সরকার ১০ এপ্রিল গঠিত হয় এবং ১৭ এপ্রিল মেহেরপুরের বৈদ্যনাথতলার ভবেরপাড়ায় (মুজিবনগর) শপথ গ্রহণ করে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/page/history')],
    ),
    const Question(
      id: 'q_war_002',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'proclamation',
      text: 'বাংলাদেশের স্বাধীনতার ঐতিহাসিক ঘোষণাপত্র (Proclamation of Independence) কত তারিখে আনুষ্ঠানিকভাবে জারি করা হয়?',

      options: ['২৬ মার্চ ১৯৭১', '১০ এপ্রিল ১৯৭১', '১৭ এপ্রিল ১৯৭১', '১৬ ডিসেম্বর ১৯৭১'],
      answerIndex: 1,
      explanation: '১০ এপ্রিল ১৯৭১ তারিখে মুজিবনগরে আনুষ্ঠানিকভাবে স্বাধীনতার ঘোষণাপত্র গৃহীত হয়, যা ২৬ মার্চ ১৯৭১ থেকে কার্যকর ঘোষণা করা হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_003',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'proclamation',
      text: '১৯৭১ সালের স্বাধীনতার ঘোষণাপত্রে রাষ্ট্র গঠনের কোন তিনটি মূলনীতির কথা স্পষ্টভাবে উল্লেখ ছিল?',

      options: [
        'সাম্য, মানবিক মর্যাদা ও সামাজিক সুবিচার',
        'গণতন্ত্র, সমাজতন্ত্র ও ধর্মনিরপেক্ষতা',
        'জাতীয়তাবাদ, একতা ও সার্বভৌমত্ব',
        'শান্তি, প্রগতি ও ন্যায়বিচার'
      ],
      answerIndex: 0,
      explanation: '১০ এপ্রিলের স্বাধীনতার ঘোষণাপত্রে সুস্পষ্টভাবে বলা হয়: বাংলাদেশের জনগণের জন্য সাম্য (Equality), মানবিক মর্যাদা (Human Dignity) ও সামাজিক সুবিচার (Social Justice) নিশ্চিত করাই রাষ্ট্রের মূল লক্ষ্য।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/page/history')],
    ),
    const Question(
      id: 'q_war_004',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: 'মুজিবনগর সরকারের প্রধানমন্ত্রী কে ছিলেন?',

      options: ['তাজউদ্দীন আহমদ', 'সৈয়দ নজরুল ইসলাম', 'খন্দকার মোশতাক আহমদ', 'এম মনসুর আলী'],
      answerIndex: 0,
      explanation: 'বঙ্গবন্ধু শেখ মুজিবুর রহমান ছিলেন রাষ্ট্রপতি (অনুপস্থিতিতে সৈয়দ নজরুল ইসলাম ভারপ্রাপ্ত রাষ্ট্রপতি) এবং তাজউদ্দীন আহমদ ছিলেন প্রধানমন্ত্রী।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/page/history')],
    ),
    const Question(
      id: 'q_war_005',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: 'মুজিবনগর সরকারের অর্থমন্ত্রী হিসেবে কে দায়িত্ব পালন করেছিলেন?',

      options: ['এম মনসুর আলী', 'এ এইচ এম কামারুজ্জামান', 'তাজউদ্দীন আহমদ', 'ড. কামাল হোসেন'],
      answerIndex: 0,
      explanation: 'ক্যাপ্টেন এম মনসুর আলী অর্থ, বাণিজ্য ও শিল্প মন্ত্রণালয়ের দায়িত্বে নিয়োজিত ছিলেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_006',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: 'মুজিবনগর সরকারের স্বরাষ্ট্র, ত্রাণ ও পুনর্বাসন মন্ত্রী কে ছিলেন?',

      options: ['এ এইচ এম কামারুজ্জামান', 'এম মনসুর আলী', 'খন্দকার মোশতাক আহমদ', 'সৈয়দ নজরুল ইসলাম'],
      answerIndex: 0,
      explanation: 'এ এইচ এম কামারুজ্জামান স্বরাষ্ট্র, সরবরাহ, ত্রাণ ও পুনর্বাসন মন্ত্রণালয়ের দায়িত্ব পালন করেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/page/history')],
    ),
    const Question(
      id: 'q_war_007',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: '১৭ এপ্রিল ১৯৭১ মুজিবনগর সরকারের শপথ অনুষ্ঠানে গার্ড অব অনার প্রদানকারী দলের নেতৃত্ব দেন কে?',

      options: ['এসডিপিও মাহবুবউদ্দিন আহমেদ', 'মেজর জিয়াউর রহমান', 'মেজর রফিকুল ইসলাম', 'ক্যাপ্টেন মহিউদ্দিন জাহাঙ্গীর'],
      answerIndex: 0,
      explanation: 'ঝিনাইদহের মহকুমা পুলিশ কর্মকর্তা (এসডিপিও) মাহবুবউদ্দিন আহমেদ বীর বিক্রম ১২ জন আনসার ও পুলিশ সদস্য নিয়ে ভারপ্রাপ্ত রাষ্ট্রপতিকে ঐতিহাসিক গার্ড অব অনার প্রদান করেন।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/on-this-day/1971-04-17')],
    ),
    const Question(
      id: 'q_war_008',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'mujibnagar',
      text: 'মুক্তিযুদ্ধে বাংলাদেশ সেনাবাহিনীর সর্বাধিনায়ক বা প্রধান সেনাপতি (Commander-in-Chief) কে ছিলেন?',

      options: ['কর্নেল এম এ জি ওসমানী', 'লেফটেন্যান্ট কর্নেল এম এ রব', 'গ্রুপ ক্যাপ্টেন এ কে খন্দকার', 'মেজর জিয়াউর রহমান'],
      answerIndex: 0,
      explanation: 'কর্নেল (পরে জেনারেল) মুহাম্মদ আতাউল গণি ওসমানী ছিলেন মুক্তিবাহিনীর প্রধান সেনাপতি।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd')],
    ),
    const Question(
      id: 'q_war_009',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'military_staff',
      text: 'মুক্তিযুদ্ধে বাংলাদেশ ফোর্সেসের উপ-প্রধান সেনাপতি বা ডেপুটি চিফ অব স্টাফ কে ছিলেন?',

      options: ['গ্রুপ ক্যাপ্টেন এ কে খন্দকার', 'লেফটেন্যান্ট কর্নেল এম এ রব', 'মেজর খালেদ মোশাররফ', 'মেজর কে এম শফিউল্লাহ'],
      answerIndex: 0,
      explanation: 'গ্রুপ ক্যাপ্টেন এ কে খন্দকার ছিলেন ডেপুটি চিফ অব স্টাফ এবং লেফটেন্যান্ট কর্নেল এম এ রব ছিলেন চিফ অব স্টাফ।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Navy', url: 'https://navy.mil.bd/About/honour.html')],
    ),

    // --- Military Sectors (1 to 11) ---
    const Question(
      id: 'q_war_010',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sectors',
      text: 'মুক্তিযুদ্ধের রণকৌশল পরিচালনার সুবিধার জন্য সমগ্র বাংলাদেশকে কয়টি সেক্টরে বিভক্ত করা হয়েছিল?',

      options: ['৯টি', '১০টি', '১১টি', '৬৪টি'],
      answerIndex: 2,
      explanation: '১৯৭১ সালের ১০-১৭ জুলাই অনুষ্ঠিত সেক্টর কমান্ডারদের সম্মেলনে পুরো বাংলাদেশকে ১১টি সেক্টর এবং ৬৪টি সাব-সেক্টরে বিভক্ত করা হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/1')],
    ),
    const Question(
      id: 'q_war_011',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_1',
      text: 'মুক্তিযুদ্ধের ১ নম্বর সেক্টরের সদর দফতর (Headquarters) কোথায় ছিল?',

      options: ['হরিণা', 'মেলাঘর', 'হেজামারা', 'বুড়িমারী'],
      answerIndex: 0,
      explanation: '১ নম্বর সেক্টরের অপারেশনাল এলাকা ছিল চট্টগ্রাম, পার্বত্য চট্টগ্রাম ও ফেনী নদী পর্যন্ত এবং এর সদর দফতর ছিল ভারতের হরিণায়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/1')],
    ),
    const Question(
      id: 'q_war_012',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_1',
      text: '১ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: [
        'মেজর জিয়াউর রহমান (পরে মেজর রফিকুল ইসলাম)',
        'মেজর খালেদ মোশাররফ',
        'মেজর সি আর দত্ত',
        'মেজর মীর শওকত আলী'
      ],
      answerIndex: 0,
      explanation: '১ নম্বর সেক্টরের কমান্ডার ছিলেন প্রথমে মেজর জিয়াউর রহমান, পরবর্তীতে মেজর রফিকুল ইসলাম।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/1')],
    ),
    const Question(
      id: 'q_war_013',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_2',
      text: 'ঢাকা শহর, কুমিল্লা, ফরিদপুর ও নোয়াখালী কোন সেক্টরের অন্তর্ভুক্ত ছিল?',

      options: ['সেক্টর ২', 'সেক্টর ৩', 'সেক্টর ৮', 'সেক্টর ১১'],
      answerIndex: 0,
      explanation: 'সেক্টর ২-এর আওতাধীন ছিল ঢাকা, কুমিল্লা, ফরিদপুর ও নোয়াখালী জেলার অংশবিশেষ। এর সদর দফতর ছিল মেলাঘরে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/2')],
    ),
    const Question(
      id: 'q_war_014',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_2',
      text: '২ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: [
        'মেজর খালেদ মোশাররফ (পরে মেজর এ টি এম হায়দার)',
        'মেজর কে এম শফিউল্লাহ',
        'মেজর আবু ওসমান চৌধুরী',
        'মেজর এম এ জলিল'
      ],
      answerIndex: 0,
      explanation: 'সেক্টর ২-এর কমান্ডার ছিলেন মেজর খালেদ মোশাররফ, সেপ্টেম্বর থেকে মেজর এ টি এম হায়দার।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/2')],
    ),
    const Question(
      id: 'q_war_015',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'forces',
      text: 'মুক্তিযুদ্ধের সময় ঢাকার অভ্যন্তরে দুঃসাহসী গেরিলা অভিযানের জন্য গঠিত বিখ্যাত দলটির নাম কী ছিল?',

      options: ['ক্র্যাক প্লাটুন', 'মুজিব বাহিনী', 'কাদেরিয়া বাহিনী', 'কিলো ফ্লাইট'],
      answerIndex: 0,
      explanation: 'সেক্টর ২-এর অধীনে গঠিত ক্র্যাক প্লাটুনের তরুণ মুক্তিযোদ্ধারা (রুমি, জুয়েল, বদি প্রমুখ) ঢাকায় পাকিস্তানি বাহিনীর ওপর তীব্র আক্রমণ চালান।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_016',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_3',
      text: '৩ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: [
        'মেজর কে এম শফিউল্লাহ (পরে মেজর এ এন এম নুরুজ্জামান)',
        'মেজর সি আর দত্ত',
        'মেজর আবু তাহের',
        'উইং কমান্ডার খাদেমুল বাশার'
      ],
      answerIndex: 0,
      explanation: 'সেক্টর ৩-এর এলাকা ছিল সিলেট, ব্রাহ্মণবাড়িয়া, কিশোরগঞ্জ ও ঢাকার অংশ; কমান্ডার ছিলেন মেজর কে এম শফিউল্লাহ। সদর দফতর ছিল হেজামারায়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/3')],
    ),
    const Question(
      id: 'q_war_017',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_4',
      text: 'সিলেট জেলার পূর্বাঞ্চল নিয়ে গঠিত ৪ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: ['মেজর সি আর দত্ত (চিত্তরঞ্জন দত্ত)', 'মেজর মীর শওকত আলী', 'মেজর নাজমুল হক', 'মেজর এম এ জলিল'],
      answerIndex: 0,
      explanation: '৪ নম্বর সেক্টরের কমান্ডার ছিলেন মেজর চিত্তরঞ্জন দত্ত (সি আর দত্ত বীর উত্তম)। এর সদর দফতর ছিল ভারতের করিমগঞ্জ/মাসিমপুরে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/4')],
    ),
    const Question(
      id: 'q_war_018',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_5',
      text: 'সুনামগঞ্জ ও সিলেটের উত্তরাঞ্চল নিয়ে গঠিত ৫ নম্বর সেক্টরের সদর দফতর কোথায় ছিল?',

      options: ['বাঁশতলা', 'বুড়িমারী', 'তরঙ্গপুর', 'মেলাঘর'],
      answerIndex: 0,
      explanation: 'বাংলাদেশ সেনাবাহিনীর প্রাতিষ্ঠানিক তথ্য অনুযায়ী ৫ নম্বর সেক্টরের সদর দফতর ছিল বাঁশতলায় (কমান্ডার মেজর মীর শওকত আলী)।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/5')],
    ),
    const Question(
      id: 'q_war_019',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_6',
      text: 'মুক্তিযুদ্ধের কোন সেক্টরের কমান্ডার ছিলেন একমাত্র বিমানবাহিনীর কর্মকর্তা?',

      options: ['সেক্টর ৬ (উইং কমান্ডার খাদেমুল বাশার)', 'সেক্টর ১', 'সেক্টর ৯', 'সেক্টর ১১'],
      answerIndex: 0,
      explanation: 'সেক্টর ৬-এর (রংপুর ও দিনাজপুরের উত্তরাঞ্চল) কমান্ডার ছিলেন উইং কমান্ডার মোহাম্মদ খাদেমুল বাশার বীর উত্তম। সদর দফতর ছিল বুড়িমারীতে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/6')],
    ),
    const Question(
      id: 'q_war_020',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_7',
      text: 'রাজশাহী, পাবনা, বগুড়া ও দিনাজপুরের দক্ষিণাঞ্চল নিয়ে গঠিত ৭ নম্বর সেক্টরের সদর দফতর কোথায় ছিল?',

      options: ['তরঙ্গপুর', 'বুড়িমারী', 'বেনাপোল', 'হাসনাবাদ'],
      answerIndex: 0,
      explanation: '৭ নম্বর সেক্টরের সদর দফতর ছিল ভারতের তরঙ্গপুরে। কমান্ডার ছিলেন মেজর নাজমুল হক, পরে মেজর কাজী নুরুজ্জামান।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/7')],
    ),
    const Question(
      id: 'q_war_021',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_8',
      text: 'কুষ্টিয়া, যশোর ও খুলনা জেলা নিয়ে গঠিত ৮ নম্বর সেক্টরের প্রথম কমান্ডার কে ছিলেন?',

      options: ['মেজর আবু ওসমান চৌধুরী', 'মেজর এম এ মঞ্জুর', 'মেজর এম এ জলিল', 'মেজর আবু তাহের'],
      answerIndex: 0,
      explanation: 'সেক্টর ৮-এর প্রথম কমান্ডার ছিলেন মেজর আবু ওসমান চৌধুরী, আগস্ট থেকে মেজর এম এ মঞ্জুর। সদর দফতর ছিল বেনাপোল/কল্যাণীতে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/8')],
    ),
    const Question(
      id: 'q_war_022',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_9',
      text: 'বরিশাল, পটুয়াখালী এবং খুলনার দক্ষিণাঞ্চল নিয়ে গঠিত ৯ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: ['মেজর এম এ জলিল', 'মেজর জয়নাল আবেদীন', 'মেজর আবু তাহের', 'মেজর রফিকুল ইসলাম'],
      answerIndex: 0,
      explanation: '৯ নম্বর সেক্টরের কমান্ডার ছিলেন মেজর মোহাম্মদ আব্দুল জলিল (এম এ জলিল)। এর সদর দফতর ছিল ভারতের হাসনাবাদে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/9')],
    ),
    const Question(
      id: 'q_war_023',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_10',
      text: 'মুক্তিযুদ্ধের কোন সেক্টরে কোনো নির্দিষ্ট নিয়মিত কমান্ডার ছিলেন না এবং তা নৌ কমান্ডোদের দ্বারা পরিচালিত হতো?',

      options: ['সেক্টর ১০', 'সেক্টর ১', 'সেক্টর ১১', 'সেক্টর ৫'],
      answerIndex: 0,
      explanation: '১০ নম্বর সেক্টর ছিল নৌ সেক্টর। এটি সমগ্র নদীপথ ও উপকূলীয় এলাকা জুড়ে বিস্তৃত ছিল এবং প্রধান সেনাপতির সদর দফতরের সরাসরি নিয়ন্ত্রণে পরিচালিত হতো।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/10')],
    ),
    const Question(
      id: 'q_war_024',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'sector_11',
      text: 'ময়মনসিংহ ও টাঙ্গাইল নিয়ে গঠিত ১১ নম্বর সেক্টরের কমান্ডার কে ছিলেন?',

      options: [
        'মেজর আবু তাহের (পরে স্কোয়াড্রন লিডার এম হামিদুল্লাহ খান)',
        'মেজর জিয়াউর রহমান',
        'মেজর খালেদ মোশাররফ',
        'মেজর কে এম শফিউল্লাহ'
      ],
      answerIndex: 0,
      explanation: '১১ নম্বর সেক্টরের কমান্ডার ছিলেন মেজর আবু তাহের (যিনি এক যুদ্ধে পা হারান), পরে স্কোয়াড্রন লিডার এম হামিদুল্লাহ খান। সদর দফতর ছিল মহেন্দ্রগঞ্জে।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Sector/11')],
    ),

    // --- Regular Brigades & Special Operations ---
    const Question(
      id: 'q_war_025',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'brigades',
      text: 'মুক্তিযুদ্ধে প্রথম গঠিত নিয়মিত পদাতিক ব্রিগেডের নাম কী ছিল?',

      options: ['জেড ফোর্স (Z-Force)', 'কে ফোর্স (K-Force)', 'এস ফোর্স (S-Force)', 'মুজিব ব্যাটালিয়ন'],
      answerIndex: 0,
      explanation: '১৯৭১ সালের জুলাইয়ে মেজর জিয়াউর রহমানের নামের আদ্যক্ষর নিয়ে গঠিত হয় প্রথম ব্রিগেড জেড ফোর্স।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_026',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'brigades',
      text: 'মেজর খালেদ মোশাররফের নেতৃত্বে গঠিত নিয়মিত ব্রিগেডটির নাম কী ছিল?',

      options: ['কে ফোর্স (K-Force)', 'জেড ফোর্স (Z-Force)', 'এস ফোর্স (S-Force)', 'টাইগার ফোর্স'],
      answerIndex: 0,
      explanation: 'মেজর খালেদ মোশাররফের নেতৃত্বে গঠিত হয় কে-ফোর্স এবং মেজর কে এম শফিউল্লাহর নেতৃত্বে গঠিত হয় এস-ফোর্স।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_027',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'naval_operations',
      text: '১৫ আগস্ট ১৯৭১ সালে একযোগে চট্টগ্রাম, মোংলা, চাঁদপুর ও নারায়ণগঞ্জ নৌবন্দরে পরিচালিত ঐতিহাসিক নৌ কমান্ডো অভিযানের সাংকেতিক নাম কী ছিল?',

      options: ['অপারেশন জ্যাকপট', 'অপারেশন সার্চলাইট', 'অপারেশন ক্লোজডোর', 'অপারেশন ডেভিল'],
      answerIndex: 0,
      explanation: 'অপারেশন জ্যাকপট ছিল ১০ নম্বর সেক্টরের নৌ কমান্ডোদের পরিচালিত অত্যন্ত সফল লিম্পেট মাইন আক্রমণ, যা আন্তর্জাতিক মহলে আলোড়ন তোলে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Navy', url: 'https://navy.mil.bd/About/honour.html')],
    ),
    const Question(
      id: 'q_war_028',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'air_force',
      text: '২৮ সেপ্টেম্বর ১৯৭১ তারিখে ভারতের ডিমাপুরে কোন নামে বাংলাদেশ বিমানবাহিনীর ঐতিহাসিক শুভ সূচনা হয়?',

      options: ['কিলো ফ্লাইট (Kilo Flight)', 'মুক্ত আকাশ', 'ঈগল স্কোয়াড্রন', 'ফ্যালকন টিম'],
      answerIndex: 0,
      explanation: 'নাগাল্যান্ডের ডিমাপুরে একটি ডিসি-৩ ডাকোটা, একটি অটার বিমান ও একটি অ্যালুয়েট হেলিকপ্টার এবং ৫৭ জন সদস্য নিয়ে কিলো ফ্লাইট গঠিত হয়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_029',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'forces',
      text: 'টাঙ্গাইল অঞ্চলে পাকিস্তানি বাহিনীর বিরুদ্ধে বীরত্বের সাথে লড়াইকারী সুপরিচিত বেসামরিক গেরিলা বাহিনীর নাম কী ছিল?',

      options: ['কাদেরিয়া বাহিনী', 'হেমায়েত বাহিনী', 'আফসার বাহিনী', 'মুজিব বাহিনী'],
      answerIndex: 0,
      explanation: 'বীর মুক্তিযোদ্ধা আবদুল কাদের সিদ্দিকী (বীর উত্তম)-এর নেতৃত্বে টাঙ্গাইলে গঠিত হয় কাদেরিয়া বাহিনী। গোপালগঞ্জে ছিল হেমায়েত বাহিনী এবং ভালুকায় আফসার বাহিনী।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),

    // --- Gallantry Awards & Bir Sreshtho ---
    const Question(
      id: 'q_war_030',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'gallantry',
      text: 'মুক্তিযুদ্ধে অসামান্য আত্মত্যাগের স্বীকৃতিস্বরূপ সর্বোচ্চ রাষ্ট্রীয় বীরত্বসূচক খেতাব কোনটি এবং কতজনকে তা দেওয়া হয়েছে?',

      options: [
        'বীরশ্রেষ্ঠ (৭ জন)',
        'বীর উত্তম (৬৮ জন)',
        'বীর বিক্রম (১৭৫ জন)',
        'বীর প্রতীক (৪২৬ জন)'
      ],
      answerIndex: 0,
      explanation: 'সর্বোচ্চ খেতাব বীরশ্রেষ্ঠ (৭ জন)। দ্বিতীয় বীর উত্তম (৬৮ জন), তৃতীয় বীর বিক্রম (১৭৫ জন) এবং চতুর্থ বীর প্রতীক (৪২৬ জন)।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_031',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'বীরশ্রেষ্ঠদের মধ্যে একমাত্র নৌবাহিনীর সদস্য কে ছিলেন এবং তিনি কোথায় শহীদ হন?',

      options: [
        'মোহাম্মদ রুহুল আমিন (খুলনার রূপসা নদীতে)',
        'মতিউর রহমান (করাচিতে)',
        'মহিউদ্দিন জাহাঙ্গীর (চাঁপাইনবাবগঞ্জে)',
        'হামিদুর রহমান (শ্রীমঙ্গলে)'
      ],
      answerIndex: 0,
      explanation: 'ইঞ্জিনরুম আর্টিফিসার মোহাম্মদ রুহুল আমিন ১০ ডিসেম্বর খুলনার রূপসা নদীতে গানবোট পলাশে পাকিস্তানি বিমান হামলায় শহীদ হন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Navy', url: 'https://navy.mil.bd/About/honour.html')],
    ),
    const Question(
      id: 'q_war_032',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'বীরশ্রেষ্ঠ ক্যাপ্টেন মহিউদ্দিন জাহাঙ্গীরের সমাধি কোন ঐতিহাসিক স্থান প্রাঙ্গণে অবস্থিত?',

      options: ['ছোট সোনা মসজিদ', 'ষাট গম্বুজ মসজিদ', 'লালবাগ কেল্লা', 'বাঘা মসজিদ'],
      answerIndex: 0,
      explanation: '১৪ ডিসেম্বর ১৯৭১ চাঁপাইনবাবগঞ্জের রেহাইচরে শহীদ ক্যাপ্টেন মহিউদ্দিন জাহাঙ্গীরকে ঐতিহাসিক ছোট সোনা মসজিদ চত্বরে সমাহিত করা হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/Chhota_Sona_Mosque')],
    ),
    const Question(
      id: 'q_war_033',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'রাঙামাটির মহালছড়ির বুড়িঘাটে চিংড়ি খালের কাছে একাই শত্রুদের ঠেকিয়ে নিজের দলের সেনাদের বাঁচিয়ে শহীদ হন কোন বীরশ্রেষ্ঠ?',

      options: ['ল্যান্স নায়েক মুন্সী আব্দুর রউফ', 'সিপাহী মোস্তফা কামাল', 'ল্যান্স নায়েক নূর মোহাম্মদ শেখ', 'সিপাহী হামিদুর রহমান'],
      answerIndex: 0,
      explanation: 'ইপিআরের ল্যান্স নায়েক মুন্সী আব্দুর রউফ ৮ এপ্রিল ১৯৭১ বুড়িঘাটে মেশিনগান চালিয়ে সহযোদ্ধাদের পিছু হটার সুযোগ করে দেন এবং বীরত্বের সাথে শহীদ হন।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_034',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'ব্রাহ্মণবাড়িয়ার আখাউড়ার দরুইন গ্রামে ১৮ এপ্রিল ১৯৭১ পাকিস্তানি বাহিনীকে একাই প্রতিহত করে শহীদ হন কে?',

      options: ['সিপাহী মোস্তফা কামাল', 'সিপাহী হামিদুর রহমান', 'মুন্সী আব্দুর রউফ', 'মতিউর রহমান'],
      answerIndex: 0,
      explanation: 'সেনাবাহিনীর বীরশ্রেষ্ঠ সিপাহী মোস্তফা কামাল নিজের জীবন উৎসর্গ করে দরুইন গ্রামে একাই সহযোদ্ধাদের নিরাপদে পিছু হটার পথ সুগম করেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_035',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'বীরশ্রেষ্ঠ ফ্লাইট লেফটেন্যান্ট মতিউর রহমানের দেহাবশেষ কত সালে পাকিস্তান থেকে ফিরিয়ে এনে ঢাকায় দাফন করা হয়?',

      options: ['২০০৬ সালে', '১৯৭২ সালে', '১৯৯৯ সালে', '২০১০ সালে'],
      answerIndex: 0,
      explanation: 'করাচির মাশরুর বিমানঘাঁটিতে সমাহিত মতিউর রহমানের দেহাবশেষ ২০০৬ সালের ২৪ জুন দেশে এনে মিরপুর শহীদ বুদ্ধিজীবী কবরস্থানে রাষ্ট্রীয় মর্যাদায় সমাহিত করা হয়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_036',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'যশোরের শার্শার গোয়ালহাটিতে ৫ সেপ্টেম্বর ১৯৭১ সহযোদ্ধা নান্নু মিয়াকে রক্ষা করতে গিয়ে নিজের জীবন দেন কোন বীরশ্রেষ্ঠ?',

      options: ['ল্যান্স নায়েক নূর মোহাম্মদ শেখ', 'মুন্সী আব্দুর রউফ', 'মোস্তফা কামাল', 'হামিদুর রহমান'],
      answerIndex: 0,
      explanation: 'ইপিআরের ল্যান্স নায়েক নূর মোহাম্মদ শেখ গোয়ালহাটিতে গুরুতর আহত অবস্থাতেও অস্ত্র চালিয়ে পাকিস্তানি বাহিনীকে রুখে দেন।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_037',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'birsreshtho',
      text: 'সর্বকনিষ্ঠ বীরশ্রেষ্ঠ কে ছিলেন এবং তিনি কোন সেক্টরে যুদ্ধ করেছিলেন?',

      options: [
        'সিপাহী হামিদুর রহমান (মাত্র ১৮ বছর বয়স, সেক্টর ৪)',
        'সিপাহী মোস্তফা কামাল (সেক্টর ২)',
        'মুন্সী আব্দুর রউফ (সেক্টর ১)',
        'মতিউর রহমান (বিমানবাহিনী)'
      ],
      answerIndex: 0,
      explanation: 'বীরশ্রেষ্ঠ হামিদুর রহমান শ্রীমঙ্গলের ধলই সীমান্তে ২৮ অক্টোবর ১৯৭১ মাত্র ১৮ বছর বয়সে শহীদ হন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Army', url: 'https://www.army.mil.bd/Bir-Sreshtho')],
    ),
    const Question(
      id: 'q_war_038',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'women_heroes',
      text: 'মুক্তিযুদ্ধে বীরত্বসূচক খেতাবপ্রাপ্ত দুই নারী মুক্তিযোদ্ধা কে কে?',

      options: [
        'ক্যাপ্টেন ডা. সেতারা বেগম ও তারামন বিবি (উভয়ে বীর প্রতীক)',
        'জাহানারা ইমাম ও সুফিয়া কামাল',
        'রোকেয়া সাখাওয়াত হোসেন ও প্রীতিলতা',
        'ফেরদৌসী প্রিয়ভাষিণী ও রমা চৌধুরী'
      ],
      answerIndex: 0,
      explanation: 'সেক্টর ২-এর ফিল্ড হাসপাতালের প্রধান ক্যাপ্টেন ডা. সেতারা বেগম এবং সেক্টর ১১-এর বীর যোদ্ধা তারামন বিবিকে বীর প্রতীক খেতাবে ভূষিত করা হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_039',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'foreign_friends',
      text: 'মুক্তিযুদ্ধে অনন্য অবদানের জন্য একমাত্র কোন বিদেশি নাগরিককে \'বীর প্রতীক\' খেতাবে ভূষিত করা হয়েছে?',

      options: ['ডব্লিউ এ এস ওডারল্যান্ড (অস্ট্রেলিয়া)', 'এডওয়ার্ড কেনেডি (যুক্তরাষ্ট্র)', 'মার্ক টালি (যুক্তরাজ্য)', 'আঁদ্রে মালরো (ফ্রান্স)'],
      answerIndex: 0,
      explanation: 'ডাচ-অস্ট্রেলিয়ান নাগরিক উইলিয়াম এ এস ওডারল্যান্ড ঢাকায় বাটা কোম্পানির ব্যবস্থাপনা পরিচালক ছিলেন। তিনি জীবনের ঝুঁকি নিয়ে মুক্তিযোদ্ধাদের অস্ত্র, তথ্য ও আশ্রয় দিয়েছিলেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),

    // --- Political Background & Chronology ---
    const Question(
      id: 'q_war_040',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'election_1970',
      text: '১৯৭০ সালের পাকিস্তানের জাতীয় পরিষদ নির্বাচনে পূর্ব পাকিস্তানের ১৬৯টি আসনের মধ্যে আওয়ামী লীগ কতটি আসনে জয়লাভ করেছিল?',

      options: ['১৬৭টি', '১৬০টি', '১৬৫টি', '১৬৯টি'],
      answerIndex: 0,
      explanation: 'আওয়ামী লীগ ১৬৯টি আসনের মধ্যে ১৬৭টিতে ঐতিহাসিক নিরঙ্কুশ বিজয় লাভ করে সমগ্র পাকিস্তানের জাতীয় পরিষদে একক সংখ্যাগরিষ্ঠতা অর্জন করে।',

      difficulty: 1,
      sources: [QuestionSource(name: 'The Daily Star', url: 'https://www.thedailystar.net/opinion/straight-line/news/71-years-awami-league-1918781')],
    ),
    const Question(
      id: 'q_war_041',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'march_7',
      text: 'ইউনেস্কো কত সালে বঙ্গবন্ধুর ঐতিহাসিক ৭ই মার্চের ভাষণকে \'মেমোরি অব দ্য ওয়ার্ল্ড ইন্টারন্যাশনাল রেজিস্টার\'-এ অন্তর্ভুক্ত করে বিশ্ব ঐতিহ্যের স্বীকৃতি দেয়?',

      options: ['২০১৭ সালে', '২০১৫ সালে', '২০১৬ সালে', '২০১৮ সালে'],
      answerIndex: 0,
      explanation: '২০১৭ সালের ৩০ অক্টোবর ইউনেস্কোর তৎকালীন মহাপরিচালক ইরিনা বোকোভা ঐতিহাসিক ৭ই মার্চের ভাষণকে আন্তর্জাতিক রেজিস্টারে অন্তর্ভুক্তির ঘোষণা দেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'UNESCO', url: 'https://www.unesco.org/en/memory-world/historic-7th-march-speech-bangabandhu-sheikh-mujibur-rahman')],
    ),
    const Question(
      id: 'q_war_042',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'crackdown',
      text: '২৫ মার্চ ১৯৭১ কালরাতে ঢাকা শহরসহ সারাদেশে নিরস্ত্র বাঙালির ওপর পরিচালিত সামরিক অভিযানের সাংকেতিক নাম কী ছিল?',

      options: ['অপারেশন সার্চলাইট', 'অপারেশন ব্লিজার্ড', 'অপারেশন পাইথন', 'অপারেশন ব্লুস্টার'],
      answerIndex: 0,
      explanation: 'জেনারেল টিক্কা খানের নির্দেশে পরিচালিত অপারেশন সার্চলাইটের মাধ্যমে রাজারবাগ পুলিশ লাইনস, পিলখানা ইপিআর ক্যাম্প ও ঢাকা বিশ্ববিদ্যালয়ে নারকীয় গণহত্যা চালানো হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_043',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'teliapara',
      text: '৪ এপ্রিল ১৯৭১ সালে কর্নেল ওসমানীসহ বাঙালি সেনা কর্মকর্তাদের ঐতিহাসিক সামরিক বৈঠক কোথায় অনুষ্ঠিত হয়?',

      options: ['তেলিয়াপাড়া চা বাগান (হবিগঞ্জ)', 'মেলাঘর', 'হরিণা', 'মুজিবনগর'],
      answerIndex: 0,
      explanation: 'হবিগঞ্জের মাধবপুর উপজেলার তেলিয়াপাড়া চা বাগানের ম্যানেজার বাংলোয় মুক্তিযুদ্ধের রণকৌশল প্রণয়ন ও প্রথম প্রতিরোধ সমন্বয় বৈঠক অনুষ্ঠিত হয়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_044',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'commanders_conference',
      text: '১৯৭১ সালের কত তারিখে ঐতিহাসিক সেক্টর কমান্ডারদের সম্মেলন অনুষ্ঠিত হয় যেখানে ১১টি সেক্টরের চূড়ান্ত অনুমোদন দেওয়া হয়?',

      options: ['১০–১৭ জুলাই ১৯৭১', '৪–৭ এপ্রিল ১৯৭১', '১০–১৫ আগস্ট ১৯৭১', '১–৭ সেপ্টেম্বর ১৯৭১'],
      answerIndex: 0,
      explanation: '১০ থেকে ১৭ জুলাই ১৯৭১ পর্যন্ত ৮ দিনব্যাপী ৮ নম্বর থিয়েটার রোডে অনুষ্ঠিত সেক্টর কমান্ডারদের সম্মেলনে মুক্তিযুদ্ধের সমন্বিত কাঠামো গঠিত হয়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),

    // --- International Context & Diplomacy ---
    const Question(
      id: 'q_war_045',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'international',
      text: '১৯৭১ সালের ১ আগস্ট নিউইয়র্কের ম্যাডিসন স্কয়ার গার্ডেনে বাংলাদেশের শরণার্থীদের সাহায্যে ঐতিহাসিক \'কনসার্ট ফর বাংলাদেশ\' কার উদ্যোগে আয়োজিত হয়?',

      options: ['পণ্ডিত রবি শংকর ও জর্জ হ্যারিসন', 'বব ডিলান ও জন লেনন', 'পল ম্যাকার্টনি ও এরিক ক্ল্যাপটন', 'মার্ক টুইন ও চার্লি চ্যাপলিন'],
      answerIndex: 0,
      explanation: 'সেতারবাদক পণ্ডিত রবি শংকরের অনুরোধে বিটলস তারকা জর্জ হ্যারিসন ৪০,০০০ দর্শকের সামনে ঐতিহাসিক এই কনসার্ট আয়োজন করেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'U.S. Department of State', url: 'https://history.state.gov/milestones/1969-1976/south-asia')],
    ),
    const Question(
      id: 'q_war_046',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'international',
      text: '১৯৭১ সালের ৯ আগস্ট কোন ঐতিহাসিক আন্তর্জাতিক চুক্তিটি স্বাক্ষরিত হয় যা বাংলাদেশের পক্ষে বিশ্বরাজনীতিতে অত্যন্ত শক্তিশালী ভূমিকা রাখে?',

      options: ['ভারত-সোভিয়েত মৈত্রী চুক্তি', 'শিমলা চুক্তি', 'তাশখন্দ চুক্তি', 'ওয়ারশ চুক্তি'],
      answerIndex: 0,
      explanation: 'ইন্দো-সোভিয়েত শান্তি ও মৈত্রী চুক্তি স্বাক্ষরিত হওয়ায় যুক্তরাষ্ট্র বা চীন সরাসরি পাকিস্তানের পক্ষে সামরিক হস্তক্ষেপ করতে পারেনি।',

      difficulty: 2,
      sources: [QuestionSource(name: 'U.S. Department of State', url: 'https://history.state.gov/milestones/1969-1976/south-asia')],
    ),
    const Question(
      id: 'q_war_047',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'international',
      text: 'মুক্তিযুদ্ধের শেষ পর্যায়ে পাকিস্তানের সমর্থনে বঙ্গোপসাগরের উদ্দেশ্যে প্রেরিত মার্কিন বিমানবাহী রণতরীর সপ্তম নৌবহরটির নাম কী ছিল?',

      options: ['ইউএসএস এন্টারপ্রাইজ (USS Enterprise)', 'ইউএসএস নিমিটজ', 'ইউএসএস আব্রাহাম লিংকন', 'ইউএসএস কার্ল ভিনসন'],
      answerIndex: 0,
      explanation: 'মার্কিন প্রেসিডেন্ট রিচার্ড নিক্সন ও হেনরি কিসিঞ্জার নিউক্লিয়ারচালিত ইউএসএস এন্টারপ্রাইজ প্রেরণ করেন, যাকে মোকাবিলা করতে সোভিয়েত ইউনিয়ন নিজস্ব নৌবহর পাঠায়।',

      difficulty: 2,
      sources: [QuestionSource(name: 'U.S. Department of State', url: 'https://history.state.gov/milestones/1969-1976/south-asia')],
    ),
    const Question(
      id: 'q_war_048',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'international',
      text: 'ঢাকায় নিযুক্ত তৎকালীন মার্কিন কনসাল জেনারেল পাকিস্তানি গণহত্যার তথ্য জানিয়ে হোয়াইট হাউসে যে প্রতিবাদী গোপন বার্তা পাঠান তা ইতিহাসে কী নামে পরিচিত?',

      options: ['ব্লাড টেলিগ্রাম (The Blood Telegram)', 'ঢাকা মেমোরেন্ডাম', 'হোয়াইট পেপার', 'মার্চ কেবল'],
      answerIndex: 0,
      explanation: 'কনসাল জেনারেল আর্চার ব্লাড পাকিস্তানি সেনাবাহিনীর বর্বর গণহত্যাকে সুস্পষ্টভাবে গণহত্যা উল্লেখ করে সাহসী ডিপ্লোম্যাটিক বার্তা পাঠান।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Foreign Relations of the United States', url: 'https://history.state.gov/historicaldocuments/frus1969-76ve07/ch2')],
    ),
    const Question(
      id: 'q_war_049',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'media',
      text: '২৫ মার্চের কালরাতে জীবনের ঝুঁকি নিয়ে ঢাকায় অবস্থান করে বিশ্ববাসীর কাছে প্রথম গণহত্যার খবর তুলে ধরা ব্রিটিশ সাংবাদিকের নাম কী?',

      options: ['সাইমন ড্রিং (Simon Dring)', 'মার্ক টালি', 'অ্যান্থনি মাসকারেনহাস', 'সিডনি শ্যানবার্গ'],
      answerIndex: 0,
      explanation: 'দ্য ডেইলি টেলিগ্রাফের সাংবাদিক সাইমন ড্রিং ইন্টারকন্টিনেন্টাল হোটেলে লুকিয়ে থেকে ৩০ মার্চ \'ট্যাংকস ক্রাশ রিভল্ট ইন পাকিস্তান\' শিরোনামে বিশ্ববাসীকে গণহত্যার বিবরণ জানান।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),

    // --- Final Campaign, Martyrs & Surrender ---
    const Question(
      id: 'q_war_050',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'joint_command',
      text: 'কত তারিখে মুক্তিবাহিনী ও ভারতীয় মিত্রবাহিনীর সমন্বয়ে আনুষ্ঠানিক যৌথ কমান্ড (Joint Command) গঠিত হয় এবং সরাসরি যুদ্ধ শুরু হয়?',

      options: ['৩ ডিসেম্বর ১৯৭১', '২৫ নভেম্বর ১৯৭১', '১০ ডিসেম্বর ১৯৭১', '৭ ডিসেম্বর ১৯৭১'],
      answerIndex: 0,
      explanation: '৩ ডিসেম্বর বিকেলে পাকিস্তান ভারতের বিমানঘাঁটিগুলোতে অতর্কিত আক্রমণ চালালে ভারত সরাসরি যুদ্ধে যোগ দেয় এবং যৌথ কমান্ড গঠিত হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Foreign Relations of the United States', url: 'https://history.state.gov/historicaldocuments/frus1969-76v11/d226')],
    ),
    const Question(
      id: 'q_war_051',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'intellectuals',
      text: 'পাকিস্তানি হানাদার বাহিনী ও তাদের দোসর আলবদররা কত তারিখে জাতির শ্রেষ্ঠ সূর্যসন্তান বুদ্ধিজীবীদের নির্মমভাবে হত্যা করে?',

      options: ['১৪ ডিসেম্বর ১৯৭১', '২৫ মার্চ ১৯৭১', '১৬ ডিসেম্বর ১৯৭১', '১০ ডিসেম্বর ১৯৭১'],
      answerIndex: 0,
      explanation: 'পরাজয় নিশ্চিত জেনে বাঙালি জাতিকে মেধাশূন্য করতে ১৪ ডিসেম্বর শিক্ষক, চিকিৎসক, সাংবাদিক ও সাহিত্যিকদের হত্যা করা হয়। প্রতি বছর এই দিনটিকে শহীদ বুদ্ধিজীবী দিবস হিসেবে পালন করা হয়।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_052',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'surrender',
      text: '১৯৭১ সালের ১৬ ডিসেম্বর পাকিস্তানি হানাদার বাহিনীর পক্ষে কে ঐতিহাসিক আত্মসমর্পণ দলিলে স্বাক্ষর করেন?',

      options: ['লেফটেন্যান্ট জেনারেল এ এ কে নিয়াজী', 'জেনারেল টিক্কা খান', 'জেনারেল ইয়াহিয়া খান', 'মেজর জেনারেল রাও ফরমান আলী'],
      answerIndex: 0,
      explanation: 'ঢাকার রেসকোর্স ময়দানে (সোহরাওয়ার্দী উদ্যান) যৌথবাহিনীর অধিনায়ক লেফটেন্যান্ট জেনারেল জগজিৎ সিং অরোরার কাছে আত্মসমর্পণ দলিলে স্বাক্ষর করেন পাকিস্তানি ইস্টার্ন কমান্ডের প্রধান আমির আব্দুল্লাহ খান নিয়াজী।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Bangladesh Navy', url: 'https://navy.mil.bd/About/honour.html')],
    ),
    const Question(
      id: 'q_war_053',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'surrender',
      text: '১৬ ডিসেম্বর ১৯৭১ ঐতিহাসিক আত্মসমর্পণ অনুষ্ঠানে বাংলাদেশ সরকারের প্রতিনিধিত্ব কে করেছিলেন?',

      options: ['গ্রুপ ক্যাপ্টেন এ কে খন্দকার', 'কর্নেল এম এ জি ওসমানী', 'তাজউদ্দীন আহমদ', 'মেজর জিয়াউর রহমান'],
      answerIndex: 0,
      explanation: 'মুক্তিযুদ্ধের উপ-প্রধান সেনাপতি গ্রুপ ক্যাপ্টেন এ কে খন্দকার আত্মসমর্পণ অনুষ্ঠানে বাংলাদেশ সরকারের পক্ষ থেকে আনুষ্ঠানিক প্রতিনিধিত্ব করেন।',

      difficulty: 1,
      sources: [QuestionSource(name: 'Banglapedia', url: 'https://en.banglapedia.org/index.php/War_of_Liberation,_The')],
    ),
    const Question(
      id: 'q_war_054',
      kind: 'static',
      topic: 'bd_liberation_war',
      subtopic: 'return',
      text: 'স্বাধীনতার পর মুজিবনগর সরকার কত তারিখে আনুষ্ঠানিকভাবে ঢাকায় প্রত্যাবর্তন করে শাসনভার গ্রহণ করে?',

      options: ['২২ ডিসেম্বর ১৯৭১', '১৬ ডিসেম্বর ১৯৭১', '১০ জানুয়ারি ১৯৭২', '২৫ ডিসেম্বর ১৯৭১'],
      answerIndex: 0,
      explanation: '২২ ডিসেম্বর ১৯৭১ তারিখে সৈয়দ নজরুল ইসলাম ও তাজউদ্দীন আহমদের নেতৃত্বে মুজিবনগর সরকার আনুষ্ঠানিকভাবে ঢাকায় ফিরে এসে প্রশাসনিক দায়িত্ব গ্রহণ করে।',

      difficulty: 2,
      sources: [QuestionSource(name: 'Liberation War Museum', url: 'https://www.liberationwarmuseumbd.org/page/history')],
    ),

    // =========================================================================
    // ২. বাংলাদেশের ইতিহাস (bd_history)
    // =========================================================================
    const Question(
      id: 'q_his_001',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'ancient',
      text: 'প্রাচীন বাংলার প্রথম স্বাধীন ও সার্বভৌম নরপতি কে ছিলেন?',

      options: ['শশাঙ্ক', 'ধর্মপাল', 'গোপাল', 'লক্ষ্মণ সেন'],
      answerIndex: 0,
      explanation: 'রাজা শশাঙ্ক সপ্তম শতকে স্বাধীন গৌড় রাজ্য প্রতিষ্ঠা করেন এবং তিনি ছিলেন প্রাচীন বাংলার প্রথম স্বাধীন সার্বভৌম নরপতি।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_002',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'pala_dynasty',
      text: 'বাংলার দীর্ঘতম স্থায়ী পাল বংশের প্রতিষ্ঠাতা কে?',

      options: ['দেবপাল', 'ধর্মপাল', 'গোপাল', 'মহীপাল'],
      answerIndex: 2,
      explanation: 'মাৎস্যন্যায় অবসান ঘটিয়ে অষ্টম শতকে গোপাল পাল রাজবংশ প্রতিষ্ঠা করেন, যা প্রায় চারশত বছর টিকে ছিল।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_003',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'muslim_rule',
      text: 'ইখতিয়ার উদ্দিন মুহম্মদ বখতিয়ার খলজি কত সালে বাংলা বিজয় করেন?',

      options: ['১২০৪ সালে', '১২০৬ সালে', '১২০২ সালে', '১২১০ সালে'],
      answerIndex: 0,
      explanation: '১২০৪ সালে মাত্র ১৮ জন অশ্বারোহী নিয়ে বখতিয়ার খলজি লক্ষণাবতী ও নদীয়া জয় করে বাংলায় মুসলিম শাসনের সূচনা করেন।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_004',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'language_movement',
      text: 'ইউনেস্কো কত সালে ২১শে ফেব্রুয়ারিকে আন্তর্জাতিক মাতৃভাষা দিবস হিসেবে ঘোষণা করে?',

      options: ['১৯৯৭ সালে', '১৯৯৮ সালে', '১৯৯৯ সালে', '২০০০ সালে'],
      answerIndex: 2,
      explanation: '১৯৯৯ সালের ১৭ নভেম্বর ইউনেস্কোর ৩০তম সাধারণ অধিবেশনে ২১শে ফেব্রুয়ারিকে আন্তর্জাতিক মাতৃভাষা দিবস হিসেবে স্বীকৃতি দেওয়া হয়।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_005',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'six_points',
      text: 'ঐতিহাসিক ৬ দফা কর্মসূচি কোথায় আনুষ্ঠানিকভাবে ঘোষণা করা হয়েছিল?',

      options: ['ঢাকায়', 'লাহোরে', 'করাচিতে', 'চট্টগ্রামে'],
      answerIndex: 1,
      explanation: '১৯৬৬ সালের ফেব্রুয়ারি মাসে পাকিস্তানের লাহোরে অনুষ্ঠিত বিরোধী দলীয় সম্মেলনে শেখ মুজিবুর রহমান ঐতিহাসিক ছয় দফা পেশ করেন।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_006',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'british_rule',
      text: 'ঐতিহাসিক পলাশীর যুদ্ধ কত তারিখে সংঘটিত হয়?',

      options: ['২৩ জুন ১৭৫৭', '২৩ মে ১৭৫৭', '১৬ ডিসেম্বর ১৭৫৭', '১৪ আগস্ট ১৭৫৭'],
      answerIndex: 0,
      explanation: '১৭৫৭ সালের ২৩ জুন ভাগীরথী নদীর তীরে পলাশীর আম্রকাননে নবাব সিরাজউদ্দৌলা ও রবার্ট ক্লাইভের মধ্যে পলাশীর যুদ্ধ হয়।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_his_007',
      kind: 'static',
      topic: 'bd_history',
      subtopic: 'mass_uprising',
      text: '১৯৬৯ সালের গণঅভ্যুত্থানে শহীদ হন ঢাকা বিশ্ববিদ্যালয়ের কোন শিক্ষক?',

      options: ['ড. মুহম্মদ শহীদুল্লাহ', 'ড. শামসুজ্জোহা', 'ড. গোবিন্দ চন্দ্র দেব', 'অধ্যাপক মুনীর চৌধুরী'],
      answerIndex: 1,
      explanation: 'ড. শামসুজ্জোহা ছিলেন রাজশাহী বিশ্ববিদ্যালয়ের রসায়ন বিভাগের শিক্ষক, যিনি ১৯৬৯ সালের ১৮ ফেব্রুয়ারি ছাত্রদের রক্ষা করতে গিয়ে শহীদ হন।',

      difficulty: 2,
    ),

    // =========================================================================
    // ৩. সংবিধান ও সরকার (bd_constitution)
    // =========================================================================
    const Question(
      id: 'q_con_001',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'articles',
      text: 'গণপ্রজাতন্ত্রী বাংলাদেশের সংবিধান কত তারিখে কার্যকর হয়?',

      options: ['৪ নভেম্বর ১৯৭২', '১৬ ডিসেম্বর ১৯৭২', '২৬ মার্চ ১৯৭২', '১০ জানুয়ারি ১৯৭৩'],
      answerIndex: 1,
      explanation: 'সংবিধান গণপরিষদে গৃহীত হয় ৪ নভেম্বর ১৯৭২ এবং কার্যকর হয় প্রথম বিজয় দিবস ১৬ ডিসেম্বর ১৯৭২ থেকে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_con_002',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'articles',
      text: 'বাংলাদেশের সংবিধানে মোট কতটি অনুচ্ছেদ ও তফসিল রয়েছে?',

      options: ['১৫৩টি অনুচ্ছেদ ও ৭টি তফসিল', '১৪২টি অনুচ্ছেদ ও ৫টি তফসিল', '১৫০টি অনুচ্ছেদ ও ৮টি তফসিল', '১৬২টি অনুচ্ছেদ ও ৪টি তফসিল'],
      answerIndex: 0,
      explanation: 'বাংলাদেশের সংবিধানে ১১টি ভাগ, ১৫৩টি অনুচ্ছেদ এবং ৭টি তফসিল বিদ্যমান।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_con_003',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'fundamental_rights',
      text: 'সংবিধানের কত নম্বর অনুচ্ছেদ অনুযায়ী "আইনের দৃষ্টিতে সকল নাগরিক সমান"?',

      options: ['অনুচ্ছেদ ২৭', 'অনুচ্ছেদ ৩১', 'অনুচ্ছেদ ২৮', 'অনুচ্ছেদ ৩২'],
      answerIndex: 0,
      explanation: 'সংবিধানের তৃতীয় ভাগের ২৭ নম্বর অনুচ্ছেদে বলা হয়েছে: "সকল নাগরিক আইনের দৃষ্টিতে সমান এবং আইনের সমান আশ্রয় লাভের অধিকারী।"',

      difficulty: 2,
    ),
    const Question(
      id: 'q_con_004',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'drafting',
      text: 'বাংলাদেশের সংবিধান প্রণয়ন কমিটির সভাপতি কে ছিলেন?',

      options: ['ড. কামাল হোসেন', 'সৈয়দ নজরুল ইসলাম', 'তাজউদ্দীন আহমদ', 'আব্দুর রাজ্জাক'],
      answerIndex: 0,
      explanation: '১৯৭২ সালে গঠিত ৩৪ সদস্যের খসড়া সংবিধান প্রণয়ন কমিটির সভাপতি ছিলেন ড. কামাল হোসেন।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_con_005',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'state_language',
      text: 'সংবিধানের কত অনুচ্ছেদ অনুযায়ী প্রজাতন্ত্রের রাষ্ট্রভাষা বাংলা?',

      options: ['অনুচ্ছেদ ১', 'অনুচ্ছেদ ২', 'অনুচ্ছেদ ৩', 'অনুচ্ছেদ ৪'],
      answerIndex: 2,
      explanation: 'সংবিধানের ১ম ভাগের ৩ নম্বর অনুচ্ছেদে বলা হয়েছে: "প্রজাতন্ত্রের রাষ্ট্রভাষা বাংলা।"',

      difficulty: 1,
    ),
    const Question(
      id: 'q_con_006',
      kind: 'static',
      topic: 'bd_constitution',
      subtopic: 'parliament',
      text: 'জাতীয় সংসদে সংরক্ষিত নারী আসনের সংখ্যা কতটি?',

      options: ['৩০টি', '৪৫টি', '৫০টি', '৬০টি'],
      answerIndex: 2,
      explanation: 'সংবিধানের ৬৫(৩) অনুচ্ছেদ অনুযায়ী বর্তমানে জাতীয় সংসদে ৫০টি সংরক্ষিত নারী আসন রয়েছে।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৪. ভূগোল ও পরিবেশ (bd_geography)
    // =========================================================================
    const Question(
      id: 'q_geo_001',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'rivers',
      text: 'ব্রহ্মপুত্র নদ বাংলাদেশে প্রবেশের পর প্রধান ধারাটি কোন নামে যমুনায় মিলিত হয়েছে?',

      options: ['তিস্তা', 'যমুনা', 'মেঘনা', 'পদ্মা'],
      answerIndex: 1,
      explanation: '১৭৮৭ সালের ভূমিকম্পে ব্রহ্মপুত্রের গতিপথ পরিবর্তিত হয়ে নতুন যে প্রধান ধারাটি তৈরি হয়, তা যমুনা নামে পরিচিত।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_geo_002',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'hills',
      text: 'বাংলাদেশের সর্বোচ্চ পর্বতশৃঙ্গ কোনটি?',

      options: ['কেওক্রাডং', 'তাজিংডং (বিজয়)', 'মোদক মুয়াল', 'গারো পাহাড়'],
      answerIndex: 1,
      explanation: 'বান্দরবানের রুমা উপজেলায় অবস্থিত তাজিংডং বা বিজয় বাংলাদেশের সর্বোচ্চ পর্বতশৃঙ্গ (উচ্চতা প্রায় ১,২৮০ মিটার)।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_geo_003',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'islands',
      text: 'বাংলাদেশের একমাত্র প্রবাল দ্বীপ কোনটি?',

      options: ['মহেশখালী', 'সেন্টমার্টিন', 'হাতিয়া', 'মনপুরা'],
      answerIndex: 1,
      explanation: 'সেন্টমার্টিন (নারিকেল জিঞ্জিরা) বঙ্গোপসাগরের উত্তর-পূর্বাংশে অবস্থিত বাংলাদেশের একমাত্র সামুদ্রিক প্রবাল দ্বীপ।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_geo_004',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'forests',
      text: 'সুন্দরবনকে ইউনেস্কো কত সালে বিশ্ব ঐতিহ্য এলাকা (World Heritage Site) হিসেবে ঘোষণা করে?',

      options: ['১৯৯৭ সালে', '১৯৯৯ সালে', '১৯৮৭ সালে', '২০০১ সালে'],
      answerIndex: 0,
      explanation: '১৯৯৭ সালের ৬ ডিসেম্বর ইউনেস্কো সুন্দরবনকে ৭৯৮তম বিশ্ব ঐতিহ্যবাহী স্থান হিসেবে স্বীকৃতি প্রদান করে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_geo_005',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'borders',
      text: 'বাংলাদেশের সাথে কয়টি দেশের আন্তর্জাতিক সীমান্ত রয়েছে?',

      options: ['১টি', '২টি', '৩টি', '৪টি'],
      answerIndex: 1,
      explanation: 'বাংলাদেশের সীমান্ত দুটি দেশের সাথে সংযুক্ত: ভারত (পশ্চিমে, উত্তরে ও পূর্বে) এবং মিয়ানমার (দক্ষিণ-পূর্বে)।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_geo_006',
      kind: 'static',
      topic: 'bd_geography',
      subtopic: 'ramsar',
      text: 'টাঙ্গুয়ার হাওর কোন জেলায় অবস্থিত?',

      options: ['সিলেট', 'সুনামগঞ্জ', 'মৌলভীবাজার', 'হবিগঞ্জ'],
      answerIndex: 1,
      explanation: 'সুনামগঞ্জের তাহিরপুর ও ধর্মপাশা উপজেলায় অবস্থিত টাঙ্গুয়ার হাওর বাংলাদেশের দ্বিতীয় রামসার সাইট।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৫. অর্থনীতি ও অবকাঠামো (bd_economy)
    // =========================================================================
    const Question(
      id: 'q_eco_001',
      kind: 'static',
      topic: 'bd_economy',
      subtopic: 'padma_bridge',
      text: 'পদ্মা সেতুর মূল দৈর্ঘ্য কত কিলোমিটার?',

      options: ['৬.১৫ কিমি', '৫.৮০ কিমি', '৭.২০ কিমি', '৬.৫০ কিমি'],
      answerIndex: 0,
      explanation: 'মুন্সীগঞ্জের মাওয়া ও শরীয়তপুরের জাজিরাকে সংযোগকারী পদ্মা সেতুর মূল দৈর্ঘ্য ৬.১৫ কিলোমিটার এবং মোট ৪১টি স্প্যান রয়েছে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_eco_002',
      kind: 'static',
      topic: 'bd_economy',
      subtopic: 'metro_rail',
      text: 'বাংলাদেশের প্রথম মেট্রো রেল (MRT Line-6) কোন রুটে চলাচল করে?',

      options: ['উত্তরা থেকে মতিঝিল', 'কমলাপুর থেকে বিমানবন্দর', 'গাবতলী থেকে আফতাবনগর', 'মিরপুর থেকে সদরঘাট'],
      answerIndex: 0,
      explanation: 'এমআরটি লাইন-৬ উত্তরার দিয়াবাড়ী থেকে মতিঝিল হয়ে কমলাপুর পর্যন্ত বিস্তৃত।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_eco_003',
      kind: 'static',
      topic: 'bd_economy',
      subtopic: 'tunnel',
      text: 'বঙ্গবন্ধু শেখ মুজিবুর রহমান টানেল কোন নদীর তলদেশে নির্মিত?',

      options: ['পদ্মা নদী', 'মেঘনা নদী', 'কর্ণফুলী নদী', 'যমুনা নদী'],
      answerIndex: 2,
      explanation: 'চট্টগ্রামের কর্ণফুলী নদীর তলদেশে নির্মিত এই টানেলটি দক্ষিণ এশিয়ার নদীর তলদেশে প্রথম টানেল।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_eco_004',
      kind: 'static',
      topic: 'bd_economy',
      subtopic: 'nuclear',
      text: 'রূপপুর পারমাণবিক বিদ্যুৎ কেন্দ্র কোন জেলায় অবস্থিত?',

      options: ['পাবনা', 'কুষ্টিয়া', 'নাটোর', 'সিরাজগঞ্জ'],
      answerIndex: 0,
      explanation: 'পাবনা জেলার ঈশ্বরদী উপজেলার রূপপুরে রাশিয়ার সহায়তায় রূপপুর পারমাণবিক বিদ্যুৎ কেন্দ্র নির্মিত হচ্ছে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_eco_005',
      kind: 'static',
      topic: 'bd_economy',
      subtopic: 'central_bank',
      text: 'বাংলাদেশ ব্যাংকের বর্তমান প্রধান কার্যালয় কোথায় অবস্থিত?',

      options: ['মতিঝিল, ঢাকা', 'কারওয়ান বাজার, ঢাকা', 'আগ্রাবাদ, চট্টগ্রাম', 'গুলশান, ঢাকা'],
      answerIndex: 0,
      explanation: 'বাংলাদেশের কেন্দ্রীয় ব্যাংক বাংলাদেশ ব্যাংক ১৯৭১ সালের ১৬ ডিসেম্বর প্রতিষ্ঠিত হয় এবং এর প্রধান কার্যালয় মতিঝিলে অবস্থিত।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৬. সংস্কৃতি, ঐতিহ্য ও ক্রীড়া (bd_culture_sports)
    // =========================================================================
    const Question(
      id: 'q_cul_001',
      kind: 'static',
      topic: 'bd_culture_sports',
      subtopic: 'unesco',
      text: 'ইউনেস্কোর ইনট্যানজিবল কালচারাল হেরিটেজ হিসেবে কোনটি স্বীকৃতি পেয়েছে?',

      options: ['বাউল গান', 'জামদানি শাড়ি বয়ন', 'মঙ্গল শোভাযাত্রা', 'সবগুলোই'],
      answerIndex: 3,
      explanation: 'ইউনেস্কো বাউল গান (২০০৫), জামদানি (২০১৩), শীতলপাটি (২০১৭), মঙ্গল শোভাযাত্রা (২০১৬) এবং ঢাকার রিকশাচিত্রকে বিশ্ব ঐতিহ্যের স্বীকৃতি দিয়েছে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_cul_002',
      kind: 'static',
      topic: 'bd_culture_sports',
      subtopic: 'national_symbols',
      text: 'বাংলাদেশের জাতীয় কবি কে?',

      options: ['রবীন্দ্রনাথ ঠাকুর', 'কাজী নজরুল ইসলাম', 'জসীম উদ্দীন', 'জীবনানন্দ দাশ'],
      answerIndex: 1,
      explanation: 'বিদ্রোহী কবি কাজী নজরুল ইসলাম বাংলাদেশের জাতীয় কবি। ১৯৭২ সালে তাঁকে বাংলাদেশে এনে নাগরিকত্ব প্রদান করা হয়।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_cul_003',
      kind: 'static',
      topic: 'bd_culture_sports',
      subtopic: 'sports',
      text: 'বাংলাদেশ টেস্ট ক্রিকেটের মর্যাদা লাভ করে কত সালে?',

      options: ['১৯৯৭ সালে', '১৯৯৯ সালে', '২০০০ সালে', '২০০২ সালে'],
      answerIndex: 2,
      explanation: '২০০০ সালের ২৬ জুন বাংলাদেশ দশম টেস্ট খেলুড়ে দেশ হিসেবে আন্তর্জাতিক ক্রিকেট কাউন্সিলের (ICC) পূর্ণ সদস্য পদ লাভ করে।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_cul_004',
      kind: 'static',
      topic: 'bd_culture_sports',
      subtopic: 'monuments',
      text: 'সাভারের জাতীয় স্মৃতিসৌধের স্থপতি কে?',

      options: ['মাইনুল হোসেন', 'হামিদুর রহমান', 'শামীম শিকদার', 'মুস্তফা মনোয়ার'],
      answerIndex: 0,
      explanation: 'জাতীয় স্মৃতিসৌধের সাতটি ফলকের নকশাকার ও প্রধান স্থপতি ছিলেন সৈয়দ মাইনুল হোসেন।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_cul_005',
      kind: 'static',
      topic: 'bd_culture_sports',
      subtopic: 'shaheed_minar',
      text: 'কেন্দ্রীয় শহীদ মিনারের মূল নকশাকার কে ছিলেন?',

      options: ['হামিদুর রহমান', 'জয়নুল আবেদিন', 'নিতুন কুণ্ডু', 'ভাস্কর নভেরা আহমেদ'],
      answerIndex: 0,
      explanation: 'শিল্পী হামিদুর রহমান কেন্দ্রীয় শহীদ মিনারের মূল নকশা প্রণয়ন করেন এবং এতে ভাস্কর নভেরা আহমেদও ভূমিকা রাখেন।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৭. আন্তর্জাতিক সংস্থা (intl_orgs)
    // =========================================================================
    const Question(
      id: 'q_org_001',
      kind: 'static',
      topic: 'intl_orgs',
      subtopic: 'who',
      text: 'বিশ্ব স্বাস্থ্য সংস্থা (WHO)-এর সদর দপ্তর কোথায় অবস্থিত?',

      options: ['নিউইয়র্ক, যুক্তরাষ্ট্র', 'জেনেভা, সুইজারল্যান্ড', 'প্যারিস, ফ্রান্স', 'লন্ডন, যুক্তরাজ্য'],
      answerIndex: 1,
      explanation: '১৯৪৮ সালের ৭ এপ্রিল প্রতিষ্ঠিত বিশ্ব স্বাস্থ্য সংস্থার (WHO) সদর দপ্তর সুইজারল্যান্ডের জেনেভায় অবস্থিত।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_org_002',
      kind: 'static',
      topic: 'intl_orgs',
      subtopic: 'un',
      text: 'জাতিসংঘ আনুষ্ঠানিকভাবে কত তারিখে প্রতিষ্ঠিত হয়?',

      options: ['২৪ অক্টোবর ১৯৪৫', '১০ ডিসেম্বর ১৯৪৮', '১৫ আগস্ট ১৯৪৫', '১ জানুয়ারি ১৯৪২'],
      answerIndex: 0,
      explanation: '১৯৪৫ সালের ২৪ অক্টোবর সান ফ্রান্সিসকো সম্মেলনের পর জাতিসংঘ সনদ কার্যকর হয় এবং প্রতি বছর ২৪ অক্টোবর জাতিসংঘ দিবস পালিত হয়।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_org_003',
      kind: 'static',
      topic: 'intl_orgs',
      subtopic: 'saarc',
      text: 'দক্ষিণ এশীয় আঞ্চলিক সহযোগিতা সংস্থা (SAARC)-এর সদর দপ্তর কোথায়?',

      options: ['ঢাকা, বাংলাদেশ', 'নতুন দিল্লি, ভারত', 'কাঠমান্ডু, নেপাল', 'কলম্বো, শ্রীলঙ্কা'],
      answerIndex: 2,
      explanation: '১৯৮৫ সালে ঢাকায় সার্ক প্রতিষ্ঠিত হলেও এর স্থায়ী সচিবালয় নেপালের রাজধানী কাঠমান্ডুতে অবস্থিত।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_org_004',
      kind: 'static',
      topic: 'intl_orgs',
      subtopic: 'red_cross',
      text: 'আন্তর্জাতিক রেড ক্রস কমিটি (ICRC)-এর প্রতিষ্ঠাতা কে?',

      options: ['অঁরি ডুনান্ট', 'ফ্লোরেন্স নাইটিঙ্গেল', 'মাদার তেরেসা', 'নেলসন ম্যান্ডেলা'],
      answerIndex: 0,
      explanation: '১৮৬৩ সালে সুইজারল্যান্ডের জঁ অঁরি ডুনান্ট রেড ক্রস প্রতিষ্ঠা করেন এবং তিনি শান্তিতে প্রথম নোবেল পুরস্কার পান।',

      difficulty: 2,
    ),
    const Question(
      id: 'q_org_005',
      kind: 'static',
      topic: 'intl_orgs',
      subtopic: 'unicef',
      text: 'ইউনিসেফ (UNICEF)-এর সদর দপ্তর কোথায়?',

      options: ['জেনেভা', 'প্যারিস', 'নিউইয়র্ক', 'ভিয়েনা'],
      answerIndex: 2,
      explanation: 'জাতিসংঘ শিশু তহবিল (UNICEF) শিশুদের অধিকার ও কল্যাণে কাজ করে এবং এর সদর দপ্তর নিউইয়র্কে অবস্থিত।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৮. বিশ্ব ভূগোল (intl_geography)
    // =========================================================================
    const Question(
      id: 'q_igeo_001',
      kind: 'static',
      topic: 'intl_geography',
      subtopic: 'straits',
      text: 'জিব্রাল্টার প্রণালী কোন দুটি জলভাগকে সংযুক্ত করেছে?',

      options: ['আটলান্টিক মহাসাগর ও ভূমধ্যসাগর', 'লোহিত সাগর ও ভূমধ্যসাগর', 'ভারত মহাসাগর ও প্রশান্ত মহাসাগর', 'কৃষ্ণসাগর ও মারমারা সাগর'],
      answerIndex: 0,
      explanation: 'জিব্রাল্টার প্রণালী আটলান্টিক মহাসাগরের সাথে ভূমধ্যসাগরকে যুক্ত করেছে এবং ইউরোপ (স্পেন) থেকে আফ্রিকাকে (মরক্কো) পৃথক করেছে।',

      difficulty: 2,
    ),
    const Question(
      id: 'q_igeo_002',
      kind: 'static',
      topic: 'intl_geography',
      subtopic: 'oceans',
      text: 'পৃথিবীর গভীরতম খাতের নাম কী?',

      options: ['সুন্দা খাত', 'মারিয়ানা ট্রেঞ্চ', 'পুয়ের্তো রিকো খাত', 'জাভা খাত'],
      answerIndex: 1,
      explanation: 'প্রশান্ত মহাসাগরে অবস্থিত মারিয়ানা ট্রেঞ্চের চ্যালেঞ্জার ডিপ হলো পৃথিবীর গভীরতম স্থান (গভীরতা প্রায় ১১,০৩৪ মিটার)।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_igeo_003',
      kind: 'static',
      topic: 'intl_geography',
      subtopic: 'capitals',
      text: 'অস্ট্রেলিয়ার রাজধানীর নাম কী?',

      options: ['সিডনি', 'মেলবোর্ন', 'ক্যানবেরা', 'ব্রিসবেন'],
      answerIndex: 2,
      explanation: 'অস্ট্রেলিয়ার ফেডারেল রাজধানী হলো ক্যানবেরা (সিডনি বা মেলবোর্ন নয়)।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_igeo_004',
      kind: 'static',
      topic: 'intl_geography',
      subtopic: 'canals',
      text: 'সুয়েজ খাল কোন দুটি সাগরকে যুক্ত করেছে?',

      options: ['ভূমধ্যসাগর ও লোহিত সাগর', 'বাল্টিক সাগর ও উত্তর সাগর', 'কৃষ্ণসাগর ও ভূমধ্যসাগর', 'আরব সাগর ও কাস্পিয়ান সাগর'],
      answerIndex: 0,
      explanation: 'মিশরের সুয়েজ খাল ১৮৬৯ সালে উন্মুক্ত করা হয়, যা ভূমধ্যসাগরের সাথে লোহিত সাগরকে সরাসরি যুক্ত করেছে।',

      difficulty: 1,
    ),

    // =========================================================================
    // ৯. চুক্তি, সম্মেলন ও ঐতিহাসিক ঘটনা (intl_treaties)
    // =========================================================================
    const Question(
      id: 'q_tre_001',
      kind: 'static',
      topic: 'intl_treaties',
      subtopic: 'geneva',
      text: 'যুদ্ধাহত সৈনিক ও বন্দীদের সুরক্ষায় বিখ্যাত জেনেভা কনভেনশন প্রথম স্বাক্ষরিত হয় কত সালে?',

      options: ['১৮৬৪ সালে', '১৯১৯ সালে', '১৯৪৫ সালে', '১৯৪৯ সালে'],
      answerIndex: 0,
      explanation: 'প্রথম জেনেভা কনভেনশন ১৮৬৪ সালে গৃহীত হয় এবং আধুনিক চারটি কনভেনশন ১৯৪৯ সালে চূড়ান্ত রূপ লাভ করে।',

      difficulty: 2,
    ),
    const Question(
      id: 'q_tre_002',
      kind: 'static',
      topic: 'intl_treaties',
      subtopic: 'climate',
      text: '২০১৫ সালের ঐতিহাসিক প্যারিস জলবায়ু চুক্তির মূল লক্ষ্য কী ছিল?',

      options: [
        'বৈশ্বিক গড় তাপমাত্রা বৃদ্ধি ২°C-এর নিচে এবং ১.৫°C-এ সীমাবদ্ধ রাখা',
        'সকল পরমাণু বিদ্যুৎ কেন্দ্র বন্ধ করা',
        'ওজন স্তরের ব্যবহার সম্পূর্ণরূপে নিষিদ্ধ করা',
        'সৌর প্যানেল ফ্রি বিতরণ করা'
      ],
      answerIndex: 0,
      explanation: 'প্যারিস চুক্তির লক্ষ্য প্রাক-শিল্পায়ন যুগের তুলনায় বৈশ্বিক উষ্ণতা ২ ডিগ্রি সেলসিয়াসের নিচে ও যথাসম্ভব ১.৫ ডিগ্রিতে সীমিত রাখা।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_tre_003',
      kind: 'static',
      topic: 'intl_treaties',
      subtopic: 'world_war',
      text: 'প্রথম বিশ্বযুদ্ধের সমাপ্তি ঘটে কোন ঐতিহাসিক চুক্তির মাধ্যমে?',

      options: ['ভার্সাই চুক্তি', 'রোম চুক্তি', 'ক্যাম্প ডেভিড চুক্তি', 'মাস্ত্রিচ চুক্তি'],
      answerIndex: 0,
      explanation: '১৯১৯ সালের ২৮ জুন ফ্রান্সের ভার্সাই রাজপ্রাসাদে মিত্রশক্তি ও জার্মানির মধ্যে ভার্সাই চুক্তি স্বাক্ষরের মাধ্যমে প্রথম বিশ্বযুদ্ধের আনুষ্ঠানিক সমাপ্তি হয়।',

      difficulty: 1,
    ),

    // =========================================================================
    // ১০. নোবেল, বিশ্বনেতা ও সমসাময়িক ঘটনা (intl_people_events)
    // =========================================================================
    const Question(
      id: 'q_peo_001',
      kind: 'static',
      topic: 'intl_people_events',
      subtopic: 'nobel',
      text: 'চিকিৎসাবিজ্ঞানে পেনিসিলিন আবিষ্কারের জন্য কে নোবেল পুরস্কার পান?',

      options: ['আলেকজান্ডার ফ্লেমিং', 'লুই পাস্তুর', 'এডওয়ার্ড জেনার', 'রবার্ট কচ'],
      answerIndex: 0,
      explanation: 'স্যার আলেকজান্ডার ফ্লেমিং ১৯২৮ সালে পেনিসিলিন আবিষ্কার করেন এবং ১৯৪৫ সালে আর্নেস্ট চেইন ও হাওয়ার্ড ফ্লোরির সাথে যৌথভাবে চিকিৎসাবিজ্ঞানে নোবেল লাভ করেন।',

      difficulty: 1,
    ),
    const Question(
      id: 'q_peo_002',
      kind: 'static',
      topic: 'intl_people_events',
      subtopic: 'nobel',
      text: 'চিকিৎসাবিজ্ঞানে প্রথম নোবেল পুরস্কার বিজয়ী বিজ্ঞানী কে ছিলেন?',

      options: ['এমিল ভন বেরিং', 'রবার্ট কচ', 'আইভান পাভলভ', 'উইলহেম রন্টজেন'],
      answerIndex: 0,
      explanation: '১৯০১ সালে ডিপথেরিয়ার সিরাম থেরাপির সফল আবিষ্কারের জন্য জার্মান বিজ্ঞানী এমিল ভন বেরিং চিকিৎসায় প্রথম নোবেল পান।',

      difficulty: 2,
    ),
    const Question(
      id: 'q_peo_003',
      kind: 'static',
      topic: 'intl_people_events',
      subtopic: 'leaders',
      text: 'জাতিসংঘের বর্তমান নবম মহাসচিব অ্যান্টনিও গুতেরেস কোন দেশের নাগরিক?',

      options: ['পর্তুগাল', 'স্পেন', 'দক্ষিণ কোরিয়া', 'ঘানা'],
      answerIndex: 0,
      explanation: 'অ্যান্টনিও গুতেরেস পর্তুগালের সাবেক প্রধানমন্ত্রী ছিলেন এবং ২০১৭ সাল থেকে জাতিসংঘের মহাসচিব হিসেবে দায়িত্ব পালন করছেন।',

      difficulty: 1,
    ),

    // =========================================================================
    // ১১. সাম্প্রতিক (জাতীয়) (recent_national)
    // =========================================================================
    const Question(
      id: 'q_rec_001',
      kind: 'current',
      topic: 'recent_national',
      subtopic: 'infrastructure',
      text: 'বাংলাদেশের প্রথম ভূগর্ভস্থ মেট্রো রেল কোনটি?',

      options: ['MRT Line-1', 'MRT Line-5', 'MRT Line-6', 'MRT Line-2'],
      answerIndex: 0,
      explanation: 'বিমানবন্দর থেকে কমলাপুর পর্যন্ত নির্মাণাধীন এমআরটি লাইন-১ বাংলাদেশের প্রথম পাতাল বা আন্ডারগ্রাউন্ড মেট্রো রেল।',

      difficulty: 1,
      eventDate: '2026-09-15',
      sources: [QuestionSource(name: 'ঢাকা ম্যাস ট্রানজিট কোম্পানি (DMTCL)', url: 'https://dmtcl.gov.bd')],
    ),
    const Question(
      id: 'q_rec_002',
      kind: 'current',
      topic: 'recent_national',
      subtopic: 'health',
      text: 'বাংলাদেশে কালাজ্বর নির্মূলের ঐতিহাসিক স্বীকৃতির জন্য কোন সংস্থা আনুষ্ঠানিকভাবে সনদ প্রদান করেছে?',

      options: ['WHO (বিশ্ব স্বাস্থ্য সংস্থা)', 'UNICEF', 'CDC', 'UNESCO'],
      answerIndex: 0,
      explanation: 'বিশ্ব স্বাস্থ্য সংস্থা (WHO) ২০২৩-২৪ সেশনে বিশ্বব্যাপী প্রথম দেশ হিসেবে বাংলাদেশকে কালাজ্বর মুক্ত দেশ ঘোষণা করেছে।',

      difficulty: 1,
      eventDate: '2026-08-20',
      sources: [QuestionSource(name: 'WHO Bangladesh', url: 'https://who.int/bangladesh')],
    ),
    const Question(
      id: 'q_rec_003',
      kind: 'current',
      topic: 'recent_national',
      subtopic: 'ports',
      text: 'বাংলাদেশের প্রথম গভীর সমুদ্রবন্দর কোন জেলায় নির্মিত হয়েছে?',

      options: ['কক্সবাজার', 'চট্টগ্রাম', 'পটুয়াখালী', 'বাগেরহাট'],
      answerIndex: 0,
      explanation: 'কক্সবাজার জেলার মহেশখালী উপজেলার মাতারবাড়ীতে জাপান আন্তর্জাতিক সহযোগিতা সংস্থা (JICA)-এর সহায়তায় গভীর সমুদ্রবন্দর নির্মিত হয়েছে।',

      difficulty: 1,
      eventDate: '2026-10-01',
      sources: [QuestionSource(name: 'প্রথম আলো', url: 'https://prothomalo.com')],
    ),

    // =========================================================================
    // ১২. সাম্প্রতিক (আন্তর্জাতিক) (recent_international)
    // =========================================================================
    const Question(
      id: 'q_r_intl_001',
      kind: 'current',
      topic: 'recent_international',
      subtopic: 'nobel',
      text: 'চিকিৎসাবিজ্ঞানে ২০২৪ সালের নোবেল পুরস্কার যৌথভাবে লাভ করেন কোন দুই বিজ্ঞানী?',

      options: [
        'ভিক্টর অ্যামব্রোস ও গ্যারি রাভকুন',
        'ক্যাটালিন কারিকো ও ড্রু ওয়াইজম্যান',
        'স্বান্তে প্যাবো ও ডেভিড জুলিয়াস',
        'হার্ভে অল্টার ও চার্লস রাইস'
      ],
      answerIndex: 0,
      explanation: 'মাইক্রো-আরএনএ (microRNA) এবং ট্রান্সক্রিপশন-পরবর্তী জিন নিয়ন্ত্রণ আবিষ্কারের জন্য ভিক্টর অ্যামব্রোস এবং গ্যারি রাভকুন ২০২৪ সালের চিকিৎসায় নোবেল পান।',

      difficulty: 2,
      eventDate: '2026-10-07',
      sources: [QuestionSource(name: 'NobelPrize.org', url: 'https://nobelprize.org')],
    ),
    const Question(
      id: 'q_r_intl_002',
      kind: 'current',
      topic: 'recent_international',
      subtopic: 'summits',
      text: 'জাতিসংঘের ২৯তম জলবায়ু সম্মেলন (COP29) কোথায় অনুষ্ঠিত হয়?',

      options: ['বাকু, আজারবাইজান', 'দুবাই, সংযুক্ত আরব আমিরাত', 'শার্ম আল-শেখ, মিশর', 'গ্লাসগো, যুক্তরাজ্য'],
      answerIndex: 0,
      explanation: '২০২৪ সালের শেষভাগে আজারবাইজানের রাজধানী বাকুতে জাতিসংঘ জলবায়ু পরিবর্তন সম্মেলন কপ২৯ অনুষ্ঠিত হয়।',

      difficulty: 1,
      eventDate: '2026-10-02',
      sources: [QuestionSource(name: 'UN Climate Change (UNFCCC)', url: 'https://unfccc.int')],
    ),
    const Question(
      id: 'q_r_intl_003',
      kind: 'current',
      topic: 'recent_international',
      subtopic: 'brics',
      text: 'ব্রিকস (BRICS)-এর নতুন পূর্ণ সদস্য হিসেবে মধ্যপ্রাচ্যের কোন দেশটি সম্প্রতি আনুষ্ঠানিকভাবে অন্তর্ভুক্ত হয়েছে?',

      options: ['সংযুক্ত আরব আমিরাত ও ইরান', 'কাতার ও ওমান', 'কুয়েত ও বাহরাইন', 'জর্ডান ও ইরাক'],
      answerIndex: 0,
      explanation: 'ব্রিকস জোটে নতুন করে মিসর, ইথিওপিয়া, ইরান ও সংযুক্ত আরব আমিরাত পূর্ণ সদস্যপদ গ্রহণ করেছে।',

      difficulty: 2,
      eventDate: '2026-09-18',
      sources: [QuestionSource(name: 'Al Jazeera', url: 'https://aljazeera.com')],
    ),
  ];
}
