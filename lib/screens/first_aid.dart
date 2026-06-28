import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../providers/app_preferences_provider.dart';

// --- DATA STRUCTURE FOR FIRST AID ITEMS ---
class FirstAidItem {
  final String title;
  final String titleKm;
  final String category;
  final String categoryKm;
  final IconData icon;
  final Color iconColor;
  final String youtubeUrl;
  final List<String> steps;
  final List<String> stepsKm;

  const FirstAidItem({
    required this.title,
    required this.titleKm,
    required this.category,
    required this.categoryKm,
    required this.icon,
    required this.iconColor,
    required this.youtubeUrl,
    required this.steps,
    required this.stepsKm,
  });

  String titleFor(bool isKhmer) => isKhmer ? titleKm : title;
  String categoryFor(bool isKhmer) => isKhmer ? categoryKm : category;
  List<String> stepsFor(bool isKhmer) => isKhmer ? stepsKm : steps;
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = "";
  String _selectedCategory = "All";

  // --- COMPREHENSIVE FIRST AID DATA SEED ---
  final List<FirstAidItem> _allGuides = const [
    // 1. LIFE-THREATENING
    FirstAidItem(
      title: 'DRSABCD Response Plan',
      titleKm: 'ផែនការឆ្លើយតប DRSABCD',
      category: 'Life-Threatening',
      categoryKm: 'គំរាមកំហែងជីវិត',
      icon: Icons.health_and_safety,
      iconColor: Colors.red,
      youtubeUrl: 'https://www.youtube.com/watch?v=8MOPr4moad4',
      steps: [
        'Danger: Ensure the area is safe for yourself, bystanders, and the patient.',
        'Response: Check if the patient is conscious by talking loudly or squeezing their shoulders.',
        'Send: Call emergency services immediately (119 for Ambulance in Cambodia).',
        'Airway: Open the mouth and check for blockages. Tilt the head back gently.',
        'Breathing: Look, listen, and feel for normal breathing for no more than 10 seconds.',
        'CPR: If not breathing, start cycles of 30 chest compressions and 2 rescue breaths.',
        'Defibrillation: Attach an AED as soon as available and follow its voice prompts.',
      ],
      stepsKm: [
        'គ្រោះថ្នាក់៖ ពិនិត្យឱ្យប្រាកដថាតំបន់ជុំវិញមានសុវត្ថិភាពសម្រាប់អ្នក អ្នកជុំវិញ និងអ្នកជំងឺ។',
        'ការឆ្លើយតប៖ ពិនិត្យថាអ្នកជំងឺដឹងខ្លួនឬអត់ ដោយហៅឱ្យខ្លាំង ឬច្របាច់ស្មារថ្នមៗ។',
        'ហៅជំនួយ៖ ហៅសេវាសង្គ្រោះបន្ទាន់ភ្លាមៗ (119 សម្រាប់រថយន្តសង្គ្រោះនៅកម្ពុជា)។',
        'ផ្លូវដង្ហើម៖ បើកមាត់ ពិនិត្យវត្ថុរាំងស្ទះ ហើយផ្អៀងក្បាលទៅក្រោយថ្នមៗ។',
        'ការដកដង្ហើម៖ មើល ស្តាប់ និងមានអារម្មណ៍ថាដកដង្ហើមធម្មតាឬអត់ មិនលើសពី 10 វិនាទី។',
        'CPR៖ បើមិនដកដង្ហើម ចាប់ផ្តើមសង្កត់ទ្រូង 30 ដង និងផ្លុំខ្យល់ 2 ដងជាវដ្ត។',
        'AED៖ ភ្ជាប់ឧបករណ៍ AED នៅពេលមាន ហើយអនុវត្តតាមសំឡេងណែនាំរបស់វា។',
      ],
    ),
    FirstAidItem(
      title: 'Shock Treatment',
      titleKm: 'ការជួយសង្គ្រោះពេលស្ហុក',
      category: 'Life-Threatening',
      categoryKm: 'គំរាមកំហែងជីវិត',
      icon: Icons.flash_on,
      iconColor: Colors.red,
      youtubeUrl: 'https://www.youtube.com/watch?v=X9006GvN69U',
      steps: [
        'Lay the person down flat on their back immediately.',
        'Elevate their feet and legs slightly (about 12 inches) to keep blood flowing to vital organs.',
        'Keep them warm and comfortable by covering them with a blanket or coat.',
        'Loosen tight clothing around their neck, chest, and waist.',
        'Do not give them anything to eat or drink, even if they complain of thirst.',
        'Monitor their breathing constantly until medical help arrives.',
      ],
      stepsKm: [
        'ឱ្យអ្នកជំងឺគេងផ្ដេកលើខ្នងភ្លាមៗ។',
        'លើកជើងឡើងបន្តិច ប្រហែល 30 សង់ទីម៉ែត្រ ដើម្បីជួយឱ្យឈាមហូរទៅសរីរាង្គសំខាន់ៗ។',
        'រក្សាឱ្យក្តៅ និងមានផាសុកភាព ដោយគ្របភួយ ឬអាវ។',
        'បន្ធូរសម្លៀកបំពាក់តឹងៗនៅក ក ទ្រូង និងចង្កេះ។',
        'កុំឱ្យញ៉ាំ ឬផឹកអ្វី ទោះបីគាត់ស្រេកទឹកក៏ដោយ។',
        'តាមដានការដកដង្ហើមជាបន្តបន្ទាប់រហូតដល់ជំនួយវេជ្ជសាស្ត្រមកដល់។',
      ],
    ),
    FirstAidItem(
      title: 'Stroke - FAST Method',
      titleKm: 'ស្ទះសរសៃឈាមខួរក្បាល - វិធី FAST',
      category: 'Life-Threatening',
      categoryKm: 'គំរាមកំហែងជីវិត',
      icon: Icons.psychology,
      iconColor: Colors.red,
      youtubeUrl: 'https://www.youtube.com/watch?v=pcmGChfU6kw',
      steps: [
        'Face: Ask the person to smile. Check if one side of their face droops or is numb.',
        'Arms: Ask them to raise both arms. Check if one arm drifts downward or feels weak.',
        'Speech: Ask them to repeat a simple sentence. Listen for slurred or strange speech.',
        'Time: If they show any of these signs, call emergency services immediately.',
        'Note the exact time when symptoms first appeared; this is critical for hospital treatment.',
      ],
      stepsKm: [
        'មុខ៖ សុំឱ្យគាត់ញញឹម ហើយពិនិត្យថាផ្នែកមួយនៃមុខធ្លាក់ ឬស្ពឹកឬអត់។',
        'ដៃ៖ សុំឱ្យលើកដៃទាំងពីរ ហើយពិនិត្យថាដៃមួយធ្លាក់ចុះ ឬខ្សោយឬអត់។',
        'សំដី៖ សុំឱ្យនិយាយប្រយោគងាយមួយ ហើយស្តាប់ថាមានសំដីមិនច្បាស់ ឬចម្លែកឬអត់។',
        'ពេលវេលា៖ បើមានសញ្ញាទាំងនេះ ហៅសេវាសង្គ្រោះបន្ទាន់ភ្លាមៗ។',
        'កត់ត្រាពេលវេលាពិតដែលរោគសញ្ញាចាប់ផ្តើម ព្រោះវាសំខាន់សម្រាប់ការព្យាបាលនៅមន្ទីរពេទ្យ។',
      ],
    ),
    FirstAidItem(
      title: 'Severe Allergic Reaction (Anaphylaxis)',
      titleKm: 'ប្រតិកម្មអាឡែស៊ីធ្ងន់ធ្ងរ',
      category: 'Life-Threatening',
      categoryKm: 'គំរាមកំហែងជីវិត',
      icon: Icons.error,
      iconColor: Colors.red,
      youtubeUrl: 'https://www.youtube.com/watch?v=X0f_pG2mYkg',
      steps: [
        'Help the person sit up comfortably if they are experiencing breathing difficulties.',
        'Ask if they carry an epinephrine auto-injector (EpiPen) and assist them in using it.',
        'Inject the auto-injector firmly into the outer middle thigh and hold for 3 seconds.',
        'Call 119 for an emergency ambulance immediately.',
        'Lay them flat with legs raised if they feel dizzy, pale, or weak.',
      ],
      stepsKm: [
        'ជួយឱ្យគាត់អង្គុយឱ្យស្រួល ប្រសិនបើមានបញ្ហាដកដង្ហើម។',
        'សួរថាគាត់មានឧបករណ៍ចាក់អេពីនេហ្វ្រីន (EpiPen) ឬអត់ ហើយជួយប្រើវា។',
        'ចាក់ឧបករណ៍ទៅផ្នែកខាងក្រៅកណ្ដាលភ្លៅឱ្យមាំ ហើយទុក 3 វិនាទី។',
        'ហៅ 119 សម្រាប់រថយន្តសង្គ្រោះបន្ទាន់ភ្លាមៗ។',
        'ឱ្យគេងផ្ដេក និងលើកជើង ប្រសិនបើគាត់វិលមុខ ស្លេក ឬខ្សោយ។',
      ],
    ),

    // 2. COMMON INJURIES
    FirstAidItem(
      title: 'Fractures and Broken Bones',
      titleKm: 'បាក់ឆ្អឹង និងឆ្អឹងប្រេះ',
      category: 'Common Injuries',
      categoryKm: 'របួសទូទៅ',
      icon: Icons.healing,
      iconColor: Colors.green,
      youtubeUrl: 'https://www.youtube.com/watch?v=TsJ49Np3HS0',
      steps: [
        'Do not attempt to push a protruding bone back into place or realign the limb.',
        'Control any external bleeding by applying clean pressure around the wound, not directly on the bone.',
        'Immobilize the injured area using a splint or sling to prevent movement.',
        'Apply an ice pack wrapped in a cloth to reduce painful swelling.',
        'Keep the patient calm and comfortable until an X-ray can be completed.',
      ],
      stepsKm: [
        'កុំព្យាយាមរុញឆ្អឹងដែលលេចចេញចូលវិញ ឬតម្រង់អវយវៈដោយខ្លួនឯង។',
        'បើមានឈាមហូរ ចុចដោយក្រណាត់ស្អាតជុំវិញរបួស មិនចុចផ្ទាល់លើឆ្អឹង។',
        'អប់តំបន់របួសដោយឧបករណ៍អប់ឆ្អឹង ឬខ្សែព្យួរដៃ ដើម្បីកុំឱ្យចលនា។',
        'ដាក់ថង់ទឹកកកដែលរុំក្រណាត់ ដើម្បីបន្ថយការឈឺ និងហើម។',
        'រក្សាឱ្យអ្នកជំងឺស្ងប់ និងមានផាសុកភាព រហូតដល់អាចថត X-ray បាន។',
      ],
    ),
    FirstAidItem(
      title: 'Burns Treatment',
      titleKm: 'ការព្យាបាលរលាក',
      category: 'Common Injuries',
      categoryKm: 'របួសទូទៅ',
      icon: Icons.local_fire_department,
      iconColor: Colors.orange,
      youtubeUrl: 'https://www.youtube.com/watch?v=HGBBu4zr8sM',
      steps: [
        'Cool the burn immediately under cool, running tap water for at least 10 to 20 minutes.',
        'Remove any jewelry, watches, or restrictive clothing near the area before swelling begins.',
        'Do not remove clothing that is melted or stuck directly onto the burn wound.',
        'Cover the burn loosely with a clean, non-stick sterile dressing or plastic wrap.',
        'Never apply butter, ice, oils, pastes, or traditional ointments to a fresh burn.',
      ],
      stepsKm: [
        'ធ្វើឱ្យតំបន់រលាកត្រជាក់ភ្លាមៗក្រោមទឹកហូរត្រជាក់រយៈពេល 10 ទៅ 20 នាទី។',
        'ដោះគ្រឿងអលង្ការ នាឡិកា ឬសម្លៀកបំពាក់តឹងៗជិតតំបន់រលាក មុនពេលវាហើម។',
        'កុំដោះសម្លៀកបំពាក់ដែលរលាយ ឬជាប់ផ្ទាល់នឹងរបួសរលាក។',
        'គ្របរបួសរលាកដោយក្រណាត់ស្អាតមិនជាប់របួស ឬប្លាស្ទិកវេជ្ជសាស្ត្រ។',
        'កុំលាបប៊ឺ ទឹកកក ប្រេង ម្សៅ ឬថ្នាំបុរាណលើរបួសរលាកថ្មី។',
      ],
    ),
    FirstAidItem(
      title: 'Seizures',
      titleKm: 'ប្រកាច់',
      category: 'Common Injuries',
      categoryKm: 'របួសទូទៅ',
      icon: Icons.info,
      iconColor: Colors.amber,
      youtubeUrl: 'https://www.youtube.com/watch?v=M9N_Zf362Gg',
      steps: [
        'Gently guide the person to the floor to prevent a dangerous fall.',
        'Clear the immediate area of sharp objects, hard furniture, or hazards.',
        'Place something soft and flat, like a folded jacket, under their head.',
        'Loosen any tight clothing or collars around their neck.',
        'Never force anything into their mouth or try to hold their tongue down.',
        'Turn them gently onto their side once jerking stops to keep their airway clear.',
      ],
      stepsKm: [
        'ជួយណែនាំឱ្យគាត់ធ្លាក់ចុះលើដីដោយថ្នមៗ ដើម្បីការពារការដួលគ្រោះថ្នាក់។',
        'យកវត្ថុមុត គ្រឿងសង្ហារឹមរឹង ឬវត្ថុគ្រោះថ្នាក់ចេញពីជុំវិញ។',
        'ដាក់អ្វីមួយទន់ និងរាប ដូចជាអាវបត់ ក្រោមក្បាល។',
        'បន្ធូរសម្លៀកបំពាក់ ឬកអាវដែលតឹងជុំវិញក។',
        'កុំដាក់អ្វីចូលក្នុងមាត់ និងកុំចាប់អណ្ដាត។',
        'បង្វិលគាត់ទៅជំហៀងថ្នមៗបន្ទាប់ពីការកន្ត្រាក់ឈប់ ដើម្បីរក្សាផ្លូវដង្ហើមឱ្យបើក។',
      ],
    ),

    // 3. ENVIRONMENTAL / HAZARDS
    FirstAidItem(
      title: 'Poisoning Emergencies',
      titleKm: 'គ្រោះថ្នាក់ពុល',
      category: 'Hazards',
      categoryKm: 'គ្រោះថ្នាក់',
      icon: Icons.warning,
      iconColor: Colors.purple,
      youtubeUrl: 'https://www.youtube.com/watch?v=1ea7_t9Xb-A',
      steps: [
        'Identify what substance was swallowed, inhaled, or touched, and how much.',
        'If the person is unconscious or struggling to breathe, call emergency help immediately.',
        'Do not induce vomiting unless explicitly instructed to do so by a medical professional.',
        'If toxic chemical splashes into eyes, rinse gently with clean water for 15 minutes.',
        'If on the skin, remove contaminated clothing and wash the skin thoroughly with soap and water.',
      ],
      stepsKm: [
        'កំណត់ថាសារធាតុអ្វីត្រូវបានលេប ស្រូប ឬប៉ះ និងបរិមាណប៉ុន្មាន។',
        'បើអ្នកជំងឺសន្លប់ ឬដកដង្ហើមលំបាក ហៅជំនួយបន្ទាន់ភ្លាមៗ។',
        'កុំបង្ខំឱ្យក្អួត លុះត្រាតែអ្នកជំនាញវេជ្ជសាស្ត្របញ្ជាក់ឱ្យធ្វើ។',
        'បើសារធាតុគីមីចូលភ្នែក លាងដោយទឹកស្អាតថ្នមៗ 15 នាទី។',
        'បើប៉ះលើស្បែក ដោះសម្លៀកបំពាក់ដែលកខ្វក់ ហើយលាងស្បែកឱ្យស្អាតដោយសាប៊ូ និងទឹក។',
      ],
    ),
    FirstAidItem(
      title: 'Venomous Snakebites',
      titleKm: 'ពស់ពុលខាំ',
      category: 'Hazards',
      categoryKm: 'គ្រោះថ្នាក់',
      icon: Icons.bug_report,
      iconColor: Colors.purple,
      youtubeUrl: 'https://www.youtube.com/watch?v=34wRAn_0gZ4',
      steps: [
        'Keep the victim completely calm and still. Movement causes venom to travel faster.',
        'Immobilize the bitten limb using a splint and keep it positioned at or below heart level.',
        'Remove any tight rings, bracelets, or clothing because severe swelling will happen rapidly.',
        'Clean the bite wound gently with clean water, but do not wash away venom patterns.',
        'Never cut across the bite wound, and never try to suck venom out with your mouth.',
        'Do not apply ice or tight tourniquets. Transport immediately to a hospital with antivenom.',
      ],
      stepsKm: [
        'រក្សាឱ្យជនរងគ្រោះស្ងប់ និងនៅស្ងៀម ព្រោះចលនាធ្វើឱ្យពុលរាលដាលលឿន។',
        'អប់អវយវៈដែលត្រូវខាំ ហើយរក្សាទុកនៅកម្ពស់ស្មើ ឬទាបជាងបេះដូង។',
        'ដោះចិញ្ចៀន ខ្សែដៃ ឬសម្លៀកបំពាក់តឹងៗ ព្រោះការហើមអាចកើតឡើងលឿន។',
        'សម្អាតរបួសដោយទឹកស្អាតថ្នមៗ ប៉ុន្តែកុំលាងឱ្យបាត់ស្នាមពុលទាំងអស់។',
        'កុំកាត់របួស និងកុំបូមពុលចេញដោយមាត់។',
        'កុំដាក់ទឹកកក ឬចងរឹតខ្លាំង។ ដឹកទៅមន្ទីរពេទ្យដែលមានថ្នាំប្រឆាំងពុលភ្លាមៗ។',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AppPreferencesProvider>();
    final screenSize = MediaQuery.of(context).size;
    final isKhmer = prefs.isKhmerSelected;

    // --- FILTER & SEARCH PROCESSING ENGINE ---
    final filteredGuides = _allGuides.where((guide) {
      final title = guide.titleFor(isKhmer).toLowerCase();
      final category = guide.categoryFor(isKhmer).toLowerCase();
      final matchesSearch =
          title.contains(_searchQuery.toLowerCase()) ||
          category.contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "All" || guide.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: Stack(
        children: [
          // 1. FIXED TOP HERO IMAGE BANNER BACKGROUND
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.40,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://source.unsplash.com/900x700/?first-aid,paramedic,emergency',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. SCROLLABLE INTERACTIVE SHELF CONTENT
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.33),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading Title
                        Text(
                          prefs.translate('Explore Guide', 'មើលមគ្គុទេសក៍'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFDC2626),
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          prefs.translate(
                            'A central hub for users to discover safety tips, immediate response protocols, and emergency procedures.',
                            'មជ្ឈមណ្ឌលសម្រាប់ស្វែងរកគន្លឹះសុវត្ថិភាព បែបបទឆ្លើយតបបន្ទាន់ និងនីតិវិធីសង្គ្រោះបន្ទាន់។',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF475569),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- NEW: SPEED EMERGENCY CALK GRID (CAMBODIA DIALS) ---
                        Text(
                          prefs.translate(
                            'Emergency Hotlines',
                            'លេខទូរស័ព្ទបន្ទាន់',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildEmergencyDialCard(
                                title: prefs.translate(
                                  'Ambulance',
                                  'រថយន្តសង្គ្រោះ',
                                ),
                                phone: '119',
                                icon: Icons.local_hospital,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildEmergencyDialCard(
                                title: prefs.translate('Police', 'ប៉ូលិស'),
                                phone: '117',
                                icon: Icons.local_police,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // --- NEW: PREMIUM FILTER SEARCH BAR ---
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: prefs.translate(
                              'Search first aid treatments...',
                              'ស្វែងរកការណែនាំបឋមព្យាបាល...',
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF64748B),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- NEW: HORIZONTAL CATEGORY FILTER CHIPS ---
                        SizedBox(
                          height: 38,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children:
                                [
                                  {
                                    'key': 'All',
                                    'label': prefs.translate('All', 'ទាំងអស់'),
                                  },
                                  {
                                    'key': 'Life-Threatening',
                                    'label': prefs.translate(
                                      'Life-Threatening',
                                      'គំរាមកំហែងជីវិត',
                                    ),
                                  },
                                  {
                                    'key': 'Common Injuries',
                                    'label': prefs.translate(
                                      'Common Injuries',
                                      'របួសទូទៅ',
                                    ),
                                  },
                                  {
                                    'key': 'Hazards',
                                    'label': prefs.translate(
                                      'Hazards',
                                      'គ្រោះថ្នាក់',
                                    ),
                                  },
                                ].map((entry) {
                                  final category = entry['key'] as String;
                                  final label = entry['label'] as String;
                                  final isSelected =
                                      _selectedCategory == category;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(label),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedCategory = category;
                                        });
                                      },
                                      selectedColor: const Color(0xFFDC2626),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).dividerColor,
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF475569),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      showCheckmark: false,
                                      elevation: 0,
                                      pressElevation: 0,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- DYNAMIC INSTRUCTION CARD LIST RENDERING ---
                        if (filteredGuides.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                prefs.translate(
                                  'No matching medical guides found.',
                                  'មិនមានមគ្គុទេសក៍វេជ្ជសាស្ត្រដែលត្រូវគ្នា។',
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ...filteredGuides.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            return FirstAidAccordionCard(
                              key: ValueKey(
                                '${item.title}_${isKhmer}_$idx',
                              ), // Dynamic unique state protection
                              title: item.titleFor(isKhmer),
                              category: item.categoryFor(isKhmer),
                              icon: item.icon,
                              iconColor: item.iconColor,
                              youtubeUrl: item.youtubeUrl,
                              steps: item.stepsFor(isKhmer),
                              stepsLabel: prefs.translate('Steps:', 'ជំហាន៖'),
                              initiallyExpanded: false,
                            );
                          }),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Dialer Widget Builder
  Widget _buildEmergencyDialCard({
    required String title,
    required String phone,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- STATEFUL COMPONENT: ACCORDION CARD CONTEXT PRESERVING CONTROLLER ---
class FirstAidAccordionCard extends StatefulWidget {
  final String title;
  final String category;
  final IconData icon;
  final Color iconColor;
  final String youtubeUrl;
  final List<String> steps;
  final String stepsLabel;
  final bool initiallyExpanded;

  const FirstAidAccordionCard({
    super.key,
    required this.title,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.youtubeUrl,
    required this.steps,
    required this.stepsLabel,
    this.initiallyExpanded = false,
  });

  @override
  State<FirstAidAccordionCard> createState() => _FirstAidAccordionCardState();
}

class _FirstAidAccordionCardState extends State<FirstAidAccordionCard> {
  late bool _isExpanded;
  YoutubePlayerController? _webController;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _videoId =
        YoutubePlayerController.convertUrlToId(widget.youtubeUrl) ??
        'TsJ49Np3HS0';

    if (_isExpanded) {
      _initPlayer();
    }
  }

  void _initPlayer() {
    if (_webController != null) return;

    _webController = YoutubePlayerController.fromVideoId(
      videoId: _videoId!,
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        pointerEvents: PointerEvents.auto,
      ),
    );
  }

  @override
  void dispose() {
    _webController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isExpanded
              ? const Color(0xFFDC2626)
              : const Color(0xFFF1F5F9),
          width: _isExpanded ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isExpanded ? 0.05 : 0.02),
            blurRadius: _isExpanded ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: theme.colorScheme.onSurfaceVariant,
            size: 28,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });

            if (expanded) {
              setState(() {
                _initPlayer();
              });
              _webController?.playVideo();
            } else {
              _webController?.pauseVideo();
              setState(() {
                _webController = null;
              });
            }
          },
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: widget.iconColor, size: 24),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isExpanded && _webController != null)
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: YoutubePlayer(
                        key: UniqueKey(),
                        controller: _webController!,
                        aspectRatio: 16 / 9,
                      ),
                    )
                  else
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stepsLabel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...widget.steps.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          String stepText = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 2,
                                    right: 14,
                                  ),
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC2626),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$index',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    stepText,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
