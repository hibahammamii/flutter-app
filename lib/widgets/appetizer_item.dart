import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/widgets/custom_check_box.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/cart.dart';
import '../providers/price.dart';
import '../providers/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppetizerItem extends StatelessWidget {
  //  final String appetizerId;
  // final double appetizerPrice;
  // final String appetizerName;
  //
  //
  //
  // AppetizerItem({
  //   this.appetizerId,
  //   this.appetizerName,
  //   this.appetizerPrice,
  //
  //
  // });

  @override
  Widget build(BuildContext context) {
    final priceProvider = Provider.of<PriceProvider>(context);
    final appetizer = Provider.of<Appetizer>(context);

    return Container(
      margin: EdgeInsets.only(right: 14),
      padding: EdgeInsets.symmetric(vertical: 3),
      // height: 20.h,
        child: Row(
          children: [
            Checkbox(
              // borderColor: Colors.black45,
              // selectedColor: Colors.white,
              // selectedIconColor: kPrimaryColor,
              checkColor: ksecondaryColor,
              activeColor: kPrimaryColor,
              //fillColor: MaterialStateProperty.all(value) ,

              value: appetizer.ischeck,
              onChanged: (value) {
                if (priceProvider.selected == null) {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Warning'),
                            content: const Text('Please select sandwich type'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                } else {
                  appetizer.setFavValue(value);

                  if (appetizer.ischeck != false)
                    priceProvider.addPrice(appetizer.appetizerPrice);
                  else
                    priceProvider.minPrice(appetizer.appetizerPrice);
                }
              },
            ),
            Text(appetizer.appetizerName),
            Spacer(),
            Text("${appetizer.appetizerPrice} L.E" ,style: TextStyle(fontSize: 11), )
          ],
        ));
  }
}
