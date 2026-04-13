import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HistoryHubApp());
}

class HistoryHubApp extends StatefulWidget {
  const HistoryHubApp({super.key});

  @override
  State<HistoryHubApp> createState() => HistoryHubAppState();

  static HistoryHubAppState of(BuildContext context) =>
      context.findAncestorStateOfType<HistoryHubAppState>()!;
}

class HistoryHubAppState extends State<HistoryHubApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _parentalControlEnabled = false;
  final String _fixedParentalPin = '1234';

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  void setParentalControl(bool enabled) {
    setState(() {
      _parentalControlEnabled = enabled;
    });
  }

  void revertSettings() {
    setState(() {
      _themeMode = ThemeMode.light;
      _locale = const Locale('en');
      _parentalControlEnabled = false;
    });
  }

  bool verifyPin(String pin) => _fixedParentalPin == pin;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get currentLanguage => _locale.languageCode;
  bool get isParentalControlEnabled => _parentalControlEnabled;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HistoryHub',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown.shade800,
          secondary: Colors.orangeAccent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        ).copyWith(
          primary: Colors.brown.shade300,
          secondary: Colors.orangeAccent,
          surface: Colors.grey.shade900,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.brown.shade100,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade800,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history_edu, size: 120, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'HistoryHub',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Explore the Past, Connect the Present',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//important details
class Landmark {
  final String id;
  final String name;
  final String description;
  final String culturalContext;
  final LatLng location;
  final List<String> youtubeVideos;
  final String groupId;

  Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.culturalContext,
    required this.location,
    required this.youtubeVideos,
    required this.groupId,
  });
}

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({required this.sender, required this.text, required this.timestamp, required this.isMe});
}

class HistoryItem {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final LatLng location;

  HistoryItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.location,
  });
}

// Log in screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _login() {
    // Restricted login logic
    if (_userController.text == 'qlfulgado@tip.edu.ph' && _passController.text == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Use qlfulgado@tip.edu.ph / 123'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? null : Colors.brown.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history_edu, size: 80, color: Colors.brown),
              const SizedBox(height: 16),
              Text(isEn ? 'Welcome Back' : 'Maligayang Pagbabalik', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.brown, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: isEn ? 'Username or Email' : 'Pangalan o Email',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isEn ? 'Password' : 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEn ? 'Login' : 'Mag-log in'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: Text(isEn ? 'Don\'t have an account? Register' : 'Wala pang account? Magrehistro', style: const TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _passController = TextEditingController();
  String _selectedGender = 'Male';

  void _register() {
    // Registration
    if (_nameController.text.isNotEmpty && _passController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Please login.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.brown)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEn ? 'Create Account' : 'Gumawa ng Account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.brown, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(isEn ? 'Join the HistoryHub community' : 'Sumali sa komunidad ng HistoryHub', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: isEn ? 'Full Name' : 'Buong Pangalan',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isEn ? 'Age' : 'Edad',
                prefixIcon: const Icon(Icons.cake),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: isEn ? 'Gender' : 'Kasarian',
                prefixIcon: const Icon(Icons.people),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: (isEn ? ['Male', 'Female', 'Other'] : ['Lalaki', 'Babae', 'Iba pa']).map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedGender = newValue!);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: isEn ? 'Password' : 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isEn ? 'Register' : 'Magrehistro'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const platform = MethodChannel('com.historyhub.app/native');
  int _currentIndex = 0;
  final List<HistoryItem> _history = [];
  String _activeGroup = 'General History';
  
  @override
  void initState() {
    super.initState();
    _checkNativeStatus();
  }

  Future<void> _checkNativeStatus() async {
    try {
      final String result = await platform.invokeMethod('getNativeInfo');
      debugPrint('Native Status: $result');
    } on PlatformException catch (e) {
      debugPrint('Failed to get native info: ${e.message}');
    }
  }

  void _showNativeToast(String message) async {
    try {
      await platform.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      debugPrint('Failed to show toast: ${e.message}');
    }
  }

  void _addToHistory(HistoryItem item) {
    setState(() {
      _history.insert(0, item);
    });
    _showNativeToast('Discovered ${item.title}');
  }

  void _navigateToChat(String groupId, String landmarkName) {
    setState(() {
      _activeGroup = landmarkName;
      _currentIndex = 1; 
    });
    _showNativeToast('Entering discussion for $landmarkName');
  }

  @override
  Widget build(BuildContext context) {
    final appState = HistoryHubApp.of(context);
    final isEn = appState.currentLanguage == 'en';
    
    final List<Widget> screens = [
      MapsScreen(onAddToHistory: _addToHistory, onJoinChat: _navigateToChat),
      MessagingScreen(groupName: _activeGroup),
      HistoryScreen(history: _history, platform: platform),
      const AboutHelpScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HistoryHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1 && appState.isParentalControlEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(isEn ? 'Discussion restricted by Parental Control' : 'Bawal ang chat dahil sa Kontrol ng Magulang')),
            );
            return;
          }
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: isEn ? 'Explore' : 'Galugarin'),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum, color: appState.isParentalControlEnabled ? Colors.grey : null), 
            label: isEn ? 'Discuss' : 'Usapan'
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.history_toggle_off), label: isEn ? 'Log' : 'Kasaysayan'),
          BottomNavigationBarItem(icon: const Icon(Icons.info_outline), label: isEn ? 'About' : 'Tungkol'),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: isEn ? 'Settings' : 'Ayos'),
        ],
      ),
    );
  }
}

