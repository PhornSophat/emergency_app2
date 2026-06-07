class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    this.address,
    this.hours,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String phone;
  final ContactCategory category;
  final String? address;
  final String? hours;
  final String? imageUrl;
}

enum ContactCategory { police, fire, medical, roadSafety, family }

extension ContactCategoryX on ContactCategory {
  String get label {
    switch (this) {
      case ContactCategory.police:
        return 'Police';
      case ContactCategory.fire:
        return 'Fire service';
      case ContactCategory.medical:
        return 'Medical service';
      case ContactCategory.roadSafety:
        return 'Road safety';
      case ContactCategory.family:
        return 'Family/friends';
    }
  }

  String get emoji {
    switch (this) {
      case ContactCategory.police:
        return '🚔';
      case ContactCategory.fire:
        return '🔥';
      case ContactCategory.medical:
        return '🏥';
      case ContactCategory.roadSafety:
        return '🛣️';
      case ContactCategory.family:
        return '👥';
    }
  }
}
