import 'package:flutter/material.dart';
import 'package:flutter_app/providers/category.dart';
import 'package:provider/provider.dart';
import '../providers/category.dart';
import '../providers/products.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_app/constants.dart';


class CategryItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;

  String selected = "beef";

  CategryItem(this.id, this.name, this.image);


  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<CategoryP>(context, listen: false);
    final categoriesData = Provider.of<Categories>(context, listen: false);
    final product = Provider.of<Products>(context, listen: false);


    print("x=" + name);
    //final cart = Provider.of<Cart>(context, listen: false);
    //  final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      height: 30.h,
        margin: const EdgeInsets.only(left: 20),
        child: InkWell(
          onTap: () {
            product.findByCat(categoryData.name);
           categoriesData.setValue(name);
          //  selected =categorydata.name;
          },
          child: Column(
            children: <Widget>[
              Text(
                name.inCaps,
                style: categoriesData.selected == name
                    ? TextStyle(
                        color: kThirdColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,)
                    : TextStyle(fontSize: 15.sp),
              ),
              if (categoriesData.selected == categoryData.name)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: 3.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
            ],
          ),
        ));
  }
}