// Map interface
class MapsScreen extends StatefulWidget {
  final Function(HistoryItem) onAddToHistory;
  final Function(String, String) onJoinChat;

  const MapsScreen({super.key, required this.onAddToHistory, required this.onJoinChat});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final MapController _mapController = MapController();
  
  final List<Landmark> _mockLandmarks = [
    Landmark(
      id: 'tip_qc',
      name: 'T.I.P. Quezon City',
      description: 'The Technological Institute of the Philippines (T.I.P.) Quezon City campus was established to reach out to more students in the northern part of Metro Manila.',
      culturalContext: 'A leading engineering and technology school in the Philippines, known for its ABET-accredited programs.',
      location: const LatLng(14.6117, 121.0614),
      youtubeVideos: ['https://youtu.be/pKkjbckl2Rk?si=gq7C7e57DwwduMkp'],
      groupId: 'tip_qc_community',
    ),
    Landmark(
      id: 'up_diliman',
      name: 'UP Diliman Oblation',
      description: 'The iconic statue of the University of the Philippines.',
      culturalContext: 'Represents selfless offering of oneself to the country.',
      location: const LatLng(14.6533, 121.0685),
      youtubeVideos: ['https://youtu.be/upvideo'],
      groupId: 'ph_academic_history',
    ),
    Landmark(
      id: 'tip_manila',
      name: 'T.I.P. Manila',
      description: 'The Technological Institute of the Philippines (T.I.P.) was founded on February 8, 1962.',
      culturalContext: 'A premier engineering and computing institution.',
      location: const LatLng(14.5947, 120.9881),
      youtubeVideos: ['https://youtu.be/tip_video'],
      groupId: 'tip_community',
    ),
  ];

  void _showLandmarkDetails(Landmark landmark) {
    widget.onAddToHistory(HistoryItem(
      title: landmark.name,
      subtitle: 'Visited virtually',
      timestamp: DateTime.now(),
      location: landmark.location,
    ));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => LandmarkDetailsSheet(
        landmark: landmark,
        onJoinChat: widget.onJoinChat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(14.6117, 121.0614),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.historyhub.app',
          ),
          MarkerLayer(
            markers: _mockLandmarks.map((landmark) {
              return Marker(
                point: landmark.location,
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showLandmarkDetails(landmark),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Text(
                          landmark.name == 'T.I.P. Quezon City' ? 'TIP QC' : landmark.name,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.location_on, color: Colors.brown, size: 40),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(const LatLng(14.6117, 121.0614), 15.0);
        },
        child: const Icon(Icons.school),
      ),
    );
  }
}

// History section landmark TIP
class LandmarkDetailsSheet extends StatelessWidget {
  final Landmark landmark;
  final Function(String, String) onJoinChat;

  const LandmarkDetailsSheet({super.key, required this.landmark, required this.onJoinChat});

