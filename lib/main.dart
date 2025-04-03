import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'animations/background_animation.dart';
//import 'animations/skill_card_animation.dart';

void main() {
  runApp(const MyPortfolio());
}

class MyPortfolio extends StatelessWidget {
  const MyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548), // Warm Brown
          brightness: Brightness.light,
          primary: const Color(0xFF795548), // Warm Brown
          secondary: const Color(0xFF8D6E63), // Light Brown
          tertiary: const Color(0xFF6D4C41), // Dark Brown
          surface: const Color(0xFFF5E6D3), // Light Beige
          background: const Color(0xFFF5E6D3), // Light Beige
          primaryContainer: const Color(0xFFD7CCC8), // Muted Brown
          secondaryContainer: const Color(0xFFE0D5D0), // Light Muted Brown
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF795548), // Warm Brown
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF795548), // Warm Brown
            foregroundColor: Colors.white,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFE0D5D0), // Light Muted Brown
          selectedColor: const Color(0xFFD7CCC8), // Muted Brown
          labelStyle: const TextStyle(color: Color(0xFF6D4C41)), // Dark Brown
          secondaryLabelStyle: const TextStyle(color: Color(0xFF6D4C41)), // Dark Brown
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD7CCC8)), // Muted Brown
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD7CCC8)), // Muted Brown
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF795548)), // Warm Brown
          ),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  String _activeSection = 'About';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollPosition = _scrollController.offset;
    final viewportHeight = MediaQuery.of(context).size.height;
    
    // Calculate which section is most visible
    final aboutPosition = _aboutKey.currentContext?.findRenderObject()?.paintBounds.top ?? 0;
    final projectsPosition = _projectsKey.currentContext?.findRenderObject()?.paintBounds.top ?? 0;
    final skillsPosition = _skillsKey.currentContext?.findRenderObject()?.paintBounds.top ?? 0;
    final contactPosition = _contactKey.currentContext?.findRenderObject()?.paintBounds.top ?? 0;

    final positions = {
      'About': aboutPosition,
      'Projects': projectsPosition,
      'Skills': skillsPosition,
      'Contact': contactPosition,
    };

    // Find the section closest to the top of the viewport
    String closestSection = 'About';
    double minDistance = double.infinity;

    positions.forEach((section, position) {
      final distance = (position - scrollPosition).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closestSection = section;
      }
    });

    if (closestSection != _activeSection) {
      setState(() => _activeSection = closestSection);
    }
  }

  void _scrollToProjects() {
    _scrollToSection(_projectsKey);
  }

  void _scrollToSection(GlobalKey key) {
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final viewportHeight = MediaQuery.of(context).size.height;
    
    // Calculate the target position relative to the viewport
    final targetPosition = position.dy - 80; // Account for the navigation bar height
    
    // Calculate the current scroll position
    final currentScroll = _scrollController.offset;
    
    // Calculate the distance to scroll
    final scrollDistance = targetPosition - currentScroll;
    
    // Calculate the final position
    final finalPosition = currentScroll + scrollDistance;
    
    // Ensure we don't scroll past the bottom of the content
    final maxScroll = _scrollController.position.maxScrollExtent;
    final adjustedPosition = finalPosition.clamp(0.0, maxScroll);
    
    // Animate to the target position with a custom curve
    _scrollController.animateTo(
      adjustedPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                TitleSection(onViewWorkPressed: _scrollToProjects),
                AboutSection(key: _aboutKey),
                ProjectsSection(key: _projectsKey),
                CompetenciesSection(key: _skillsKey),
                ContactSection(key: _contactKey),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _scrollToSection(_aboutKey),
                          child: Text(
                            'DA',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildNavButton('About', () => _scrollToSection(_aboutKey)),
                          _buildNavButton('Projects', () => _scrollToSection(_projectsKey)),
                          _buildNavButton('Skills', () => _scrollToSection(_skillsKey)),
                          _buildNavButton('Contact', () => _scrollToSection(_contactKey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onPressed) {
    final isActive = _activeSection == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isActive ? 24 : 0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Title Section
class TitleSection extends StatelessWidget {
  final VoidCallback onViewWorkPressed;

  const TitleSection({
    super.key,
    required this.onViewWorkPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 120),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Darrius Anthony',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Technical Artist | Graphics Programmer | Creator',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onViewWorkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('View My Work'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// About Me Section
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Me',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 4,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/Darrius.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, I\'m Darrius',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'I am a passionate developer and creative thinker specializing in building interactive applications, mainly video games. As I keep building my foundation in graphics programming and game development, I constantly explore new technologies to enhance my skills and create engaging experiences.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'My knowledge spans across:',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildSkillChip('Graphics Programming', theme),
                            _buildSkillChip('Game Development', theme),
                            _buildSkillChip('Technical Art', theme),
                            _buildSkillChip('Sound Design', theme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

// Projects Section
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  Widget _buildCategoryCard(BuildContext context, String title, String description, Widget page) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForCategory(title),
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String title) {
    switch (title) {
      case 'Game Jams':
        return Icons.games;
      case 'School Projects':
        return Icons.school;
      case 'Personal Projects':
        return Icons.work;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Projects',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
                children: [
                  _buildCategoryCard(
                    context,
                    'Game Jams',
                    'Check out my game jam projects and rapid prototyping work',
                    const GameJamsPage(),
                  ),
                  _buildCategoryCard(
                    context,
                    'School Projects',
                    'View my academic projects and coursework',
                    const SchoolProjectsPage(),
                  ),
                  _buildCategoryCard(
                    context,
                    'Personal Projects',
                    'Explore my personal projects and side work',
                    const PersonalProjectsPage(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Project Category Pages
class GameJamsPage extends StatefulWidget {
  const GameJamsPage({super.key});

  @override
  State<GameJamsPage> createState() => _GameJamsPageState();
}

class _GameJamsPageState extends State<GameJamsPage> {
  String searchQuery = '';
  String selectedTag = 'All';

  final List<Map<String, dynamic>> projects = const [
    {
      'title': 'Hardball',
      'description': 'A game created during Global Game Jam 2024. A challenging sports game where you need to hit the ball at the right time and angle.',
      'image': 'assets/images/hardball.png',
      'link': 'https://globalgamejam.org/games/2024/hardball-0',
      'tags': ['Global Game Jam', 'Sports', 'Unity', 'C#'],
    },
    {
      'title': 'Sud Enforcer 2',
      'description': 'A game created during Global Game Jam 2025. You are a bubble that must navigate through the kitchen all the way to the sink.',
      'image': 'assets/images/sud_enforcer.png',
      'link': 'https://globalgamejam.org/games/2025/sud-enforcer-2',
      'tags': ['Global Game Jam', 'Puzzle', 'Unreal', 'C++'],
    },
    {
      'title': 'Hide and Hue',
      'description': 'A color-matching platformer where you play as a chameleon trying to survive. Memorize color combinations and collect bugs while avoiding a hungry snake.',
      'image': 'assets/images/hide_and_hue.png',
      'link': 'https://mrocean.itch.io/hide-and-hue',
      'tags': ['Chillennium', 'Platformer', 'Unreal', 'C++'],
    },
    {
      'title': 'Chaos Battery',
      'description': 'A mischievous game where you play as a kid causing chaos in a grocery store. Replace eggs with avocados, change prices, and set up traps.',
      'image': 'assets/images/chaos_battery.png',
      'link': 'https://mrocean.itch.io/chaos-battery',
      'tags': ['Chillennium', 'Action', 'Unity', 'C#'],
    },
    {
      'title': 'Heart Transplant',
      'description': 'A unique bullet hell game where you battle emotions inside a brain. Switch between two characters with unique abilities to face off against difficult emotions.',
      'image': 'assets/images/heart_transplant.png',
      'link': 'https://mrocean.itch.io/heart-transpant',
      'tags': ['Chillennium', 'Bullet Hell', 'Unity', 'C#'],
    },
  ];

  List<String> get allTags {
    final Set<String> tags = {'All'};
    for (var project in projects) {
      tags.addAll(project['tags']);
    }
    return tags.toList();
  }

  List<Map<String, dynamic>> get filteredProjects {
    return projects.where((project) {
      final matchesSearch = project['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          project['description'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTag = selectedTag == 'All' || project['tags'].contains(selectedTag);
      return matchesSearch && matchesTag;
    }).toList();
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    project['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  project['title'],
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project['description'],
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (project['tags'] as List<String>).map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final Uri uri = Uri.parse(project['link']);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('Play Game'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Jams'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Jams',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                filled: true,
                fillColor: theme.colorScheme.primaryContainer,
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: allTags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: selectedTag == tag,
                    onSelected: (selected) => setState(() => selectedTag = tag),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: selectedTag == tag 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showProjectDetails(project),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.asset(
                                    project['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  project['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  project['description'],
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: (project['tags'] as List<String>).take(2).map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.teal[700],
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolProjectsPage extends StatefulWidget {
  const SchoolProjectsPage({super.key});

  @override
  State<SchoolProjectsPage> createState() => _SchoolProjectsPageState();
}

class _SchoolProjectsPageState extends State<SchoolProjectsPage> {
  String searchQuery = '';
  String selectedTag = 'All';

  final List<Map<String, dynamic>> projects = const [
    {
      'title': 'Graphics Engine Project',
      'description': 'A custom graphics engine implementation using OpenGL and GLSL shaders. Features include PBR materials, dynamic lighting, and post-processing effects.',
      'image': 'assets/images/graphics_project.png',
      'link': 'https://github.com/darriusisart/GraphicsEngin3999',
      'tags': ['OpenGL', 'GLSL', 'C++', 'Graphics'],
    },
    {
      'title': 'Astro UUber',
      'description': 'A space-themed game where you navigate through space, dodging obstacles while safely transporting alien passengers.',
      'image': 'assets/images/AstroUUber.png',
      'link': 'https://bjw101102.itch.io/astro-uuber',
      'tags': ['Unity', 'Game Development', 'C#', '2D Game'],
    },
  ];

  List<String> get allTags {
    final Set<String> tags = {'All'};
    for (var project in projects) {
      tags.addAll(project['tags']);
    }
    return tags.toList();
  }

  List<Map<String, dynamic>> get filteredProjects {
    return projects.where((project) {
      final matchesSearch = project['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          project['description'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTag = selectedTag == 'All' || project['tags'].contains(selectedTag);
      return matchesSearch && matchesTag;
    }).toList();
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    project['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  project['title'],
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project['description'],
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (project['tags'] as List<String>).map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final Uri uri = Uri.parse(project['link']);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('View Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Projects'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'School Projects',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                filled: true,
                fillColor: theme.colorScheme.primaryContainer,
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: allTags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: selectedTag == tag,
                    onSelected: (selected) => setState(() => selectedTag = tag),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: selectedTag == tag 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showProjectDetails(project),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.asset(
                                    project['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  project['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  project['description'],
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: (project['tags'] as List<String>).take(2).map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.teal[700],
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalProjectsPage extends StatefulWidget {
  const PersonalProjectsPage({super.key});

  @override
  State<PersonalProjectsPage> createState() => _PersonalProjectsPageState();
}

class _PersonalProjectsPageState extends State<PersonalProjectsPage> {
  String searchQuery = '';
  String selectedTag = 'All';

  final List<Map<String, dynamic>> projects = const [
    {
      'title': 'Unreal Blueprint Collection',
      'description': 'A collection of reusable Blueprint systems showcasing advanced game mechanics and systems design. Features include AI behavior trees, dynamic UI systems, and modular gameplay components.',
      'image': 'assets/images/blueprint_collection.png',
      'link': '',  // Removed external link since we're showcasing directly
      'tags': ['Unreal', 'Blueprints'],
      'blueprints': [
        {
          'name': 'Advanced AI Behavior Tree',
          'description': 'A modular behavior tree system for NPCs with dynamic pathfinding, combat states, and environmental awareness.',
          'features': ['Dynamic pathfinding', 'Combat states', 'Environmental awareness', 'Modular design'],
          'preview': 'assets/images/blueprints/ai_behavior_tree.png'
        },
        {
          'name': 'Dynamic UI Framework',
          'description': 'A flexible UI system with animated transitions, dynamic content loading, and responsive layouts.',
          'features': ['Animated transitions', 'Dynamic content', 'Responsive layouts', 'Theme support'],
          'preview': 'assets/images/blueprints/ui_framework.png'
        },
        {
          'name': 'Combat System',
          'description': 'A comprehensive combat system featuring hit detection, damage calculation, and combo mechanics.',
          'features': ['Hit detection', 'Damage system', 'Combo mechanics', 'Animation integration'],
          'preview': 'assets/images/blueprints/combat_system.png'
        }
      ]
    },
    {
      'title': 'Technical Documentation',
      'description': 'A detailed Obsidian vault containing technical documentation, tutorials, and best practices for game development, graphics programming, and shader development.',
      'image': 'assets/images/obsidian_docs.png',
      'link': 'https://github.com/darriusisart/technical-docs',
      'tags': ['Documentation'],
    },
    {
      'title': 'Shader Library',
      'description': 'A collection of custom shaders for Unity, Unreal Engine, and OpenGL including post-processing effects, materials, and visual effects.',
      'image': 'assets/images/shader_library.png',
      'link': 'https://github.com/darriusisart/shader-library',
      'tags': ['HLSL', 'GLSL', 'Unity', 'Unreal'],
    },
  ];

  List<String> get allTags {
    final Set<String> tags = {'All'};
    for (var project in projects) {
      tags.addAll(project['tags']);
    }
    return tags.toList();
  }

  List<Map<String, dynamic>> get filteredProjects {
    return projects.where((project) {
      final matchesSearch = project['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          project['description'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTag = selectedTag == 'All' || project['tags'].contains(selectedTag);
      return matchesSearch && matchesTag;
    }).toList();
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    project['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  project['title'],
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project['description'],
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (project['tags'] as List<String>).map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  )).toList(),
                ),
                if (project['blueprints'] != null) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Blueprint Systems',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...(project['blueprints'] as List<Map<String, dynamic>>).map((blueprint) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (blueprint['preview'] != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            child: Image.asset(
                              blueprint['preview'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                color: theme.colorScheme.primaryContainer,
                                child: Icon(Icons.error_outline, size: 50, color: theme.colorScheme.primary),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blueprint['name'],
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                blueprint['description'],
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (blueprint['features'] as List<String>).map((feature) => Chip(
                                  label: Text(feature),
                                  backgroundColor: theme.colorScheme.primaryContainer,
                                  labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Projects'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Projects',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search projects...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.primaryContainer,
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: allTags.map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tag),
                        selected: selectedTag == tag,
                        onSelected: (selected) => setState(() => selectedTag = tag),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: selectedTag == tag 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = filteredProjects[index];
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _showProjectDetails(project),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.asset(
                                      project['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    project['title'],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    project['description'],
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: (project['tags'] as List<String>).take(2).map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.teal[700],
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Competencies Section
class CompetenciesSection extends StatelessWidget {
  const CompetenciesSection({super.key});

  final List<Map<String, String>> skills = const [
    {'name': 'Blender', 'icon': 'assets/icons/blender_logo.png', 'category': '3D'},
    {'name': 'C#', 'icon': 'assets/icons/c#_logo.png', 'category': 'Programming'},
    {'name': 'C++', 'icon': 'assets/icons/C++_logo.png', 'category': 'Programming'},
    {'name': 'Flutter', 'icon': 'assets/icons/flutter_logo.png', 'category': 'Development'},
    {'name': 'HTML/CSS/JS', 'icon': 'assets/icons/html_css_js_logo.png', 'category': 'Web'},
    {'name': 'HLSL/GLSL/CG', 'icon': 'assets/icons/shaderlanguages_logo.png', 'category': 'Graphics'},
    {'name': 'OpenGL', 'icon': 'assets/icons/OpenGL_logo.png', 'category': 'Graphics'},
    {'name': 'Unreal', 'icon': 'assets/icons/unreal_logo.png', 'category': 'Game Dev'},
    {'name': 'Unity', 'icon': 'assets/icons/unity_logo.png', 'category': 'Game Dev'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Technical Skills & Competencies',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: skills.map((skill) => _buildSkillCard(skill, theme)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCard(Map<String, String> skill, ThemeData theme) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  skill['icon']!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                skill['name']!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                skill['category']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Contact Section
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's Connect!",
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'I\'m always open to discussing new projects, creative ideas, or any opportunities to be part of your vision.',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  ContactButton(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email',
                    url: 'mailto:darriusanthony227@gmail.com',
                    theme: theme,
                  ),
                  ContactButton(
                    icon: FontAwesomeIcons.linkedin,
                    label: 'LinkedIn',
                    url: 'https://www.linkedin.com/in/darrius-anthony-087296224/',
                    theme: theme,
                  ),
                  ContactButton(
                    icon: FontAwesomeIcons.github,
                    label: 'GitHub',
                    url: 'https://github.com/darriusisart',
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final ThemeData theme;

  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.url,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    icon,
                    size: 32,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
