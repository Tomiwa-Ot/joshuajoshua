import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joshua_joshua/screens/shop/items.dart';
import 'package:joshua_joshua/util/util.dart';

class Shop extends StatefulWidget {

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  Stream<DocumentSnapshot> stream;

  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection("products").doc().snapshots();
  }


  void removeItem(int index) {
    setState(() {
      cart.remove(index);
    });
  }

  void modifyQuantity(int index, int value) {
    setState(() {
      if (cart[index]['quantity'] + value == 0) {
        cart.remove(index);
        return;
      }
      cart[index]['quantity'] = cart[index]['quantity'] + value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.cart, color: Colors.white,),
                onPressed: () => showCartModal(context, cart, removeItem, modifyQuantity, gotoCheckOutPage),
              )
            ],
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator()
              ],
            );
          }

          List<DocumentSnapshot> docs = snapshot.data.data();
          List<Widget> items = docs.map((doc) => Items(
            title: doc.get("title"),
            description: doc.get("description"),
            price: doc.get("price")
          )).toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            }
          );

        },
      ),
    );
  }
}