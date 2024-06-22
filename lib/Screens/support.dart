import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/Services/auth_service.dart';
import 'package:perper/side_menu.dart';
import 'package:perper/Screens/contracts.dart';
import 'package:perper/Screens/profile.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/transactions.dart';

import 'claim.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  String selectedTile = 'Support';
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
      setState(() {});
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FancyDrawerWrapper(
      backgroundColor: const Color(0xFFF7F9F4),
      controller: _controller,
      drawerItems: <Widget>[
        user != null
            ? SideMenu(onTileTap: onTileTap, selectedTile: selectedTile, user: user!)
            : CircularProgressIndicator(),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _controller.toggle();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'MAE Assurances',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                   color: const Color(0xFFF7F9F4),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text('Avenue Ouled Haffouz Bab El Khadra\n1075 Tunis'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Tel: 70 020 300\nFax: 71 324 147'),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('E-mail: mae.assurances@mae.tn'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 5,
                    color: const Color(0xFFF7F9F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Our Services',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Particuliers'),
                          ),
                          ListTile(
                            leading: Icon(Icons.business),
                            title: Text('Professionnels/Entreprises'),
                          ),
                          ListTile(
                            leading: Icon(Icons.group),
                            title: Text('Associations/Corporations'),
                          ),
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text('Tout sur nous'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
