import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joshua_joshua/util/util.dart';

class Item extends StatefulWidget {

  Item({this.id, this.title, this.description, this.price, this.removeItem, this.modifyQuantity});

  final String id;
  final String title;
  final String description;
  final double price;
  final void Function(int) removeItem;
  final void Function(int, int) modifyQuantity;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {

  String deleteItemId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.cart, color: Colors.white,),
                onPressed: () {
                  showCartModal(context, cart, widget.removeItem, widget.modifyQuantity, gotoCheckOutPage);
                  // for (int i = 0; i <= widget.cart.length; i++) {
                  //   if (widget.cart[i]['id'] == deleteItemId) {
                  //     setState(() {
                  //       widget.cart.remove(i);
                  //     });
                  //     break;
                  //   }
                  // }
                  // widget.modifyCart(deleteItemId);
                },
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .45,
                child: Row(
                  children: [
                    Container(),
                    Expanded(
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                      ),
                    )
                  ],
                ),
              ),
              // quantity btn & add to cart
              //description
            ],
          ),
        ),
      ),
    );
  }
}