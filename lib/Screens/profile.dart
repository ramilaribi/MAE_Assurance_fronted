import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perper/Services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Screens/contracts.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/side_menu.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/transactions.dart';
import 'claim.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  String selectedTile = 'Profile';
  Map<String, dynamic>? user;
  bool _status = true;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();

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
    try {
      final authService = AuthService();
      final userInfo = await authService.getUserInfo();
      print('User info loaded: $userInfo');
      setState(() {
        user = userInfo;
        if (user != null) {
          _fullNameController.text = user!['fullName'] ?? '';
          _emailController.text = user!['email'] ?? '';
          _phoneNumberController.text = user!['phoneNumber'] ?? '';
          _addressController.text = user!['address'] ?? '';
          _birthdateController.text = user!['birthdate'] ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user info: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user info: ${e.toString()}')),
      );
    }
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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
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
          title: const Text('Profile'),
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : user != null
                ? Form(
              key: _formKey,
              child: _buildProfileView(),
            )
                : Center(child: Text('No user data available')),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
                 Image.asset(
                          'assets/images/logo.png',
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
              Card(
              color: const Color(0xFFF7F9F4),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          _status ? _getEditIcon() : Container(),
                        ],
                      ),
                      Divider(),
                      _buildInfoField('Full Name', _fullNameController),
                      _buildInfoField('Email ID', _emailController),
                      _buildInfoField('Phone Number', _phoneNumberController),
                      _buildInfoField('Address', _addressController),
                      _buildDatePickerField('Birthdate', _birthdateController),
                      !_status ? _getActionButtons() : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          TextFormField(
            controller: controller,
            enabled: !_status,
            autofocus: !_status,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5.0),
          GestureDetector(
            onTap: () async {
              if (!_status) {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    controller.text = pickedDate.toString().split(' ')[0];
                  });
                }
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                enabled: !_status,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$label cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: label,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("Save"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  if (user == null) {
                    print('User data is null');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User data is null')),
                    );
                    return;
                  }
                  print(user);
                  final authService = AuthService();
                  await authService.updateUser(
                    user!['id'],
                    _fullNameController.text,
                    _emailController.text,
                    _phoneNumberController.text,
                    _addressController.text,
                    _birthdateController.text,
                  );
                  _loadUserInfo();
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user: ${e.toString()}')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          ElevatedButton(
            child: Text("Cancel"),
            onPressed: () {
              setState(() {
                _status = true;
                FocusScope.of(context).requestFocus(FocusNode());
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 152, 152, 152),
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
