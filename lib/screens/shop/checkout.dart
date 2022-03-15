import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {

  Checkout({this.cart, this.removeItem, this.modifyQuantity});

  final List<Map<String, dynamic>> cart;
  final void Function(int) removeItem;
  final void Function(int, int) modifyQuantity;

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {

                      },
                    ),
                  ); 
                },
              ),
              // pay button
            ],
          )
        ),
      ),
    );
  }
}