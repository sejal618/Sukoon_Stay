import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class UpiPayPage extends StatefulWidget {
  @override
  _UpiPayPageState createState() => _UpiPayPageState();
}

class _UpiPayPageState extends State<UpiPayPage> {
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  // Fetch the list of UPI apps installed on the device
  void _fetchUpiApps() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
  }

  // Method to initiate the UPI transaction
  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "8103584263@ibl",
      receiverName: 'Sejal Shah',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Sample Payment',
      amount: 1.00,
    );
  }

  // Handle UPI transaction responses
  void _handleUpiResponse(UpiResponse response) {
    String statusMessage;
    switch (response.status) {
      case UpiPaymentStatus.SUCCESS:
        statusMessage = "Transaction Successful!";
        break;
      case UpiPaymentStatus.SUBMITTED:
        statusMessage = "Transaction Submitted!";
        break;
      case UpiPaymentStatus.FAILURE:
        statusMessage = "Transaction Failed!";
        break;
      default:
        statusMessage = "Unknown status!";
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(statusMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPI Payment"),
        backgroundColor: Colors.green,
      ),
      body: apps == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apps!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.memory(apps![index].icon),
                  title: Text(apps![index].name),
                  onTap: () async {
                    UpiResponse response = await initiateTransaction(apps![index]);
                    _handleUpiResponse(response);
                  },
                );
              },
            ),
    );
  }
}