  @override
  Widget build(BuildContext context) {
    final appState = HistoryHubApp.of(context);
    final isEn = appState.currentLanguage == 'en';
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(24),
        children: [
          Text(landmark.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _sectionHeader(isEn ? 'Historical Significance' : 'Makasaysayang Kahalagahan', context),
          Text(landmark.description),
          const SizedBox(height: 16),
          _sectionHeader(isEn ? 'Cultural Context' : 'Kontekstong Kultural', context),
          Text(landmark.culturalContext),
          const SizedBox(height: 24),
          _sectionHeader(isEn ? 'Visual Tour' : 'Biswal na Paglilibot', context),
          _YouTubePlayerMimic(videoUrl: landmark.youtubeVideos.isNotEmpty ? landmark.youtubeVideos.first : ""),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (appState.isParentalControlEnabled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn 
                    ? 'Discussion restricted by Parental Control' 
                    : 'Bawal ang chat dahil sa Kontrol ng Magulang')),
                );
                return;
              }
              Navigator.pop(context);
              onJoinChat(landmark.groupId, landmark.name);
            },
            child: Text(
              isEn ? 'Join Group Discussion' : 'Sumali sa Talakayan',
              style: const TextStyle(fontSize: 18)
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title, 
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: Theme.of(context).colorScheme.primary
        )
      ),
    );
  }
}

// Youtube section
class _YouTubePlayerMimic extends StatefulWidget {
  final String videoUrl;
  const _YouTubePlayerMimic({required this.videoUrl});

  @override
  State<_YouTubePlayerMimic> createState() => _YouTubePlayerMimicState();
}

