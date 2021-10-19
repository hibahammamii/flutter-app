import 'package:flutter/material.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/cart.dart';
import '../providers/price.dart';
import '../providers/product.dart';

class SizeItem extends StatelessWidget {
 final String idPrice;
  final num price;
  SizeItem(this.idPrice, this.price);
  @override
  Widget build(BuildContext context) {
    final priceProvider = Provider.of<PriceProvider>(context);
    final appetizerProvider = Provider.of<AppetizerProvider>(context,listen: true);
    final app =appetizerProvider.items;
    return Container(
      margin: EdgeInsets.only(right: 14),
      child: Row(children: [
        Radio(
          activeColor: kPrimaryColor,
          value: idPrice,
          groupValue: priceProvider.selected,
          onChanged: (value) {
            priceProvider.setValue(idPrice);
            priceProvider.setPrice(price);
            app.forEach((element) {element.setFavValue(false);});
          },
        ),
        Text(idPrice),
        Spacer(),
        Text("${price.toString()} L.E" ,style: TextStyle(fontSize: 11),)
      ],

      ),
      //Radio(value: value, groupValue: groupValue, onChanged: onChanged)
      // TextButton(
      //   onPressed: () {
      //     priceProvider.setValue(idPrice);
      //     priceProvider.setPrice(price);
      //     /* cart.addItem( widget.id,widget.price,widget.title,widget.idprice
      //     );*/
      //    // print(id + price.toString() + title + "  "+idPrice);
      //   },
      //   child: Text(idPrice
      //       //  textAlign: TextAlign.center,
      //       ),
      //   style: TextButton.styleFrom(
      //     backgroundColor: priceProvider.selected == idPrice
      //         ? kPrimaryColor
      //         : ksecondaryColor,
      //     primary: Colors.white,
      //     textStyle: TextStyle(
      //         color: Colors.black,
      //         fontSize: 12,
      //         fontStyle: FontStyle.normal),
      //   ),
      // ),


    );
  }
}
