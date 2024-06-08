import 'package:flutter/material.dart';
import 'package:h4food/views/screens/home/home_navigation/product_screen.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/provider/product_provider.dart';
import '../../../../models/product_model.dart';
import '../../../app_widgets.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.productModelList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: productProvider.productModelList.length,
              itemBuilder: (context, index) {
                final product = productProvider.productModelList[index];
                return ListTile(
                  title: Text(product.productName ?? ''),
                  subtitle: Text(product.productDescription ?? ''),
                  trailing: ClipRRect(
                    child: Image.network(product.productImages.toString()),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(AppWidgets.createRoute(
                        pageName: ProductScreen(
                      productModel: product,
                    )));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<ProductModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, ProductModel());
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final filteredProducts = provider.productModelList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          title: Text(product.productName ?? ''),
          subtitle: Text(product.productDescription ?? ''),
          trailing: ClipRRect(
            child: Image.network(product.productImages.toString()),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          onTap: () {
            Navigator.of(context).push(AppWidgets.createRoute(
                pageName: ProductScreen(
              productModel: product,
            )));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final suggestions = provider.productModelList
        .where((product) =>
            product.productName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(product.productName ?? ''),
            trailing: ClipRRect(
              child: Image.network(product.productImages.toString()),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            onTap: () {
              query = product.productName!;
              showResults(context);
            },
          ),
        );
      },
    );
  }
}
