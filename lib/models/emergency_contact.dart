import 'package:flutter/material.dart';

class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    this.nameKm,
    this.address,
    this.addressKm,
    this.hours,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String phone;
  final ContactCategory category;
  final String? nameKm;
  final String? address;
  final String? addressKm;
  final String? hours;
  final String? imageUrl;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      category: _categoryFromString(json['category']),
      nameKm: json['name_km'],
      address: json['address'],
      addressKm: json['address_km'],
      hours: json['hours'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'category': category.name,
    'name_km': nameKm,
    'address': address,
    'address_km': addressKm,
    'hours': hours,
    'image_url': imageUrl,
  };

  String displayNameFor(bool isKhmer) => isKhmer ? (nameKm ?? name) : name;
  String? displayAddressFor(bool isKhmer) =>
      isKhmer ? (addressKm ?? address) : address;

  static ContactCategory _categoryFromString(String? value) {
    switch (value) {
      case 'police':
        return ContactCategory.police;
      case 'fire':
        return ContactCategory.fire;
      case 'medical':
        return ContactCategory.medical;
      case 'road_safety':
        return ContactCategory.roadSafety;
      case 'family':
        return ContactCategory.family;
      default:
        return ContactCategory.medical;
    }
  }
}

enum ContactCategory { police, fire, medical, roadSafety, family }

extension ContactCategoryX on ContactCategory {
  String get label {
    return labelFor(false);
  }

  String labelFor(bool isKhmer) {
    if (isKhmer) {
      switch (this) {
        case ContactCategory.police:
          return 'ប៉ូលិស';
        case ContactCategory.fire:
          return 'ពន្លត់អគ្គិភ័យ';
        case ContactCategory.medical:
          return 'សេវាវេជ្ជសាស្ត្រ';
        case ContactCategory.roadSafety:
          return 'សុវត្ថិភាពចរាចរណ៍';
        case ContactCategory.family:
          return 'គ្រួសារ/មិត្តភក្តិ';
      }
    }

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

  IconData get icon {
    switch (this) {
      case ContactCategory.police:
        return Icons.local_police_rounded;
      case ContactCategory.fire:
        return Icons.local_fire_department_rounded;
      case ContactCategory.medical:
        return Icons.local_hospital_rounded;
      case ContactCategory.roadSafety:
        return Icons.car_crash_rounded;
      case ContactCategory.family:
        return Icons.groups_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ContactCategory.police:
        return const Color(0xFF2563EB);
      case ContactCategory.fire:
        return const Color(0xFFEA580C);
      case ContactCategory.medical:
        return const Color(0xFF059669);
      case ContactCategory.roadSafety:
        return const Color(0xFFF59E0B);
      case ContactCategory.family:
        return const Color(0xFF7C3AED);
    }
  }
}
