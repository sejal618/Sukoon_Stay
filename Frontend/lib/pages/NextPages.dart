import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class NextPage extends StatefulWidget {
  final double amount; // Declare the amount parameter

  NextPage({required this.amount}); // Constructor to accept the amount

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  void _fetchUpiApps() async {
    try {
      List<UpiApp> fetchedApps =
          await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
      setState(() {
        apps = fetchedApps;
      });
    } catch (e) {
      setState(() {
        apps = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching UPI apps: ${e.toString()}')),
      );
    }
  }

  Future<void> _initiateTransaction(UpiApp app) async {
    try {
      UpiResponse response = await _upiIndia.startTransaction(
        app: app,
        receiverUpiId: "8103584263@ibl",
        receiverName: 'Sejal Shah',
        transactionRefId: DateTime.now().millisecondsSinceEpoch.toString(),
        transactionNote: 'Sample Payment',
        amount: widget.amount, // Use the passed amount
      );

      _handleTransactionResponse(response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction Error: ${e.toString()}')),
      );
    }
  }

  void _handleTransactionResponse(UpiResponse response) {
    String statusMessage;

    switch (response.status) {
      case UpiPaymentStatus.SUCCESS:
        statusMessage = 'Transaction Successful!';
        break;
      case UpiPaymentStatus.SUBMITTED:
        statusMessage = 'Transaction Submitted!';
        break;
      case UpiPaymentStatus.FAILURE:
        statusMessage = 'Transaction Failed!';
        break;
      default:
        statusMessage = 'Unknown Status!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(statusMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose UPI Payment App'),
        backgroundColor: Colors.black, // Set AppBar color to black
      ),
      body: apps == null
          ? Center(child: CircularProgressIndicator())
          : (apps!.isEmpty
              ? Center(
                  child: Text(
                    'No UPI apps found on your device.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: apps!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.memory(apps![index].icon),
                      title: Text(apps![index].name),
                      onTap: () => _initiateTransaction(apps![index]),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, 
                          foregroundColor: Colors.white, 
                        ),
                        onPressed: () => _initiateTransaction(apps![index]),
                        child: Text('Pay'),
                      ),
                    );
                  },
                )),
    );
  }
}