import 'package:flutter/material.dart';

class MotherTenantProfile {
  final String id;
  final String mamaName;
  final String phone;
  final String babyName;
  final int babyAgeWeeks;
  final String babyDob;
  final String whoPassId;
  final String pinCode;
  final bool requirePinEveryTime;
  final String avatarColorHex;

  const MotherTenantProfile({
    required this.id,
    required this.mamaName,
    required this.phone,
    required this.babyName,
    required this.babyAgeWeeks,
    required this.babyDob,
    required this.whoPassId,
    required this.pinCode,
    this.requirePinEveryTime = false,
    this.avatarColorHex = '#3E644A',
  });

  String get mamaFirstName => mamaName.split(' ').first;

  String get initials {
    final parts =
        mamaName.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'M';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  MotherTenantProfile copyWith({
    String? mamaName,
    String? phone,
    String? babyName,
    int? babyAgeWeeks,
    String? babyDob,
    String? whoPassId,
    String? pinCode,
    bool? requirePinEveryTime,
    String? avatarColorHex,
  }) {
    return MotherTenantProfile(
      id: id,
      mamaName: mamaName ?? this.mamaName,
      phone: phone ?? this.phone,
      babyName: babyName ?? this.babyName,
      babyAgeWeeks: babyAgeWeeks ?? this.babyAgeWeeks,
      babyDob: babyDob ?? this.babyDob,
      whoPassId: whoPassId ?? this.whoPassId,
      pinCode: pinCode ?? this.pinCode,
      requirePinEveryTime: requirePinEveryTime ?? this.requirePinEveryTime,
      avatarColorHex: avatarColorHex ?? this.avatarColorHex,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mamaName': mamaName,
        'phone': phone,
        'babyName': babyName,
        'babyAgeWeeks': babyAgeWeeks,
        'babyDob': babyDob,
        'whoPassId': whoPassId,
        'pinCode': pinCode,
        'requirePinEveryTime': requirePinEveryTime,
        'avatarColorHex': avatarColorHex,
      };

  factory MotherTenantProfile.fromJson(Map<String, dynamic> json) =>
      MotherTenantProfile(
        id: json['id'] as String? ?? 'tenant-amara',
        mamaName: json['mamaName'] as String? ?? 'Amara Vance',
        phone: json['phone'] as String? ?? '+254712555192',
        babyName: json['babyName'] as String? ?? 'Leo',
        babyAgeWeeks: (json['babyAgeWeeks'] as num?)?.toInt() ?? 6,
        babyDob: json['babyDob'] as String? ?? 'Sep 2, 2024',
        whoPassId: json['whoPassId'] as String? ?? '#WHO-88921-LV',
        pinCode: json['pinCode'] as String? ?? '1234',
        requirePinEveryTime: json['requirePinEveryTime'] as bool? ?? false,
        avatarColorHex: json['avatarColorHex'] as String? ?? '#3E644A',
      );

  static const List<MotherTenantProfile> defaultTenants = [
    MotherTenantProfile(
      id: 'tenant-amara',
      mamaName: 'Amara Vance',
      phone: '+254712555192',
      babyName: 'Leo',
      babyAgeWeeks: 6,
      babyDob: 'Sep 2, 2024',
      whoPassId: '#WHO-88921-LV',
      pinCode: '1234',
      requirePinEveryTime: false,
      avatarColorHex: '#3E644A',
    ),
    MotherTenantProfile(
      id: 'tenant-wanjiku',
      mamaName: 'Wanjiku Kamau',
      phone: '+254722889100',
      babyName: 'Zuri',
      babyAgeWeeks: 10,
      babyDob: 'Aug 5, 2024',
      whoPassId: '#WHO-44219-ZK',
      pinCode: '2580',
      requirePinEveryTime: true,
      avatarColorHex: '#964327',
    ),
  ];
}

class FeedLogEntry {
  final String id;
  final String side; // 'Left' | 'Right'
  final int durationMinutes;
  final int sleepMinutes;
  final DateTime timestamp;

  const FeedLogEntry({
    required this.id,
    required this.side,
    required this.durationMinutes,
    required this.sleepMinutes,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'side': side,
        'durationMinutes': durationMinutes,
        'sleepMinutes': sleepMinutes,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory FeedLogEntry.fromJson(Map<String, dynamic> json) => FeedLogEntry(
        id: json['id'] as String? ?? 'feed',
        side: json['side'] as String? ?? 'Left',
        durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 18,
        sleepMinutes: (json['sleepMinutes'] as num?)?.toInt() ?? 140,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as num?)?.toInt() ??
              DateTime.now().millisecondsSinceEpoch,
        ),
      );
}

class EmergencyContact {
  final String id;
  final String name;
  final String role;
  final String subtitle;
  final String phone;
  final String? avatarUrl;
  final String badgeType; // 'primary' | 'secondary' | 'tertiary'
  final bool isCustom;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.role,
    required this.subtitle,
    required this.phone,
    this.avatarUrl,
    this.badgeType = 'primary',
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'subtitle': subtitle,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'badgeType': badgeType,
        'isCustom': isCustom,
      };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        id: json['id'] as String? ?? 'contact',
        name: json['name'] as String? ?? 'Contact',
        role: json['role'] as String? ?? 'Support',
        subtitle: json['subtitle'] as String? ?? 'Support Circle',
        phone: json['phone'] as String? ?? '+254700000000',
        avatarUrl: json['avatarUrl'] as String?,
        badgeType: json['badgeType'] as String? ?? 'primary',
        isCustom: json['isCustom'] as bool? ?? false,
      );
}

