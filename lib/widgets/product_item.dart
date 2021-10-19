import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/providers/price.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap:() => {
      Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: product.id,
      ),
      } ,
      child: Container(


        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset.zero,
                  blurRadius: 15.0)
            ],
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          children: [
            Container(
             height: 150.h,
              child: Stack(
                children: [
                  Container(

                      margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
                    alignment: Alignment.topCenter,

                          child:

                       CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              placeholder: (context, url) => CircularProgressIndicator(backgroundColor: kPrimaryColor,value:0, ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                         width: double.infinity,
                            ),
                        // image: NetworkImage(
                        //
                        //   product.imageUrl,
                        //   // width: double.infinity,
                        // ),
                      ),
                  Consumer<Product>(
                    builder: (ctx, product, _) => Positioned(
                      right: 1,
                      child: IconButton(
                          alignment: Alignment.topLeft,
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            product.toggleFavoriteStatus(
                              authData.token,
                              authData.userId,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(

              child: Column(
                children: [
                  Container(
                   // height: 21.h,
                    alignment: Alignment.topCenter,
                    child: Text(
                      product.title.capitalizeFirstofEach,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kThirdColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                   height: 35.h,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          product.isMeal == true ?
                              Text("${product.priceMeal.toString()}  L.E"):
                          Text("${product.type[0].price.toString()}  L.E"),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ProductDetailScreen.routeName,
                                arguments: product.id,
                              );
                            },
                            child: Text("More Info"
                                //  textAlign: TextAlign.center,
                                ),
                            style: TextButton.styleFrom(
                              primary: kPrimaryColor,
                              //backgroundColor: kThirdColor,
                              textStyle: TextStyle(

                                  //color: kPrimaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