class _YouTubePlayerMimicState extends State<_YouTubePlayerMimic> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? 'pKkjbckl2Rk';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final uri = Uri.parse(widget.videoUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Row(
            children: [
              const Icon(Icons.link, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.videoUrl,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Source: HistoryHub Educational Archive',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

// Discussion section
class MessagingScreen extends StatefulWidget {
  final String groupName;
  const MessagingScreen({super.key, required this.groupName});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late List<Message> _messages;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = [
      Message(
        sender: 'HistoryBot',
        text: 'Welcome to the ${widget.groupName} study session!',
        timestamp: DateTime.now(),
        isMe: false,
      ),
    ];
  }

  @override
  void didUpdateWidget(MessagingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupName != widget.groupName) {
      setState(() {
        _messages.add(Message(
          sender: 'System',
          text: '--- Switched to ${widget.groupName} ---',
          timestamp: DateTime.now(),
          isMe: false,
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(
        sender: 'You',
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      _textController.clear();
    });
    _scrollToBottom();
    _handleBotResponse(text);
  }

  void _handleBotResponse(String userText) {
    String response = "";
    final input = userText.toLowerCase();
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';

    if (input.contains("hi") || input.contains("hello") || input.contains("hey")) {
      response = isEn 
        ? "Hello! I'm your HistoryBot guide. Ready to explore the past today?"
        : "Halo! Ako ang iyong HistoryBot guide. Handa ka na bang galugarin ang nakaraan ngayong araw?";
    } else if (input.contains("vocab") || input.contains("word") || input.contains("learn")) {
      final vocabsEn = [
        "**Archaeology**: The study of human history and prehistory through the excavation of sites.",
        "**Artifact**: An object made by a human being, typically one of cultural or historical interest.",
        "**Chronicle**: A factual written account of important or historical events in the order of their occurrence.",
        "**Heritage**: Valued objects and qualities such as cultural traditions and historic buildings passed down from previous generations.",
      ];
      final vocabsFil = [
        "**Arkeolohiya**: Ang pag-aaral ng kasaysayan ng tao at pre-history sa pamamagitan ng paghuhukay ng mga site.",
        "**Artifact**: Isang bagay na gawa ng tao, karaniwang may kultura o makasaysayang interes.",
        "**Kronika**: Isang makatotohanang nakasulat na ulat ng mahahalagang kaganapan sa pagkakasunod-sunod nito.",
        "**Pamana**: Mahahalagang bagay at katangian tulad ng mga tradisyong pangkultura at makasaysayang gusali.",
      ];
      response = isEn 
        ? "Let's expand your vocabulary! Here is a word for you:\n\n${vocabsEn[DateTime.now().second % vocabsEn.length]}"
        : "Palawakin natin ang iyong bokabularyo! Narito ang isang salita para sa iyo:\n\n${vocabsFil[DateTime.now().second % vocabsFil.length]}";
    } else if (input.contains("tip") || input.contains("technological institute")) {
      response = isEn
        ? "T.I.P. was founded in 1962! It started with only 80 students and has now grown into a major educational institution in the Philippines. Did you know its founders were Engr. Demetrio Quirino, Jr. and Dr. Teresita Quirino?"
        : "Ang T.I.P. ay itinatag noong 1962! Nagsimula ito sa 80 mag-aaral lamang at ngayon ay naging isang malaking institusyong pang-edukasyon sa Pilipinas. Alam mo ba na ang mga tagapagtatag nito ay sina Engr. Demetrio Quirino, Jr. at Dr. Teresita Quirino?";
    } else if (input.contains("fact")) {
      final factsEn = [
        "The Great Wall of China is not actually visible from the moon with the naked eye!",
        "Cleopatra lived closer to the invention of the iPhone than the building of the Great Pyramid.",
        "The shortest war in history lasted only 38 minutes between Britain and Zanzibar in 1896.",
        "Ancient Romans used to wash their clothes in urine. It was a source of ammonia!",
      ];
      final factsFil = [
        "Ang Great Wall of China ay hindi talaga nakikita mula sa buwan gamit ang mata lamang!",
        "Mas malapit ang buhay ni Cleopatra sa imbensyon ng iPhone kaysa sa pagtatayo ng Great Pyramid.",
        "Ang pinakamaikling digmaan sa kasaysayan ay tumagal lamang ng 38 minuto sa pagitan ng Britain at Zanzibar noong 1896.",
        "Ang mga sinaunang Romano ay naglalaba ng kanilang mga damit sa ihi. Ito ay pinagkukunan ng ammonia!",
      ];
      response = isEn ? factsEn[DateTime.now().second % factsEn.length] : factsFil[DateTime.now().second % factsFil.length];
    } else {
      response = isEn 
        ? "That's fascinating! History is all about perspectives. What specifically interests you about ${widget.groupName}?"
        : "Kamangha-mangha! Ang kasaysayan ay tungkol sa mga pananaw. Ano ang partikular na kinagigiliwan mo tungkol sa ${widget.groupName}?";
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(Message(
            sender: 'HistoryBot',
            text: response,
            timestamp: DateTime.now(),
            isMe: false,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupName} ${isEn ? "Chat" : "Usapan"}'),
        backgroundColor: isDark ? null : Colors.brown.shade50,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isMe 
                          ? Colors.brown 
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isMe) 
                          Text(
                            msg.sender == 'You' ? (isEn ? 'You' : 'Ikaw') : msg.sender, 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 12, 
                              color: isDark ? Colors.brown.shade200 : Colors.brown
                            )
                          ),
                        Text(
                          msg.text, 
                          style: TextStyle(
                            color: msg.isMe || isDark ? Colors.white : Colors.black87
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: isEn ? 'Discuss with others...' : 'Makipag-usap sa iba...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.brown,
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _sendMessage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// About and Help screen
class AboutHelpScreen extends StatelessWidget {
  const AboutHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'About & Help' : 'Tungkol at Tulong'),
        backgroundColor: isDark ? null : Colors.brown.shade50,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(isEn ? 'About HistoryHub' : 'Tungkol sa HistoryHub', context),
          Text(
            isEn 
              ? 'HistoryHub is a location-based social learning platform designed to connect people with the rich history and culture of their surroundings. Explore landmarks, join discussions, and discover the past like never before.'
              : 'Ang HistoryHub ay isang location-based na social learning platform na idinisenyo upang ikonekta ang mga tao sa mayamang kasaysayan at kultura ng kanilang paligid. Galugarin ang mga palatandaan, sumali sa mga talakayan, at tuklasin ang nakaraan nang hindi kailanman nagawa.',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(isEn ? 'Help & FAQs' : 'Tulong at mga FAQ', context),
          _buildExpansionTile(
            isEn ? 'How do I explore landmarks?' : 'Paano ko ginalugad ang mga palatandaan?',
            isEn 
              ? 'Simply go to the Explore tab and use the interactive map to find markers. Tap on a marker to see historical details.'
              : 'Pumunta lamang sa tab na Explore at gamitin ang interactive na mapa upang makahanap ng mga marker. I-tap ang isang marker upang makita ang mga detalye ng kasaysayan.',
          ),
          _buildExpansionTile(
            isEn ? 'How do I join a discussion?' : 'Paano ako sasali sa isang talakayan?',
            isEn 
              ? 'When viewing a landmark\'s details, click on the "Join Group Discussion" button to enter the chat room for that specific location.'
              : 'Kapag tinitingnan ang mga detalye ng isang palatandaan, i-click ang button na "Sumali sa Talakayan" upang makapasok sa chat room para sa partikular na lokasyong iyon.',
          ),
          _buildExpansionTile(
            isEn ? 'What are Native Facts?' : 'Ano ang mga Native Fact?',
            isEn 
              ? 'Native Facts are curated historical tidbits fetched directly from our native Java engine. You can find them in the Log section.'
              : 'Ang mga Native Fact ay mga na-curate na makasaysayang impormasyon na kinuha nang direkta mula sa aming native Java engine. Mahahanap mo sila sa seksyong Log.',
          ),
          _buildExpansionTile(
            isEn ? 'How do I logout?' : 'Paano ako mag-logout?',
            isEn 
              ? 'You can find the logout button in the top right corner of the main screen\'s app bar.'
              : 'Makikita mo ang logout button sa kanang sulok sa itaas ng app bar sa main screen.',
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(isEn ? 'Contact Us' : 'Makipag-ugnayan sa Amin', context),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.brown),
            title: Text(isEn ? 'Support Email' : 'Email ng Suporta'),
            subtitle: const Text('support@historyhub.com'),
          ),
          ListTile(
            leading: const Icon(Icons.web, color: Colors.brown),
            title: Text(isEn ? 'Website' : 'Websayt'),
            subtitle: const Text('www.historyhub.com'),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${isEn ? "Version" : "Bersyon"} 1.0.0',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(content, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}

// ==================== SETTINGS SCREEN ====================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showSetPinDialog(HistoryHubAppState appState) {
    final controller = TextEditingController();
    final isEn = appState.currentLanguage == 'en';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isEn ? 'Enable Parental Control' : 'I-enable ang Parental Control'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isEn ? 'Enter the fixed PIN (1234) to enable' : 'Ilagay ang fixed PIN (1234) para ma-enable'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(hintText: isEn ? 'Enter PIN' : 'Ilagay ang PIN'),
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isEn ? 'Cancel' : 'Kanselahin')),
          TextButton(
            onPressed: () {
              if (appState.verifyPin(controller.text)) {
                appState.setParentalControl(true);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn ? 'Parental Control Enabled' : 'Na-enable na ang Parental Control')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn ? 'Incorrect PIN' : 'Maling PIN')),
                );
              }
            },
            child: Text(isEn ? 'Confirm' : 'Kumpirmahin'),
          ),
        ],
      ),
    );
  }

  void _showDisablePinDialog(HistoryHubAppState appState) {
    final controller = TextEditingController();
    final isEn = appState.currentLanguage == 'en';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isEn ? 'Disable Parental Control' : 'I-disable ang Parental Control'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isEn ? 'Enter PIN (1234) to turn off' : 'Ilagay ang PIN (1234) para i-off'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'PIN'),
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isEn ? 'Cancel' : 'Kanselahin')),
          TextButton(
            onPressed: () {
              if (appState.verifyPin(controller.text)) {
                appState.setParentalControl(false);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn ? 'Parental Control Disabled' : 'Na-disable na ang Parental Control')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEn ? 'Incorrect PIN' : 'Maling PIN')),
                );
              }
            },
            child: Text(isEn ? 'Confirm' : 'Kumpirmahin'),
          ),
        ],
      ),
    );
  }

  void _showRevertDialog(HistoryHubAppState appState) {
    final isEn = appState.currentLanguage == 'en';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEn ? 'Revert Settings?' : 'Ibalik ang mga Setting?'),
        content: Text(isEn 
          ? 'This will reset theme, language, and parental controls to default.' 
          : 'Ise-reset nito ang tema, wika, at kontrol ng magulang sa default.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isEn ? 'Cancel' : 'Kanselahin')),
          TextButton(
            onPressed: () {
              appState.revertSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEn ? 'Settings reverted' : 'Naibalik na ang mga setting')),
              );
            },
            child: Text(isEn ? 'Revert' : 'Ibalik'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = HistoryHubApp.of(context);
    final isEn = appState.currentLanguage == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'Settings' : 'Mga Kasangkapan'),
        backgroundColor: isDark ? null : Colors.brown.shade50,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(isEn ? 'Appearance' : 'Anyo', context),
          SwitchListTile(
            title: Text(isEn ? 'Dark Mode' : 'Madilim na Tema'),
            secondary: Icon(appState.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.brown),
            value: appState.isDarkMode,
            activeColor: Colors.brown,
            onChanged: (val) => appState.toggleTheme(),
          ),
          const Divider(),
          _buildSectionHeader(isEn ? 'Language' : 'Wika', context),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: appState.currentLanguage,
            activeColor: Colors.brown,
            selected: appState.currentLanguage == 'en',
            onChanged: (val) => appState.setLanguage('en'),
            secondary: Icon(Icons.language, color: isDark ? Colors.brown.shade200 : Colors.brown),
          ),
          RadioListTile<String>(
            title: const Text('Filipino'),
            value: 'fil',
            groupValue: appState.currentLanguage,
            activeColor: Colors.brown,
            selected: appState.currentLanguage == 'fil',
            onChanged: (val) => appState.setLanguage('fil'),
            secondary: Icon(Icons.translate, color: isDark ? Colors.brown.shade200 : Colors.brown),
          ),
          const Divider(),
          _buildSectionHeader(isEn ? 'Safety' : 'Kaligtasan', context),
          SwitchListTile(
            title: Text(isEn ? 'Parental Control' : 'Kontrol ng Magulang'),
            subtitle: Text(isEn 
              ? 'Restrict access to community features' 
              : 'Limitahan ang access sa mga feature ng komunidad'),
            secondary: Icon(Icons.family_restroom, color: isDark ? Colors.brown.shade200 : Colors.brown),
            value: appState.isParentalControlEnabled,
            activeColor: Colors.brown,
            onChanged: (val) {
              if (val) {
                _showSetPinDialog(appState);
              } else {
                _showDisablePinDialog(appState);
              }
            },
          ),
          if (appState.isParentalControlEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                isEn ? 'Status: Active (PIN: 1234)' : 'Status: Aktibo (PIN: 1234)',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          const Divider(),
          _buildSectionHeader(isEn ? 'Maintenance' : 'Pagpapanatili', context),
          ListTile(
            title: Text(isEn ? 'Revert All Changes' : 'Ibalik Lahat ng Binago'),
            subtitle: Text(isEn ? 'Reset to factory defaults' : 'I-reset sa factory defaults'),
            leading: const Icon(Icons.restore, color: Colors.red),
            onTap: () => _showRevertDialog(appState),
          ),
          ListTile(
            title: Text(isEn ? 'Clear Cache' : 'Linisin ang Cache'),
            leading: Icon(Icons.delete_sweep, color: isDark ? Colors.brown.shade200 : Colors.brown),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEn ? 'Cache cleared' : 'Nalinis na ang cache')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// History section
class HistoryScreen extends StatelessWidget {
  final List<HistoryItem> history;
  final MethodChannel platform;

  const HistoryScreen({super.key, required this.history, required this.platform});

  void _fetchNativeFacts(BuildContext context) async {
    final appState = HistoryHubApp.of(context);
    final isEn = appState.currentLanguage == 'en';
    try {
      final String facts = await platform.invokeMethod('getHistoricalFacts');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isEn ? 'Daily Facts (from Java Engine)' : 'Araw-araw na Katotohanan (mula sa Java)'),
            content: Text(facts),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(isEn ? 'Cool!' : 'Astig!'))],
          ),
        );
      }
    } on PlatformException catch (_) {

    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = HistoryHubApp.of(context).currentLanguage == 'en';
    return Scaffold(
      appBar: AppBar(
        title: Text(isEn ? 'Learning Journey' : 'Paglalakbay sa Pag-aaral'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () => _fetchNativeFacts(context),
            tooltip: isEn ? 'Get Native Facts' : 'Kumuha ng Native Facts',
          ),
        ],
      ),
      body: history.isEmpty
          ? Center(child: Text(isEn ? 'Your journey begins here. Explore landmarks!' : 'Dito magsisimula ang iyong paglalakbay. Galugarin ang mga palatandaan!'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  leading: const Icon(Icons.account_balance, color: Colors.brown),
                  title: Text(item.title),
                  subtitle: Text('${isEn ? "Last studied" : "Huling pinag-aralan"}: ${item.timestamp.hour}:${item.timestamp.minute}'),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
    );
  }
}
