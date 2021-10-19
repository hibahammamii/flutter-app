import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/orders.dart' as ord;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderEditItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderEditItem(this.order);

  @override
  _OrderEditItemState createState() => _OrderEditItemState();
}

class _OrderEditItemState extends State<OrderEditItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<ord.Orders>(context, listen: false);
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
          // Container(
          //   margin: EdgeInsets.all(10),
          //   child: Row(
          //     children: [
          //       Text("Order Status : "),
          //       Text(
          //         widget.order.orderStatus == 0 ? "Preparing" : "Finish",
          //         style: TextStyle(
          //             color: widget.order.orderStatus == 0
          //                 ? Colors.red
          //                 : Colors.green),
          //       )
          //     ],
          //   ),
          // ),
          // if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            // height: min(widget.order.products.length * 20.0 + 10, 100),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: widget.order.products
                  .map(
                    (prod) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title + "  " + prod.type,
                              style:
                                  TextStyle(fontSize: 18, color: kPrimaryColor
                                      // fontWeight: FontWeight.bold,
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
                        if (prod.appetizer.length > 0)
                          Text(
                            "Adds",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                        ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: prod.appetizer
                                .map((adds) => Text(adds.appetizerName))
                                .toList()),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Column(
              children: [
                Text("Client info",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("name: ",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    Text(widget.order.name + " " + widget.order.lastName),
                  ],
                ),
                Row(
                  children: [
                    Text("Phone Number: ",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    Text(widget.order.phoneNumber),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _launch("tel:" + widget.order.phoneNumber);
                      },
                      child: Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.phone,
                            color: kThirdColor,
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Address: ",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    Flexible(
                        child: Text(
                      widget.order.address,
                      maxLines: 6,
                    )),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
               InfoButton(text: "accept", color: Colors.green, num: 1,order: widget.order,),
              InfoButton(text: "done", color: Colors.red, num: 2,order: widget.order,),
            ],
          ),
        ],
      ),
    );
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }
}

class InfoButton extends StatefulWidget {
  String text;
  Color color;
  int num;
  final ord.OrderItem order;

  InfoButton({this.text, this.num, this.color,this.order});

  @override
  _InfoButtonState createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  var _isLoading = false;



  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<ord.Orders>(context, listen: false);
    return _isLoading
        ? CircularProgressIndicator()
        : TextButton(
            child: Text(widget.text, style: TextStyle(color: widget.color)),
            onPressed: () {
              setState(() {
                _isLoading =true;
              });
              orderProvider.editOrder(widget.order.id,widget.num);
              setState(() {
                _isLoading = false;
              });

            },
          );
    // TODO: implement build
    throw UnimplementedError();
  }
}
