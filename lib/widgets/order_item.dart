import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;


  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount.toString()} L.E'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),

            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),

            child: Row(
              children: [
               Text("Order Status :   "),
                widget.order.orderStatus ==0?
                    Column(
                      children: [
                        Icon(Icons.watch_later),
                        Text("wait for receipt your order"),
                      ],
                    ):
                widget.order.orderStatus ==1 ?
                Column(
                  children: [
                    Icon(Icons.fastfood,color: kPrimaryColor,),
                    Text("Papa's received your order"),
                  ],
                ):
                Column(
                  children: [
                    Icon(Icons.done_outline_outlined,color: Colors.red,),
                    Text("Done!"),
                  ],
                ),


                    // Text(widget.order.orderStatus ==0 ? "Preparing" : "Finish"
                    //   ,style: TextStyle(color: widget.order.orderStatus ==0 ? Colors.red : Colors.green  ),)
              ],
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title+"  "+prod.type,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' ${prod.price.toString()} L.E',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
