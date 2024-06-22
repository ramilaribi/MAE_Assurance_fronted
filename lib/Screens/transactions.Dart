import 'package:flutter/material.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:perper/Screens/profile.dart';
import 'package:perper/Screens/support.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/Screens/contracts.dart';
import 'package:perper/side_menu.dart';
import '../Services/auth_service.dart';
import '../Services/transactionService.dart';
import 'package:intl/intl.dart';
import 'claim.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late FancyDrawerController _controller;
  String selectedTile = 'Transactions';
  Map<String, dynamic>? user;
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
      vsync: this,
      duration: Duration(milliseconds: 250),
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
    if (userInfo != null) {
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    final transactionService = TransactionService();
    try {
      final userTransactions = await transactionService.getUserTransactions();
      setState(() {
        transactions = userTransactions;
      });
    } catch (e) {
      print('Error loading transactions: $e');
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
          title: Text('Transactions'),
          leading: IconButton(
            icon: Icon(Icons.menu),
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
            transactions.isNotEmpty
                ? ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  )
                : Center(
                    child: Text('No transactions found.'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    Color cardColor = Colors.white;
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(transaction['createdAt']));

    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: const Color(0xFFF7F9F4),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.monetization_on, color: Colors.white),
        ),
        title: Text(
          'Transaction ID: ${transaction['_id']}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('Amount: \$${transaction['payment']['amount'].toStringAsFixed(2)}'),
            SizedBox(height: 5),
            Text('Contract ID: ${transaction['payment']['contract']}'),
            SizedBox(height: 5),
            Text('Transaction Type: ${transaction['transactionType']}'),
            SizedBox(height: 5),
            Text('Date: $formattedDate'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => _showTransactionDetails(context, transaction),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, dynamic transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
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
                    Icons.monetization_on,
                    color: Colors.blue,
                    size: 90.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text('Transaction ID: ${transaction['_id']}'),
              SizedBox(height: 10.0),
              Text('Amount: \$${transaction['payment']['amount'].toStringAsFixed(2)}'),
              SizedBox(height: 10.0),
              Text('Contract ID: ${transaction['payment']['contract']}'),
              SizedBox(height: 10.0),
              Text('Transaction Type: ${transaction['transactionType']}'),
              SizedBox(height: 10.0),
              Text('Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(transaction['createdAt']))}'),
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
              },
            ),
          ],
        );
      },
    );
  }
}
