import '../models/emergency_contact.dart';

const List<EmergencyContact> kEmergencyContacts = [
  // Police
  EmergencyContact(
    id: 'p1',
    name: 'National Police Hotline',
    phone: '117',
    category: ContactCategory.police,
    address: 'Phnom Penh, Cambodia',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1516228145159-63ce9e07b5a9?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'p2',
    name: 'Phnom Penh Police HQ',
    phone: '023-720-704',
    category: ContactCategory.police,
    address: 'St 47, Sangkat Boeung Raingsey, Khan Daun Penh',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'p3',
    name: 'Tourist Police',
    phone: '012-942-484',
    category: ContactCategory.police,
    address: 'Sisowath Quay, Sangkat Chaktomuk, Khan Daun Penh',
    hours: '07:00–22:00',
    imageUrl:
        'https://images.unsplash.com/photo-1516228145159-63ce9e07b5a9?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'p4',
    name: 'BKK1 Police Post',
    phone: '023-994-117',
    category: ContactCategory.police,
    address: 'St 63, Sangkat Boeung Keng Kang I, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'p5',
    name: 'Toul Kork Police',
    phone: '023-881-117',
    category: ContactCategory.police,
    address: 'St 192, Sangkat Phsar Daeum Thkov, Khan Toul Kork',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1516228145159-63ce9e07b5a9?w=400&h=300&fit=crop',
  ),

  // Fire
  EmergencyContact(
    id: 'f1',
    name: 'Fire Department Hotline',
    phone: '118',
    category: ContactCategory.fire,
    address: 'Phnom Penh, Cambodia',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'f2',
    name: 'Central Fire Station',
    phone: '023-430-118',
    category: ContactCategory.fire,
    address: 'St 102, Sangkat Boeung Trabek, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'f3',
    name: 'BKK Fire Station',
    phone: '023-988-118',
    category: ContactCategory.fire,
    address: 'St 63, Sangkat Boeung Keng Kang I, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'f4',
    name: 'Toul Kork Fire Station',
    phone: '023-882-118',
    category: ContactCategory.fire,
    address: 'St 192, Sangkat Phsar Daeum Thkov, Khan Toul Kork',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'f5',
    name: 'Sen Sok Fire Station',
    phone: '023-771-118',
    category: ContactCategory.fire,
    address: 'St 311, Sangkat Chrang Chamres, Khan Sen Sok',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop',
  ),

  // Medical
  EmergencyContact(
    id: 'm1',
    name: 'Ambulance Service',
    phone: '119',
    category: ContactCategory.medical,
    address: 'Phnom Penh, Cambodia',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1512842915884-53d5d3fd6f46?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'm2',
    name: 'Calmette Hospital',
    phone: '023-430-115',
    category: ContactCategory.medical,
    address: 'Monivong Blvd, Sangkat Tonle Bassac, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1631217314831-c6227db76b6e?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'm3',
    name: 'Royal Phnom Penh Hospital',
    phone: '023-991-000',
    category: ContactCategory.medical,
    address: 'Samdech Techo Hun Sen Blvd, Sangkat Kakab, Khan Porsenchey',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1631217314831-c6227db76b6e?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'm4',
    name: 'Khmer-Soviet Friendship Hospital',
    phone: '023-883-000',
    category: ContactCategory.medical,
    address: 'St 352, Sangkat Boeng Keng Kang, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1631217314831-c6227db76b6e?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'm5',
    name: 'National Pediatric Hospital',
    phone: '023-426-748',
    category: ContactCategory.medical,
    address: 'St 113, Sangkat Boeng Trabek, Khan Chamkarmon',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1631217314831-c6227db76b6e?w=400&h=300&fit=crop',
  ),

  // Road Safety
  EmergencyContact(
    id: 'r1',
    name: 'Road Accident Hotline',
    phone: '1294',
    category: ContactCategory.roadSafety,
    address: 'Phnom Penh, Cambodia',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1468276311594-df7cb65d8c75?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'r2',
    name: 'Traffic Police HQ',
    phone: '023-720-704',
    category: ContactCategory.roadSafety,
    address: 'Confederation de la Russie Blvd, Sangkat Kakab, Khan Porsenchey',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1468276311594-df7cb65d8c75?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'r3',
    name: 'Road Rescue Cambodia',
    phone: '010-999-119',
    category: ContactCategory.roadSafety,
    address: 'Various Locations, Phnom Penh',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1468276311594-df7cb65d8c75?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'r4',
    name: 'Towing Service Phnom Penh',
    phone: '012-555-333',
    category: ContactCategory.roadSafety,
    address: 'Various Locations, Phnom Penh',
    hours: '24/7',
    imageUrl:
        'https://images.unsplash.com/photo-1468276311594-df7cb65d8c75?w=400&h=300&fit=crop',
  ),
  EmergencyContact(
    id: 'r5',
    name: 'Insurance Assistance',
    phone: '1800-888-888',
    category: ContactCategory.roadSafety,
    address: 'Multi-location, Cambodia',
    hours: '08:00–20:00',
    imageUrl:
        'https://images.unsplash.com/photo-1468276311594-df7cb65d8c75?w=400&h=300&fit=crop',
  ),

  // Family / Friends (profile pictures via initials)
  EmergencyContact(
    id: 'fam1',
    name: 'Dad',
    phone: '012-555-0001',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam2',
    name: 'Mom',
    phone: '012-555-0002',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam3',
    name: 'Brother',
    phone: '012-555-0003',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam4',
    name: 'Sister',
    phone: '012-555-0004',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam5',
    name: 'Grandmother',
    phone: '012-555-0005',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam6',
    name: 'Uncle',
    phone: '012-555-0006',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
  EmergencyContact(
    id: 'fam7',
    name: 'Best Friend',
    phone: '012-555-0007',
    category: ContactCategory.family,
    address: 'Phnom Penh',
  ),
];
