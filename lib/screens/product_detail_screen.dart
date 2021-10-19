
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/price.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/screens/cart_screen.dart';

import 'package:flutter_app/widgets/AnimatedBottomNavigationBar.dart';
import 'package:flutter_app/widgets/appetizer_item.dart';
import 'package:flutter_app/widgets/price_tile.dart';
import 'package:flutter_app/widgets/size_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


import '../constants.dart';
import '../providers/products.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double statusBar = MediaQuery.of(context).padding.top;
    final priceProvider = Provider.of<PriceProvider>(context, listen: true);
    final cart = Provider.of<Cart>(context, listen: false);
    final appetizerProvider =
        Provider.of<AppetizerProvider>(context, listen: false);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    List<Appetizer> checkAppetizer = [];

    return Scaffold(
      //backgroundColor: Color(0xfff4f0ec),
      appBar: AppBar(
       // toolbarHeight: MediaQuery.of(context).size.height *0.07 ,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            priceProvider.setValue(null);
            priceProvider.setPrice(null);
            appetizerProvider.items.forEach((element) {
             element.setFavValue(false);
            });

            Navigator.pop(context);
          },
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loadedProduct.title,
          style: TextStyle(color: kPrimaryColor),
        ),
        actions: <Widget>[
          IconButton(
            onPressed:() {Navigator.of(context).pushNamed(CartScreen.routeName);},

            color: Colors.black,
            icon: Icon(
              Icons.shopping_cart,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height:(height - statusBar) * 0.78,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 200.h,
                    width: 320.w,
                    child: CachedNetworkImage(
                      imageUrl: loadedProduct.imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(backgroundColor: kPrimaryColor,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                    )),
                  //   Image.network(
                  //     loadedProduct.imageUrl,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r)), //here
                      color: Color(0xfff4f0ec),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Description",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                )),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            //height: 80.h,
                            padding:const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: Text(loadedProduct.description != null ?
                            loadedProduct.description.replaceAll("/n", "\n") : '',
                                textAlign:loadedProduct.category == "meals" || loadedProduct.category =='appetizer' ? TextAlign.left: TextAlign.right,
                                softWrap: true,
                                maxLines: 12,
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                )),
                          ),
                          // SizedBox(height: 10.h),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          if(loadedProduct.isMeal == false)
                            isNotMeal(productId),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),



          Container(
           // margin: EdgeInsets.only(bottom: 12),
            // color: Color(0xfff4f0ec),
           height: (height -statusBar) * 0.10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: PriceTile(productId),
                    ),
                    Spacer(),
                    Container(
                      height: 39.h,
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: TextButton(
                        onPressed: () {
                          if(loadedProduct.isMeal == true)
                           { cart.addItem(
                                loadedProduct.id,
                                loadedProduct.priceMeal,
                                loadedProduct.title,
                                '',
                                checkAppetizer);
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                             content: Text("the order has been added to the cart"),
                             //  width: 200.0.w,
                             backgroundColor: ksecondaryColor,
                             width: 280.0,
                             duration: const Duration(milliseconds: 1000),// Width of the SnackBar.
                             padding: const EdgeInsets.symmetric(
                               horizontal: 20.0, // Inner padding for SnackBar content.
                             ),
                             behavior: SnackBarBehavior.floating,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),

                           ));}
                         else if (priceProvider.selected == null) {
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
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ));
                          } else {


                            appetizerProvider.items.forEach((element) {
                              if (element.ischeck == true)
                              checkAppetizer.add(element);
                            });
                            print(checkAppetizer);

                            cart.addItem(
                                loadedProduct.id,
                                priceProvider.price,
                                loadedProduct.title,
                                priceProvider.selected,
                                checkAppetizer);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("the order has been added to the cart"),
                             //  width: 200.0.w,
                              backgroundColor: ksecondaryColor,
                              width: 280.0,
                              duration: const Duration(milliseconds: 1000),// Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                            ));

                            priceProvider.setValue(null);
                            priceProvider.setPrice(null);
                            appetizerProvider.items.forEach((element) {
                              element.setFavValue(false);
                            });
                            // appetizerProvider.items.forEach((element) {
                            //  element.setFavValue(false);
                            // });
                          }
                        },
                        child: Text("Add to cart"),
                        style: TextButton.styleFrom(
                          // side: BorderSide(color: Colors.deepOrange, width: 1),
                          elevation: 4,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          backgroundColor: kPrimaryColor,
                          primary: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: AnimatedBottom(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: AnimatedBar(),
    );
  }
}

class AppetizerList extends StatelessWidget {
  AppetizerList();

  //bool isChecked = false;

  List<Appetizer> appetizer;

  @override
  Widget build(BuildContext context) {
    final appetizer = Provider.of<AppetizerProvider>(context);
    Provider.of<Appetizer>(
        context,
        listen:true );
    final app = appetizer.items;

    return
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: app.length,
       // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            // builder: (c) => products[i],

            value: app[i],
            child: AppetizerItem()),

    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
class isNotMeal extends StatelessWidget {
  final String productId;

  isNotMeal(this.productId);

  @override
  Widget build(BuildContext context) {
    Provider.of<Appetizer>(
      context,
      listen:true );
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);



    return Column(
      children: [
      Divider(color: Colors.black),
      Align(
        alignment: Alignment.topLeft,
        child: Text("Type",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),

      ListView.builder(
          shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
         // scrollDirection: Axis.vertical,
          itemCount: loadedProduct.type.length,
          itemBuilder: (ctx, i) =>
              ChangeNotifierProvider.value(
                // builder: (c) => products[i],

                  value: loadedProduct.type[i],
                  child: SizeItem(
                    loadedProduct.type[i].typeId,
                    loadedProduct.type[i].price,
                    // loadedProduct.title,
                    // loadedProduct.id
                  ))),


      Divider(color: Colors.black),
      Align(
        alignment: Alignment.topLeft,
        child: Text("Adds",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),

          AppetizerList(),

    ],);
  }
}