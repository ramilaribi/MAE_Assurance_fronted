import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Components/custom_site_card.dart';
import 'package:perper/side_menu.dart';
import 'package:perper/Screens/contracts.dart';
import 'package:perper/Screens/profile.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/transactions.dart';
import 'package:video_player/video_player.dart';
import 'dart:async'; // Import for Timer
import '../Services/auth_service.dart';
import 'claim.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late FancyDrawerController _controller;
  late VideoPlayerController _videoController;
  String selectedTile = 'Home';
  Map<String, dynamic>? user;
  List<String> list_contracts = <String>[
    'pack Scolaire',
    'Pack Family',
    'Pack Medical',
    'Pack Start-up',
  ];
  List<String> list_images = <String>[
    'scolaire.jpg',
    'family.jpg',
    'medical.jpg',
    'startup.jpg',
  ];

  bool _isPlaying = false;
  bool _showPlayButton = true;
  Timer? _hideButtonTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = FancyDrawerController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {}); // Must call setState
      });

    _videoController = VideoPlayerController.asset(
      'assets/images/video.mp4', // Path to your video asset
    )
      ..initialize().then((_) {
        setState(() {}); // When your video has initialized, call setState
      });

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    setState(() {
      user = userInfo;
    });
  }

  void onTileTap(String title) {
    setState(() {
      selectedTile = title;
      _controller.close();
    });

    // Pause the video before navigating
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    }

    switch (title) {
      case 'Home':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 'Contrats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContractsScreen()),
        );
        break;
      case 'Transactions':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionsScreen()),
        );
        break;
      case 'Claims':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClaimScreen()),
        );
        break;
      case 'Support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupportScreen()),
        );
        break;
      default:
        break;
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _showPlayButton = true;
        _hideButtonTimer?.cancel();
      } else {
        _videoController.play();
        _showPlayButton = false;
        _hideButtonAfterDelay();
      }
      _isPlaying = _videoController.value.isPlaying;
    });
  }

  void _hideButtonAfterDelay() {
    _hideButtonTimer?.cancel();
    _hideButtonTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showPlayButton = false;
      });
    });
  }

  void _onVideoTap() {
    setState(() {
      _showPlayButton = !_showPlayButton;
      if (_showPlayButton) {
        _hideButtonAfterDelay();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _videoController.dispose();
    _hideButtonTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FancyDrawerWrapper(
      backgroundColor: const Color(0xFFF7F9F4),
      controller: _controller,
      drawerItems: <Widget>[
        user != null
            ? SideMenu(onTileTap: onTileTap, selectedTile: selectedTile, user: user!)
            : CircularProgressIndicator(),  // Show loading indicator while user info is loading
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _controller.toggle(); // Toggle the drawer
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png', // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png', // Path to your logo image
                          height: 50, // Adjust the size as needed
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Together, united',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_videoController.value.isInitialized)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: GestureDetector(
                          onTap: _onVideoTap,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                              if (_showPlayButton)
                                CircleAvatar(
                                  radius: 25.0, // Adjust the radius to make it smaller
                                  backgroundColor: const Color.fromARGB(137, 60, 60, 60),
                                  child: IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 30.0, // Adjust the size to make it smaller
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: VideoProgressIndicator(
                                  _videoController,
                                  allowScrubbing: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'the MAE supports you',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 158, 162, 159)
                          ),
                        ),
                        Text(
                          'our covers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                    padding: EdgeInsets.zero,
                    itemCount: list_contracts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      var data = list_contracts[index];
                      var image = list_images[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                        child: CustomSiteCardView(name: data, img: image),
                      );
                    },
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
