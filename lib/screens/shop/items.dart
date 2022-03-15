import 'package:flutter/material.dart';
import 'package:joshua_joshua/screens/shop/item.dart';

class Items extends StatefulWidget {

  Items({this.id, this.title, this.description, this.price});

  final String id;
  final String title;
  final String description;
  final double price;


  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            subtitle: Column(
              children: [
                Text(widget.description),
                Text(widget.price.toString())
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Item(
                  id: widget.id,
                  title: widget.title,
                  description: widget.description,
                  price: widget.price,
                )
              ));
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .3),
            child: Divider(
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }
}