import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/category.dart';

import 'package:provider/provider.dart';
import '../widgets/category_item.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<Categories>(context,listen: true);
    final categories = categoriesData.cat;


    return Container(

      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                // builder: (c) => products[i],

                value: categories[i],
                child: CategryItem(
                  categories[i].id,
                  categories[i].name,
                  categories[i].image,
                ),
              )),
    );
  }
}
