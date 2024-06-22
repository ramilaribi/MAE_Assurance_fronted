import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perper/Components/info_card.dart';
import 'package:perper/Screens/login.dart';
import 'package:perper/Components/side_menu_tile.dart';

import 'Services/auth_service.dart';

class SideMenu extends StatefulWidget {
  final Function(String) onTileTap;
  final String selectedTile;
  final Map<String, dynamic> user;

  const SideMenu({
    Key? key,
    required this.onTileTap,
    required this.selectedTile,
    required this.user,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  void _logout() async {
    final authService = AuthService();
    await authService.clearUserInfo();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 1, 27, 3),
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            children: [
              InfoCard(
                name: widget.user['fullName'],
                profession: 'Adherant',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SideMenuTile(
                      onTileTap: widget.onTileTap,
                      selectedTile: widget.selectedTile,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height *0.14 ,),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}