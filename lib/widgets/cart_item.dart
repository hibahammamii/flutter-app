import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/cart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final num price;

  // final int quantity;
  final String title;
  final String type;
  List<Appetizer> appetizer;

  CartItem(
      this.id,
      this.productId,
      this.price,
      // this.quantity,
      this.title,
      this.type,
      this.appetizer);

  @override
  Widget build(BuildContext context) {
    final product =
        Provider.of<Products>(context, listen: false).findByIdCart(productId);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(id);
      },
      child: Container(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 4.h,
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: ListTile(
              leading: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.white70,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(backgroundColor: kPrimaryColor,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                  )),
                //  Image.network(product.imageUrl)),
              title: Row(
                children: [
                  Text(title + " "),
                  //SizedBox(width: ,)
                  type != null
                      ? Text(
                          type,
                          style:
                              TextStyle(fontSize: 12.sp, color: kPrimaryColor),
                        )
                      : Text(''),
                  Spacer(),
                  Text('${(price).toString()} L.E',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                ],
              ),
              subtitle: appetizer.length > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text("Adds:",
                                style: TextStyle(
                                    fontSize: 13.sp, color: Colors.black))),
                        Flexible(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    appetizer
                                        .map((e) => e.appetizerName)
                                        .toString(),
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ksecondaryColor)))),
                        // ListView.builder(
                        //  shrinkWrap: true,
                        //   scrollDirection: Axis.horizontal,
                        //   physics: NeverScrollableScrollPhysics(),
                        //
                        //
                        //   itemCount: appetizer.length,
                        //
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Container(
                        //       //height: 20,
                        //
                        //         child: Center(child: Text(appetizer[index].appetizerName,style: TextStyle(color: ksecondaryColor,fontSize: 10),)));
                        //
                        //
                        //   },
                        // ),)
                      ],
                    )
                  : Container(),
              //trailing:  Text('Total: ${(price).toString()} L.E'),
            ),

            //    child: Column(
            //
            //       children: [
            //         CircleAvatar(
            //           radius: 20,
            //           backgroundColor: Colors.white70,
            //
            //                 child:Image.network(product.imageUrl)
            //         ),
            //         Text(title ),
            //         type != null?
            //             Text(type):Text(''),
            //
            //         if(appetizer.length > 0)
            //           Text("Adds:"),
            //
            //
            //
            //         ListView.builder(
            //           shrinkWrap: true,
            //
            //
            //           itemCount: appetizer.length,
            //
            //           itemBuilder: (BuildContext context, int index) {
            //             return Container(
            //               //height: 20,
            //
            //                 child: Center(child: Text(appetizer[index].appetizerName,style: TextStyle(color: ksecondaryColor,fontSize: 10),)));
            //
            //
            //           },
            //         ),
            //         Text('Total: ${(price).toString()} L.E'),
            //       ],
            // )
          ),
        ),
      ),
    );
  }
}