class CalendarReminderTarget {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final String description;
  final DateTime startDate;
  final int durationMinutes;

  const CalendarReminderTarget({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.description,
    required this.startDate,
    this.durationMinutes = 45,
  });
}

class ChatMessage {
  final String id;
  final bool isFromMama;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.isFromMama,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'isFromMama': isFromMama,
        'text': text,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String? ?? 'msg',
        isFromMama: json['isFromMama'] as bool? ?? false,
        text: json['text'] as String? ?? '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as num?)?.toInt() ??
              DateTime.now().millisecondsSinceEpoch,
        ),
      );
}

class UserCoordinates {
  final double lat;
  final double lng;
  final double accuracy;
  final String areaName;
  final bool isLiveGps;

  const UserCoordinates({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.areaName,
    required this.isLiveGps,
  });

  static const UserCoordinates defaultNairobiWest = UserCoordinates(
    lat: -1.3048,
    lng: 36.8156,
    accuracy: 25,
    areaName: 'Nairobi West Area',
    isLiveGps: false,
  );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'areaName': areaName,
      };

  factory UserCoordinates.fromJson(Map<String, dynamic> json) =>
      UserCoordinates(
        lat: (json['lat'] as num?)?.toDouble() ?? -1.3048,
        lng: (json['lng'] as num?)?.toDouble() ?? 36.8156,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 25.0,
        areaName: json['areaName'] as String? ?? 'Nairobi West Area',
        isLiveGps: false,
      );
}

class CareFacility {
  final String id;
  final String name;
  final String badgeText;
  final String? secondaryBadge;
  final bool isPrimaryVariant;
  final double lat;
  final double lng;
  final String phone;
  final bool isWalkingMode;
  final String statusHeadline;
  final String statusSubtext;
  final bool isLivePing;
  final List<String> capabilities;
  final List<String> tags;
  final IconData icon;
  final String primaryCtaLabel;
  final String secondaryCtaLabel;

  const CareFacility({
    required this.id,
    required this.name,
    required this.badgeText,
    this.secondaryBadge,
    this.isPrimaryVariant = true,
    required this.lat,
    required this.lng,
    required this.phone,
    this.isWalkingMode = false,
    required this.statusHeadline,
    required this.statusSubtext,
    this.isLivePing = false,
    required this.capabilities,
    required this.tags,
    required this.icon,
    required this.primaryCtaLabel,
    required this.secondaryCtaLabel,
  });
}

class NiamamaState {
  final bool isBabyLeoActive;
  final String? lastMood; // 'resting' | 'tired' | 'midwife'
  final List<FeedLogEntry> feedLogs;
  final int tummyTimeMinutesToday;
  final int tummyTimeGoalMinutes;
  final int smileMemoriesCount;
  final Map<String, bool> engagementCues;
  final Map<String, bool> completedVaccines;
  final Map<String, String> savedCalendarReminders;
  final List<EmergencyContact> contacts;
  final Map<String, bool> joinedCircles;
  final List<ChatMessage> chatMessages;
  final UserCoordinates? cachedCoordinates;

  const NiamamaState({
    required this.isBabyLeoActive,
    required this.lastMood,
    required this.feedLogs,
    required this.tummyTimeMinutesToday,
    required this.tummyTimeGoalMinutes,
    required this.smileMemoriesCount,
    required this.engagementCues,
    required this.completedVaccines,
    required this.savedCalendarReminders,
    required this.contacts,
    required this.joinedCircles,
    required this.chatMessages,
    this.cachedCoordinates,
  });

