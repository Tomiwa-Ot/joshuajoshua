import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joshua_joshua/screens/transactions.dart';
// import 'package:joshua_joshua/util/util.dart';

class Wallet extends StatefulWidget {

  Wallet({this.email});

  final String email;

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  User user = FirebaseAuth.instance.currentUser;
  Stream<DocumentSnapshot> stream;

  void initState() {
    super.initState();
    stream = user != null ? FirebaseFirestore.instance.collection("transactions")
        .doc(user.uid).snapshots() : null;
    // PaystackPlugin.initialize(publicKey: PAYSTACK_PUBKEY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .4,
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .4,
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) { 
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No transactions",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0
                          ),
                        )
                      ],
                    );
                  }

                  List<DocumentSnapshot> docs = snapshot.data.data();
                  List<Widget> transactions = docs.map((doc) => Transactions()).toList();
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return transactions[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}