class UserInfoStoreModel {
  UserInfoStoreModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  final User user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  UserInfoStoreModel copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
  }) {
    return UserInfoStoreModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  factory UserInfoStoreModel.fromJson(Map<String, dynamic> json) {
    return UserInfoStoreModel(
      user: json['user'] == null ? User.empty() : User.fromJson(json['user']),
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      tokenType: json['tokenType'] ?? '',
    );
  }

  factory UserInfoStoreModel.empty() {
    return UserInfoStoreModel(
      user: User.empty(),
      accessToken: '',
      refreshToken: '',
      tokenType: '',
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'tokenType': tokenType,
  };

  @override
  String toString() {
    return '$user, $accessToken, $refreshToken, $tokenType, ';
  }
}

class User {
  User({
    required this.id,
    required this.phone,
    required this.email,
    required this.fullName,
    required this.profileImage,
    required this.dob,
    required this.country,
    required this.role,
    required this.status,
    required this.pricingTierKey,
    required this.lifetimePurchasedTokens,
    required this.authProviders,
    required this.notificationSettings,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
    required this.deletedAt,
    required this.remainingTokens,
  });

  final String id;
  final String phone;
  final String email;
  final String fullName;
  final String? profileImage;
  final DateTime? dob;
  final dynamic country;
  final String role;
  final String status;
  final String pricingTierKey;
  final int lifetimePurchasedTokens;
  final List<String> authProviders;
  final NotificationSettings? notificationSettings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final dynamic deletedAt;
  final int remainingTokens;

  User copyWith({
    String? id,
    String? phone,
    String? email,
    String? fullName,
    String? profileImage,
    DateTime? dob,
    dynamic country,
    String? role,
    String? status,
    String? pricingTierKey,
    int? lifetimePurchasedTokens,
    List<String>? authProviders,
    NotificationSettings? notificationSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    dynamic deletedAt,
    int? remainingTokens,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      dob: dob ?? this.dob,
      country: country ?? this.country,
      role: role ?? this.role,
      status: status ?? this.status,
      pricingTierKey: pricingTierKey ?? this.pricingTierKey,
      lifetimePurchasedTokens:
          lifetimePurchasedTokens ?? this.lifetimePurchasedTokens,
      authProviders: authProviders ?? this.authProviders,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      deletedAt: deletedAt ?? this.deletedAt,
      remainingTokens: remainingTokens ?? this.remainingTokens,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'],
      dob: DateTime.tryParse(json['dob'] ?? ''),
      country: json['country'],
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      pricingTierKey: json['pricingTierKey'] ?? '',
      lifetimePurchasedTokens: json['lifetimePurchasedTokens'] ?? 0,
      authProviders: json['authProviders'] == null
          ? []
          : List<String>.from(json['authProviders']!.map((x) => x)),
      notificationSettings: json['notificationSettings'] == null
          ? null
          : NotificationSettings.fromJson(json['notificationSettings']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      lastLoginAt: DateTime.tryParse(json['lastLoginAt'] ?? ''),
      deletedAt: json['deletedAt'],
      remainingTokens: json['remainingTokens'] ?? 0,
    );
  }

  factory User.empty() {
    return User(
      id: '',
      phone: '',
      email: '',
      fullName: '',
      profileImage: null,
      dob: null,
      country: '',
      role: '',
      status: '',
      pricingTierKey: '',
      lifetimePurchasedTokens: 0,
      authProviders: [],
      notificationSettings: NotificationSettings.empty(),
      createdAt: null,
      updatedAt: null,
      lastLoginAt: null,
      deletedAt: '',
      remainingTokens: 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'email': email,
    'fullName': fullName,
    'profileImage': profileImage,
    'dob': dob?.toIso8601String(),
    'country': country,
    'role': role,
    'status': status,
    'pricingTierKey': pricingTierKey,
    'lifetimePurchasedTokens': lifetimePurchasedTokens,
    'authProviders': authProviders.map((x) => x).toList(),
    'notificationSettings': notificationSettings?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'lastLoginAt': lastLoginAt?.toIso8601String(),
    'deletedAt': deletedAt,
    'remainingTokens': remainingTokens,
  };

  @override
  String toString() {
    return '$id, $phone, $email, $fullName, $profileImage, $dob, $country, $role, $status, $pricingTierKey, $lifetimePurchasedTokens, $authProviders, $notificationSettings, $createdAt, $updatedAt, $lastLoginAt, $deletedAt, $remainingTokens, ';
  }
}

class NotificationSettings {
  NotificationSettings({
    required this.push,
    required this.email,
  });

  final PushNotificationSettings push;
  final EmailNotificationSettings email;

  NotificationSettings copyWith({
    PushNotificationSettings? push,
    EmailNotificationSettings? email,
  }) {
    return NotificationSettings(
      push: push ?? this.push,
      email: email ?? this.email,
    );
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      push: json['push'] == null
          ? PushNotificationSettings.empty()
          : PushNotificationSettings.fromJson(json['push']),
      email: json['email'] == null
          ? EmailNotificationSettings.empty()
          : EmailNotificationSettings.fromJson(json['email']),
    );
  }

  factory NotificationSettings.empty() {
    return NotificationSettings(
      push: PushNotificationSettings.empty(),
      email: EmailNotificationSettings.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    'push': push.toJson(),
    'email': email.toJson(),
  };

  @override
  String toString() {
    return 'push: $push, email: $email';
  }
}

class PushNotificationSettings {
  PushNotificationSettings({
    required this.push,
    required this.messagesFromAdvisors,
    required this.specialOffers,
  });

  final bool push;
  final bool messagesFromAdvisors;
  final bool specialOffers;

  PushNotificationSettings copyWith({
    bool? push,
    bool? messagesFromAdvisors,
    bool? specialOffers,
  }) {
    return PushNotificationSettings(
      push: push ?? this.push,
      messagesFromAdvisors: messagesFromAdvisors ?? this.messagesFromAdvisors,
      specialOffers: specialOffers ?? this.specialOffers,
    );
  }

  factory PushNotificationSettings.fromJson(Map<String, dynamic> json) {
    return PushNotificationSettings(
      push: json['push'] ?? true,
      messagesFromAdvisors: json['messagesFromAdvisors'] ?? false,
      specialOffers: json['specialOffers'] ?? false,
    );
  }

  factory PushNotificationSettings.empty() {
    return PushNotificationSettings(
      push: true,
      messagesFromAdvisors: false,
      specialOffers: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'push': push,
    'messagesFromAdvisors': messagesFromAdvisors,
    'specialOffers': specialOffers,
  };

  @override
  String toString() {
    return 'push: $push, messagesFromAdvisors: $messagesFromAdvisors, specialOffers: $specialOffers';
  }
}

class EmailNotificationSettings {
  EmailNotificationSettings({
    required this.email,
    required this.messagesFromAdvisors,
    required this.specialOffers,
  });

  final String email;
  final bool messagesFromAdvisors;
  final bool specialOffers;

  EmailNotificationSettings copyWith({
    String? email,
    bool? messagesFromAdvisors,
    bool? specialOffers,
  }) {
    return EmailNotificationSettings(
      email: email ?? this.email,
      messagesFromAdvisors: messagesFromAdvisors ?? this.messagesFromAdvisors,
      specialOffers: specialOffers ?? this.specialOffers,
    );
  }

  factory EmailNotificationSettings.fromJson(Map<String, dynamic> json) {
    return EmailNotificationSettings(
      email: json['email'] ?? '',
      messagesFromAdvisors: json['messagesFromAdvisors'] ?? true,
      specialOffers: json['specialOffers'] ?? false,
    );
  }

  factory EmailNotificationSettings.empty() {
    return EmailNotificationSettings(
      email: '',
      messagesFromAdvisors: true,
      specialOffers: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'messagesFromAdvisors': messagesFromAdvisors,
    'specialOffers': specialOffers,
  };

  @override
  String toString() {
    return 'email: $email, messagesFromAdvisors: $messagesFromAdvisors, specialOffers: $specialOffers';
  }
}

/*
{
  "user": {
    "id": "6a05e1630062a793baf8d1b2",
    "phone": "+441111111113",
    "email": "tester2@test.com",
    "fullName": "test",
    "profileImage": null,
    "dob": "2025-12-12T00:00:00.000Z",
    "country": null,
    "role": "user",
    "status": "active",
    "pricingTierKey": "seeker",
    "lifetimePurchasedTokens": 0,
    "authProviders": ["phone"],
    "notificationSettings": {
      "push": {
        "push": true,
        "messagesFromAdvisors": false,
        "specialOffers": false
      },
      "email": {
        "email": "tester2@test.com",
        "messagesFromAdvisors": true,
        "specialOffers": false
      }
    },
    "createdAt": "2026-05-14T14:51:15.268Z",
    "updatedAt": "2026-05-19T10:07:33.719Z",
    "lastLoginAt": "2026-05-19T10:07:33.719Z",
    "deletedAt": null,
    "remainingTokens": 95780
  },
  "accessToken": "...",
  "refreshToken": "...",
  "tokenType": "Bearer"
}*/
