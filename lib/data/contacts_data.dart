import '../models/emergency_contact.dart';

const List<EmergencyContact> kEmergencyContacts = [
  // Police
  EmergencyContact(id: 'p1', name: 'National Police', phone: '117', category: ContactCategory.police, address: 'Phnom Penh Central', hours: '24/7'),
  EmergencyContact(id: 'p2', name: 'BKK1 Police Post', phone: '+85523994117', category: ContactCategory.police, address: 'BKK1, Khan Chamkarmon', hours: '24/7'),
  EmergencyContact(id: 'p3', name: 'Daun Penh Police', phone: '+85512999117', category: ContactCategory.police, address: 'Daun Penh District', hours: '24/7'),
  EmergencyContact(id: 'p4', name: 'Tourist Police', phone: '+85512942484', category: ContactCategory.police, address: 'Sisowath Quay', hours: '07:00–22:00'),
  EmergencyContact(id: 'p5', name: 'Anti-Drug Police', phone: '+85512999820', category: ContactCategory.police, address: 'Phnom Penh', hours: '24/7'),

  // Fire
  EmergencyContact(id: 'f1', name: 'Fire Department', phone: '118', category: ContactCategory.fire, address: 'Phnom Penh Central', hours: '24/7'),
  EmergencyContact(id: 'f2', name: 'BKK Fire Station', phone: '+85523430118', category: ContactCategory.fire, address: 'BKK, Khan Chamkarmon', hours: '24/7'),
  EmergencyContact(id: 'f3', name: 'Toul Kork Fire', phone: '+85523882118', category: ContactCategory.fire, address: 'Toul Kork District', hours: '24/7'),
  EmergencyContact(id: 'f4', name: 'Sen Sok Fire Post', phone: '+85523771118', category: ContactCategory.fire, address: 'Sen Sok District', hours: '24/7'),
  EmergencyContact(id: 'f5', name: 'Meanchey Fire', phone: '+85523661118', category: ContactCategory.fire, address: 'Meanchey District', hours: '24/7'),

  // Medical
  EmergencyContact(id: 'm1', name: 'Ambulance', phone: '119', category: ContactCategory.medical, address: 'Phnom Penh', hours: '24/7'),
  EmergencyContact(id: 'm2', name: 'Calmette Hospital', phone: '+85523430115', category: ContactCategory.medical, address: 'Monivong Blvd, Daun Penh', hours: '24/7'),
  EmergencyContact(id: 'm3', name: 'Royal Phnom Penh Hospital', phone: '+85523991000', category: ContactCategory.medical, address: 'Samdech Techo Hun Sen Blvd', hours: '24/7'),
  EmergencyContact(id: 'm4', name: 'Sen Sok Int\'l University Hospital', phone: '+85523883000', category: ContactCategory.medical, address: 'Sen Sok District', hours: '24/7'),
  EmergencyContact(id: 'm5', name: 'Children\'s Hospital', phone: '+85523426748', category: ContactCategory.medical, address: 'St 113, Daun Penh', hours: '24/7'),

  // Road Safety
  EmergencyContact(id: 'r1', name: 'Road Accident Hotline', phone: '1294', category: ContactCategory.roadSafety, address: 'Phnom Penh', hours: '24/7'),
  EmergencyContact(id: 'r2', name: 'Traffic Police', phone: '+85523720704', category: ContactCategory.roadSafety, address: 'Confederation de la Russie Blvd', hours: '24/7'),
  EmergencyContact(id: 'r3', name: 'Road Rescue Cambodia', phone: '+85510999119', category: ContactCategory.roadSafety, address: 'Phnom Penh', hours: '24/7'),
  EmergencyContact(id: 'r4', name: 'Insurance Hotline AIA', phone: '1800', category: ContactCategory.roadSafety, address: 'Phnom Penh', hours: '08:00–20:00'),
  EmergencyContact(id: 'r5', name: 'Towing Service PP', phone: '+85512555333', category: ContactCategory.roadSafety, address: 'Phnom Penh', hours: '24/7'),

  // Family / Friends (mock)
  EmergencyContact(id: 'fam1', name: 'Dad', phone: '+7779534012', category: ContactCategory.family),
  EmergencyContact(id: 'fam2', name: 'Mom', phone: '+9778019883', category: ContactCategory.family),
  EmergencyContact(id: 'fam3', name: 'Brother', phone: '+9496178973', category: ContactCategory.family),
  EmergencyContact(id: 'fam4', name: 'Angel', phone: '+6282909975', category: ContactCategory.family),
  EmergencyContact(id: 'fam5', name: 'Akshay', phone: '+9956422219', category: ContactCategory.family),
  EmergencyContact(id: 'fam6', name: 'Maria', phone: '+6282965975', category: ContactCategory.family),
  EmergencyContact(id: 'fam7', name: 'Tomas', phone: '+9455422219', category: ContactCategory.family),
];