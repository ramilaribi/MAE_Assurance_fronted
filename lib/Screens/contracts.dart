import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Model/contract.dart';
import 'package:perper/side_menu.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/Screens/profile.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/transactions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../Services/auth_service.dart';
import '../Services/contract_Service.dart';
import '../Services/payment_service.dart';
import 'claim.dart';

class ContractsScreen extends StatefulWidget {
  @override
  _ContractsScreenState createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  String selectedTile = 'Contrats';
  Map<String, dynamic>? user;
  late Future<List<Contract>> futureContracts;
  List<Contract> _contracts = [];
  List<Contract> _filteredContracts = [];
  TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _paymentStatus = {};
  final ContractService contractService = ContractService();

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
    _fetchContractsForUser();
    _searchController.addListener(_filterContracts);
  }

  Future<void> _loadUserInfo() async {
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    setState(() {
      user = userInfo;
    });
  }

  Future<void> _fetchContractsForUser() async {
    final contracts = await contractService.fetchContractsForUser();
    contractService.checkAndMarkExpiredContracts(contracts);
    setState(() {
      _contracts = contracts;
      _filteredContracts = contracts;
    });
  }

  void _filterContracts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContracts = _contracts.where((contract) {
        final coverageDetails = contract.coverageDetails.toLowerCase();
        return coverageDetails.contains(query);
      }).toList();
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FancyDrawerWrapper(
      backgroundColor: const Color(0xFF17203A),
      controller: _controller,
      drawerItems: <Widget>[
        user != null
            ? SideMenu(onTileTap: onTileTap, selectedTile: selectedTile, user: user!)
            : CircularProgressIndicator(),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contracts'),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contracts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildContractsList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractsList() {
    return ListView.builder(
      itemCount: _filteredContracts.length,
      itemBuilder: (context, index) {
        Contract contract = _filteredContracts[index];
        Color cardColor;
        switch (contract.status) {
          case 'Active':
            cardColor = Color.fromARGB(255, 18, 160, 75);
            break;
          case 'Expired':
            cardColor = Color.fromARGB(255, 200, 200, 208);
            break;
          default:
            cardColor = Colors.white;
        }

        String formattedStartDate = contractService.formatContractDate(contract.startDate);
        String formattedEndDate = contractService.formatContractDate(contract.endDate);

        return Card(
          margin: EdgeInsets.all(10.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: cardColor,
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.description, color: Colors.white),
            ),
            title: Text(
              'Contract ID: ${contract.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text('Coverage Details: ${contract.coverageDetails}'),
                SizedBox(height: 5),
                Text('Prime: \$${contract.prime.toStringAsFixed(2)}'),
                SizedBox(height: 5),
                Text('Status: ${contract.status}'),
                SizedBox(height: 5),
                Text('Start Date: $formattedStartDate'),
                SizedBox(height: 5),
                Text('End Date: $formattedEndDate'),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: contract.status == 'Active' ? null : () => _showContractDetails(context, contract),
          ),
        );
      },
    );
  }

  Future<void> _handlePayment(Contract contract) async {
    print('Starting payment process for contract ${contract.id}');
    final paymentService = PaymentService();
    final paymentIntent = await paymentService.createPaymentIntent(contract.id, contract.prime);

    if (paymentIntent != null) {
      print('Payment Intent created successfully: ${paymentIntent['client_secret']}');
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          style: ThemeMode.system,
          merchantDisplayName: 'MAE',
        ),
      );

      try {
        print('Presenting payment sheet...');
        await stripe.Stripe.instance.presentPaymentSheet();
        print('Payment sheet presented, confirming payment...');

        // Handle the payment confirmation here
        final confirmation = await paymentService.confirmPayment(
          paymentIntent['paymentIntentId'],
          paymentIntent['paymentID'],
        );

        _fetchContractsForUser(); // Refresh contracts list to reflect updated date
        if (confirmation['paymentStatus'] == 'Succeeded') {
          print('Payment succeeded');
          setState(() {
            _paymentStatus[contract.id] = true;
          });
        }
      } catch (e) {
        print('Error presenting payment sheet: $e');
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Payment Cancelled',
          text: 'Payment for contract ${contract.id} was cancelled.',
        );
      }
    } else {
      print('Failed to create Payment Intent');
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Payment Error',
        text: 'Failed to create payment intent for contract ${contract.id}.',
      );
    }
  }

  void _showContractDetails(BuildContext context, Contract contract) async {
    bool isPaid = _paymentStatus[contract.id] ?? false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 99, 99, 99),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(
                    isPaid ? Icons.info : Icons.payment,
                    color: isPaid ? Colors.blue : Color.fromARGB(255, 0, 132, 255),
                    size: 90.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Contract Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text('Coverage Details: ${contract.coverageDetails}'),
              SizedBox(height: 10.0),
              Text('Prime: \$${contract.prime.toStringAsFixed(2)}'),
              SizedBox(height: 10.0),
              Text('Start Date: ${contract.startDate.toLocal().toString().split(' ')[0]}'),
              SizedBox(height: 10.0),
              Text('End Date: ${contract.endDate.toLocal().toString().split(' ')[0]}'),
              SizedBox(height: 10.0),
              Text('Status: ${contract.status}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (!isPaid) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    title: 'Payment Cancelled',
                    text: 'Payment for contract ${contract.id} was cancelled.',
                  );
                }
              },
            ),
            if (!isPaid)
              TextButton(
                child: Text('Purchase'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(Duration(milliseconds: 100));
                  _handlePayment(contract);
                },
              ),
          ],
        );
      },
    );
  }
}