  static List<EmergencyContact> get defaultContacts => const [
        EmergencyContact(
          id: 'contact-alex',
          name: 'Alex (Partner)',
          role: 'Partner',
          subtitle: 'Primary Support • Home nearby',
          phone: '+254712555192',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDqelyRmQvwgnTlAWW5MNxI9n22W8faA5oowivxOSrDDR4DeGIJG7A9QRnRsfkyatHt14bKcBA9hSdXUtKF9EaCs-DBhliuR9Jg5phrOsNIrEMg421V_FcRFjGUoDFxcnCNi_ycJ74Ky3GFHpy_Jln8YMKrbUZM0L40HDJMhYdBw876bjU0exsOAAc0TiLb2K0oEzLEnXEUJOzmT15cyJEGuGITlIBSjrZP3uHBZew',
          badgeType: 'secondary',
        ),
        EmergencyContact(
          id: 'contact-patel',
          name: 'Dr. Anita Patel',
          role: 'Pediatrician',
          subtitle: 'Pediatrician • Valley Infant Clinic',
          phone: '+254722555144',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBI9KxEId6krRo1AoeEIcigKHT7EJkkfPmxgp4irKVT2lXN0YLu9z1eQNJcLcljiLO2toBjAKwiWhU2_9umcx2G4vlWJxzC_6_7TjlPtmDAs0HLdPcCAtsdgB9TMYfTQT8K57G_jeNuNb42ZHk1fb2en1raHJICh1o51uXwtL5lA0HxSYyt-yMe8SjIgFdBEXXvsNdTtP8go28m9pEoM87_3dxxgn6UmRdfs-Y1M8c',
          badgeType: 'primary',
        ),
        EmergencyContact(
          id: 'contact-claire',
          name: 'Claire M. (Doula)',
          role: 'Postpartum Doula',
          subtitle: 'Postpartum Care • Visiting tomorrow',
          phone: '+254733555188',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBAWdEyyJ2_UgMeDpzGAiWm-1oPX2BlQVLrL9-87vuerJHiJduHbvAU3ElNDu-azBB-a6_GI1-ZyfkW_uFaXwy1RyijhLfOKCp16kSowAZ6znMgqj0JeqbKbMk3BjR1RvJvcHOwLgXe_D1DSxx_In9hS-DsEf0XyQ4yo-rjbU2fyHCnX2gKftYG-ocnRprH-aV3B9DRm3vxDEF6qZxI1lvEM0DZQat0Q06C5EmCEgg',
          badgeType: 'tertiary',
        ),
      ];

  factory NiamamaState.initial({MotherTenantProfile? tenant}) {
    final isSecondaryTenant = tenant?.id == 'tenant-wanjiku';
    final mamaFirst = tenant?.mamaFirstName ?? 'Mama';
    final babyName = tenant?.babyName ?? 'Leo';

    return NiamamaState(
      isBabyLeoActive: true,
      lastMood: null,
      feedLogs: [
        FeedLogEntry(
          id: 'feed-initial-${tenant?.id ?? "default"}',
          side: isSecondaryTenant ? 'Right' : 'Left',
          durationMinutes: isSecondaryTenant ? 22 : 18,
          sleepMinutes: isSecondaryTenant ? 165 : 140,
          timestamp: DateTime.now().subtract(
            Duration(minutes: isSecondaryTenant ? 45 : 105),
          ),
        ),
      ],
      tummyTimeMinutesToday: isSecondaryTenant ? 4 : 3,
      tummyTimeGoalMinutes: 5,
      smileMemoriesCount: isSecondaryTenant ? 3 : 1,
      engagementCues: const {
        'gaze': true,
        'mouth': false,
        'brows': false,
      },
      completedVaccines: {
        'bcg': true,
        'opv0': true,
        'penta1': isSecondaryTenant,
        'pcv1': isSecondaryTenant,
        'opv1': isSecondaryTenant,
        'rota1': isSecondaryTenant,
      },
      savedCalendarReminders: const {},
      contacts: defaultContacts,
      joinedCircles: {
        'newborn': true,
        'breastfeeding': isSecondaryTenant,
        'healing': false,
      },
      chatMessages: [
        ChatMessage(
          id: 'msg-welcome-${tenant?.id ?? "default"}',
          isFromMama: false,
          text:
              'Hi $mamaFirst, I am Registered Midwife Sarah. Whether you have a question about $babyName\'s latch comfort, fever, or your own healing, message me anytime—even offline.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
      cachedCoordinates: null,
    );
  }

  NiamamaState copyWith({
    bool? isBabyLeoActive,
    String? lastMood,
    List<FeedLogEntry>? feedLogs,
    int? tummyTimeMinutesToday,
    int? tummyTimeGoalMinutes,
    int? smileMemoriesCount,
    Map<String, bool>? engagementCues,
    Map<String, bool>? completedVaccines,
    Map<String, String>? savedCalendarReminders,
    List<EmergencyContact>? contacts,
    Map<String, bool>? joinedCircles,
    List<ChatMessage>? chatMessages,
    UserCoordinates? cachedCoordinates,
  }) {
    return NiamamaState(
      isBabyLeoActive: isBabyLeoActive ?? this.isBabyLeoActive,
      lastMood: lastMood ?? this.lastMood,
      feedLogs: feedLogs ?? this.feedLogs,
      tummyTimeMinutesToday:
          tummyTimeMinutesToday ?? this.tummyTimeMinutesToday,
      tummyTimeGoalMinutes: tummyTimeGoalMinutes ?? this.tummyTimeGoalMinutes,
      smileMemoriesCount: smileMemoriesCount ?? this.smileMemoriesCount,
      engagementCues: engagementCues ?? this.engagementCues,
      completedVaccines: completedVaccines ?? this.completedVaccines,
      savedCalendarReminders:
          savedCalendarReminders ?? this.savedCalendarReminders,
      contacts: contacts ?? this.contacts,
      joinedCircles: joinedCircles ?? this.joinedCircles,
      chatMessages: chatMessages ?? this.chatMessages,
      cachedCoordinates: cachedCoordinates ?? this.cachedCoordinates,
    );
  }
}
