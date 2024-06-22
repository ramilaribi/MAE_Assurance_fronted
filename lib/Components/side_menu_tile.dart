import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenuTile extends StatelessWidget {
  final Function(String) onTileTap;
  final String selectedTile;

  const SideMenuTile({
    super.key,
    required this.onTileTap,
    required this.selectedTile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDivider(),
        _buildListTile('Home', CupertinoIcons.home),
        _buildDivider(),
        _buildListTile('Profile', CupertinoIcons.person),
        _buildDivider(),
        _buildListTile('Contrats', CupertinoIcons.folder),
        _buildDivider(),
        _buildListTile('Claims', CupertinoIcons.square_pencil_fill),
        _buildDivider(),
        _buildListTile('Transactions', CupertinoIcons.money_dollar_circle),
        _buildDivider(),
        _buildListTile('Support', CupertinoIcons.phone),
        _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 24.0),
      child: Divider(
        color: Colors.white24,
        height: 1,
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    final bool isSelected = selectedTile == title;

    return GestureDetector(
      onTap: () => onTileTap(title),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 34,
            width: 54,
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.white,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(color: isSelected ? Color.fromARGB(255, 33, 150, 243) : Colors.white),
          ),
        ),
      ),
    );
  }
}
