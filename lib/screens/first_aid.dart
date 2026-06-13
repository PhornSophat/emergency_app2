import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// --- DATA STRUCTURE FOR FIRST AID ITEMS ---
class FirstAidItem {
  final String title;
  final String category;
  final IconData icon;
  final Color iconColor;
  final String youtubeUrl;
  final List<String> steps;

  const FirstAidItem({
    required this.title,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.youtubeUrl,
    required this.steps,
  });
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
      category: 'Life-Threatening',
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
    ),
    FirstAidItem(
      title: 'Shock Treatment',
      category: 'Life-Threatening',
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
    ),
    FirstAidItem(
      title: 'Stroke - FAST Method',
      category: 'Life-Threatening',
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
    ),
    FirstAidItem(
      title: 'Severe Allergic Reaction (Anaphylaxis)',
      category: 'Life-Threatening',
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
    ),

    // 2. COMMON INJURIES
    FirstAidItem(
      title: 'Fractures and Broken Bones',
      category: 'Common Injuries',
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
    ),
    FirstAidItem(
      title: 'Burns Treatment',
      category: 'Common Injuries',
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
    ),
    FirstAidItem(
      title: 'Seizures',
      category: 'Common Injuries',
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
    ),

    // 3. ENVIRONMENTAL / HAZARDS
    FirstAidItem(
      title: 'Poisoning Emergencies',
      category: 'Hazards',
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
    ),
    FirstAidItem(
      title: 'Venomous Snakebites',
      category: 'Hazards',
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
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // --- FILTER & SEARCH PROCESSING ENGINE ---
    final filteredGuides = _allGuides.where((guide) {
      final matchesSearch = guide.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          guide.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "All" || guide.category == _selectedCategory;
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
                  'https://images.unsplash.com/photo-1581094288338-2314dddb7ece?auto=format&fit=crop&w=600&q=80',
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
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, -10),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading Title
                        const Text(
                          'Explore Guide',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFDC2626),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'A central hub for users to discover safety tips, immediate response protocols, and emergency procedures.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.5),
                        ),
                        const SizedBox(height: 24),

                        // --- NEW: SPEED EMERGENCY CALK GRID (CAMBODIA DIALS) ---
                        const Text(
                          'Emergency Hotlines',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildEmergencyDialCard(
                                title: 'Ambulance',
                                phone: '119',
                                icon: Icons.local_hospital,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildEmergencyDialCard(
                                title: 'Police',
                                phone: '117',
                                icon: Icons.local_police,
                                color: const Color(0xFF2563EB),
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
                            hintText: 'Search first aid treatments...',
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
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
                            children: ["All", "Life-Threatening", "Common Injuries", "Hazards"].map((category) {
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                  selectedColor: const Color(0xFFDC2626),
                                  backgroundColor:  Theme.of(context).dividerColor,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF475569),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No matching medical guides found.',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                              ),
                            ),
                          )
                        else
                          ...filteredGuides.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            return FirstAidAccordionCard(
                              key: ValueKey('${item.title}_$idx'), // Dynamic unique state protection
                              title: item.title,
                              category: item.category,
                              icon: item.icon,
                              iconColor: item.iconColor,
                              youtubeUrl: item.youtubeUrl,
                              steps: item.steps,
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
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
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
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
              Text(phone, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color, height: 1.2)),
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
  final bool initiallyExpanded;

  const FirstAidAccordionCard({
    super.key,
    required this.title,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.youtubeUrl,
    required this.steps,
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
    _videoId = YoutubePlayerController.convertUrlToId(widget.youtubeUrl) ?? 'TsJ49Np3HS0';
    
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
          color: _isExpanded ? const Color(0xFFDC2626) : const Color(0xFFF1F5F9), 
          width: _isExpanded ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isExpanded ? 0.05 : 0.02),
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
              color: widget.iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: widget.iconColor, size: 24),
          ),
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                  ),
                  child: Text(
                    widget.category,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
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
                        child: CircularProgressIndicator(color: Color(0xFFDC2626)),
                      ),
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Steps:',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
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
                                  margin: const EdgeInsets.only(top: 2, right: 14),
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$index',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    stepText,
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, height: 1.5),
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