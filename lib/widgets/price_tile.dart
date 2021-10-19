import 'package:flutter/material.dart';
import 'package:flutter_app/providers/price.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:provider/provider.dart';


class PriceTile extends StatelessWidget {
  //const PriceTile({ Key? key }) : super(key: key);
  String prodId;
  PriceTile(this.prodId);

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(prodId);
    final priceProvider = Provider.of<PriceProvider>(context);

    return  loadedProduct.isMeal == true ?
        Text('${loadedProduct.priceMeal.toString()} L.E'):
      priceProvider.selected == null
          ? Text('0.00')
          : Text('${priceProvider.price.toString()} L.E');

  }
}
