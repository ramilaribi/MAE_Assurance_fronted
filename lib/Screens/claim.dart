import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Model/contract.dart';
import 'package:perper/Services/auth_service.dart';
import 'package:perper/Services/claim_service.dart';
import 'package:perper/side_menu.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/Screens/profile.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/transactions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'contracts.dart';

class ClaimScreen extends StatefulWidget {
  @override
  _ClaimScreenState createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  String selectedTile = 'Reclamation';
  Map<String, dynamic>? user;
  late Future<List<Contract>> futureContracts;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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

  Future<void> _createClaim() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final claimService = ClaimService();

      try {
        await claimService.createClaim(title, description);
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Claim created successfully!",
        );
      } catch (e) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: e.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
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
          title: const Text('Claims'),
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                'Feedback Form',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.title),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                maxLines: 5,
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _createClaim,
                                  child: Text('Submit', style: TextStyle(color: Colors.black),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 53, 129, 46),
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
